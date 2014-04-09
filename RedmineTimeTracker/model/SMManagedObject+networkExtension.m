//
//  SMManagedObject+networkExtension.m
//  RedmineTimeTracker
//
//  Created by David Gunzinger Smooh GmbH on 24.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import "SMManagedObject+networkExtension.h"
#import "AppDelegate.h"
#import "SMUpdateOperation.h"
#import <objc/runtime.h>
#import "AFHTTPRequestOperation.h"
static char *smoohClassPrefix = "T@\"SM";


@implementation SMManagedObject (NetworkExtension)


-(void)createRequest:(SMHttpClient *)client{
    
}

+(SMManagedObject*)findOrCreateById:(int)n_id andEntity:(NSString*)entityName inContext:(NSManagedObjectContext*)context {
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"n_id = %d",n_id];
    [fetchRequest setEntity:entity];
    NSArray __autoreleasing *array = [context executeFetchRequest:fetchRequest error:nil];
    SMManagedObject *managedObject = nil;
    if(array.count > 0){
        managedObject = [array objectAtIndex:0];
    } else {
        managedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    }
    return managedObject;
    
}

-(void)updateWithDict:(NSDictionary*)dict andSet:(NSMutableSet *)set{
    if(self.managedObjectContext == nil){
        LOG_INFO(@"object has been deleted %@",self);
        return;
    }
    if([self.changed boolValue]){
        LOG_INFO(@"object has changed and will not be updated %@",self);
        return;
    }
    
    NSEnumerator *enumerator = [dict keyEnumerator];
    id key;
    while ((key = [enumerator nextObject])) {
        id val = [dict objectForKey:key];
        if(val != nil &&  val != [NSNull null]){
            NSString *newKey = [@"n_" stringByAppendingString:key];
            objc_property_t theProperty =
            class_getProperty([self class], [newKey UTF8String]);
            if(theProperty){
                const char * propertyAttrs = property_getAttributes(theProperty);
                if((strncmp(propertyAttrs,smoohClassPrefix,strlen(smoohClassPrefix)) == 0)){
                    NSArray *listItems = [[NSString stringWithFormat:@"%s",propertyAttrs ] componentsSeparatedByString:@"\""];
                    NSString *className = [listItems objectAtIndex:1];
                    int n_id = [[val valueForKey:@"id"]intValue];
                    SMManagedObject *newObject = [self valueForKey:newKey];
                    if(newObject == nil || [[newObject valueForKey:@"n_id"] intValue] != n_id ) {
                        newObject = [SMManagedObject findOrCreateById:n_id andEntity:className inContext:self.managedObjectContext];
                    }
                    [newObject updateWithDict:val andSet:set];
                    [set addObject:newObject.objectID];
                    if(! [newObject isEqual:[self valueForKey:newKey]]){
                        [self setValue:newObject forKey:newKey];
                    }
                }
                else if(strcmp(propertyAttrs,"T@\"NSDate\",&,D,N") == 0){
                    NSDate *newDate;
                    NSString *dateString = val;
                    if(dateString.length == 20){
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
                        newDate = [dateFormatter dateFromString:dateString];
                    } else {
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                        newDate = [dateFormatter dateFromString:dateString];
                    }
                    if(newDate == nil){
                        LOG_ERR(@"did fail to parse date %@",dateString);
                    }
                    if(! [newDate isEqual:[self valueForKey:newKey]]){
                        [self setValue:newDate forKey:newKey];
                    }
                    
                }
                else {
                    if(! [val isEqual:[self valueForKey:newKey]]){
                        [self setValue:val forKey:newKey];
                    }
                }
            } else {
                LOG_ERR(@"did not find property %@",newKey);
            }
        }
    }
    
    // LOG_INFO(@"did update %@",self);
}


+(void)update:(NSString*)entityName withArray:(NSArray*)respArray delete:(bool)delete completion:(noneBlock)completion{
    [self scheduleUpdateOperationWithBlock:^(NSManagedObjectContext *context) {
        
        NSMutableSet *set = [NSMutableSet new];
        for(NSDictionary *dict in respArray){
            int n_id = [[dict objectForKey:@"id"] intValue];

            SMManagedObject *managedObject =  [SMManagedObject findOrCreateById:n_id andEntity:entityName inContext:context ];
            [managedObject updateWithDict:dict andSet:set];
            [set addObject:managedObject.objectID];
        }
        
       if(delete){
           NSFetchRequest *fetchRequest = [NSFetchRequest new];
           NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
           [fetchRequest setEntity:entity];
           NSArray __autoreleasing *array = [context executeFetchRequest:fetchRequest error:nil];
            for (SMManagedObject* managedObject in array){
                if(managedObject.n_id != nil && (! [set containsObject:managedObject.objectID])){
                    if(managedObject.changed){
                        LOG_WARN(@"recreate object %@",managedObject);
                        managedObject.n_id = nil;
                    } else {
                        [context deleteObject:managedObject];
                        LOG_WARN(@"delete object %@",managedObject);
                    }
                }
            }
        }
        NSError __autoreleasing *error = error;
        [context save:&error];
        if(error){
            LOG_WARN(@"did fail safe managed object context %@",error);
        }
    } completion:completion];
}

+(void)scheduleUpdateOperationWithBlock:(ContextBlock) block completion:(noneBlock)completion{
    NSManagedObjectContext *context = SMTemporaryBGContext();
    [context performBlock:^{
        block(context);
        SMSaveContext(context);
        if(completion){
            dispatch_sync(dispatch_get_main_queue(), completion);
        }
        
    }];
    return;
}

-(void)scheduleOperationWithBlock:(VoidBlock)block{
    __autoreleasing NSError *err = nil;
    [self.managedObjectContext obtainPermanentIDsForObjects:@[self]
                                                      error:&err];
    if (err) {
        LOG_ERR(@"%@: %@", err.localizedFailureReason, err.userInfo);
    }
    NSManagedObjectID *selfID = self.objectID;
    
    [SMManagedObject scheduleUpdateOperationWithBlock:^(NSManagedObjectContext *context) {
        SMManagedObject *object = (SMManagedObject *)[context existingObjectWithID:selfID error:nil];
        if(object && ! object.isDeleted)
            block(object);
    } completion:nil];
    
}



@end