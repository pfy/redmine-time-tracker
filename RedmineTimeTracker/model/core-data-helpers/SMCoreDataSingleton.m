//
//  SMCoreDataSignleton.m
//  timeTracker
//
//  Created by pfy on 09.04.14.
//  Copyright (c) 2014 smooh GmbH. All rights reserved.
//

#import "SMCoreDataSingleton.h"
@interface SMCoreDataSingleton()
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectContext *backgroundSavingContext;

@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@end


@implementation SMCoreDataSingleton



+ (instancetype)sharedManager
{
    static id SharedManager = nil;
    @synchronized(self) {
        static dispatch_once_t SharedManagerToken;
        dispatch_once(&SharedManagerToken, ^{
            SharedManager = [[[self class] alloc] init];
        });
    }
    return SharedManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}



#pragma mark - Core Data stack
- (NSManagedObjectContext *)backgroundSavingContext
{
    if (_backgroundSavingContext != nil) {
        return _backgroundSavingContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = self.persistentStoreCoordinator;
    if (coordinator != nil) {
        _backgroundSavingContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_backgroundSavingContext setPersistentStoreCoordinator:coordinator];
        [_backgroundSavingContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
    }
    return _backgroundSavingContext;
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSManagedObjectContext *bgcontext = self.backgroundSavingContext;
    if (bgcontext != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _managedObjectContext.parentContext = bgcontext;
        [_managedObjectContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"RedmineTimeTracker" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"timetracker.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                   configuration:nil
                                                             URL:storeURL
                                                         options:@{NSMigratePersistentStoresAutomaticallyOption: @YES,
                                                                   NSInferMappingModelAutomaticallyOption: @YES}
                                                           error:&error]) {
        
        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                       configuration:nil
                                                                 URL:storeURL
                                                             options:nil
                                                               error:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
             
             Typical reasons for an error here include:
             * The persistent store is not accessible;
             * The schema for the persistent store is incompatible with current managed object model.
             Check the error message to determine what the actual problem was.
             
             
             If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
             
             If you encounter schema incompatibility errors during development, you can reduce their frequency by:
             * Simply deleting the existing store:
             [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
             
             * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
             @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
             
             Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
             
             */
            LOG_ERR(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    return _persistentStoreCoordinator;
}


#pragma mark - Temp Contexts
- (NSManagedObjectContext *)createTemporaryBackgroundContext
{
    NSManagedObjectContext *tempContext = nil;
    NSManagedObjectContext *mainContext = self.managedObjectContext;
    if (mainContext) {
        tempContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        tempContext.parentContext = mainContext;
        tempContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
        tempContext.undoManager = nil;
    }
    return tempContext;
}



#pragma mark - Application's Documents directory
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
}

NSManagedObjectContext *SMMainContext()
{
    return [[SMCoreDataSingleton sharedManager] managedObjectContext];
}

NSManagedObjectContext *SMTemporaryBGContext()
{
    return [[SMCoreDataSingleton sharedManager] createTemporaryBackgroundContext];
}
void SMSaveContext(NSManagedObjectContext *context) {
    NSManagedObjectContext *tmp = context;
     void(^fullBlock)() = nil;
    while (tmp) {
        void(^tmpBlock)() = ^(){
        __autoreleasing NSError *error = nil;
        if (![tmp save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            LOG_ERR(@"Unresolved error %@, %@", error, [error userInfo]);
            LOG_ERR(@"%@", [NSThread callStackSymbols]);
            if(fullBlock)fullBlock();
        } else {
            LOG_INFO(@"context %@ saved successfull",tmp);
        }
    };
        fullBlock = ^() {
            [tmp performBlock:tmpBlock];
        };
        tmp = tmp.parentContext;
    }
    if(fullBlock)
        fullBlock();
}

@end
