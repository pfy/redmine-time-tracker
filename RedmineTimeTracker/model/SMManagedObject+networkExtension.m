//
//  SMManagedObject+networkExtension.m
//  RedmineTimeTracker
//
//  Created by pfy on 24.01.13.
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
    NSArray *array = [context executeFetchRequest:fetchRequest error:nil];
    SMManagedObject *managedObject = nil;
    if(array.count > 0){
        managedObject = [array objectAtIndex:0];
    } else {
            managedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    }
    return managedObject;
    
}

-(void)updateWithDict:(NSDictionary*)dict{
    if(self.managedObjectContext == nil){
        LOG_INFO(@"object has been deleted %@",self);
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
                    [newObject updateWithDict:val];
                    if(! [newObject isEqual:[self valueForKey:newKey]]){
                        [self setValue:newObject forKey:newKey];
                    }
                }
               else if(strcmp(propertyAttrs,"T@\"NSDate\",&,D,N") == 0){
                    NSDate *newDate;
                   NSString *dateString = val;
                   if(dateString.length == 10){
                       NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                       [dateFormatter setDateFormat:@"yyyy/MM/dd"];
                       newDate = [dateFormatter dateFromString:dateString];
                   } else {
                       dateString = [dateString stringByReplacingOccurrencesOfString:@":"
                                                                    withString:@""];
                       NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                       [dateFormatter setDateFormat:@"yyyy/MM/dd HHmmss ZZ"];
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


+(void)update:(NSString*)entityName withArray:(NSArray*)respArray delete:(bool)delete{

    [self scheduleUpdateOperationWithBlock:^(NSManagedObjectContext *context) {
        NSFetchRequest *fetchRequest = [NSFetchRequest new];
        NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        NSArray *array = [context executeFetchRequest:fetchRequest error:nil];
        NSMutableDictionary *allObjects = [NSMutableDictionary new];
        NSMutableArray *toDelete = [NSMutableArray arrayWithArray:array];
        for(NSManagedObject *obj in array){
            [allObjects setValue:obj forKey:[obj valueForKey:@"n_id"]];
        }
        
        for(NSDictionary *dict in respArray){
            SMManagedObject *managedObject =  [allObjects objectForKey:[dict objectForKey:@"id"]];
            if(managedObject){
                [toDelete removeObject:managedObject];
            } else {
                managedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
            }
            [managedObject updateWithDict:dict];
        }
        if(delete){
        for (NSManagedObject* managedObject in toDelete){
            if(! [[toDelete valueForKey:@"n_id"] isEqual:[NSNumber numberWithInt:0]])
                [context deleteObject:managedObject];
        }
        }
        NSError *error = nil;
        [context save:&error];
        if(error){
            NSLog(@"did fail safe managed object context %@",error);
        }
    }];
}

+(void)scheduleUpdateOperationWithBlock:(ContextBlock) block{
    SMUpdateOperation *operation = [SMUpdateOperation operationWithBlock:block];
    AppDelegate *app = [NSApplication sharedApplication].delegate;
    [app.asyncDbQueue addOperation:operation];
    return;
}



@end