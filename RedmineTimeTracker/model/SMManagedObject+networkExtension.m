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
#import "NSString+Date.h"


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

-(void)updateWithDict:(NSDictionary*)dict{
    if(self.managedObjectContext == nil){
        LOG_INFO(@"object has been deleted %@",self);
        return;
    }
    if([self.changed boolValue]){
        LOG_INFO(@"object has changed and will not be updated %@",self);
        return;
    }
    if([self valueForKey:@"n_updated_on"] != nil && [dict valueForKey:@"updated_on"]){
        NSDate *lastUpdateOnServer = ((NSString*)[dict valueForKey:@"updated_on"]).toDate;
        if([lastUpdateOnServer isEqual:self.n_updated_on]){
            return;
        }
    }
    
    NSEntityDescription *desc = self.entity;
    NSDictionary *propertiesByName =[desc propertiesByName];
    for(NSString *key in [propertiesByName allKeys]){
        if([key hasPrefix:@"n_"]){
            NSObject *val = [dict valueForKey:[key substringFromIndex:2]];
            if(val){
                if([propertiesByName[key] isKindOfClass:[NSAttributeDescription class]]){
                    NSAttributeDescription *attrDesc = propertiesByName[key];
                    if([attrDesc.attributeValueClassName isEqualToString:@"NSDate"]){
                        val = ((NSString*)val).toDate;
                    }
                    if(! [val isEqual:[self valueForKey:key]]){
                        [self setValue:val forKey:key];
                    }
                } else if([propertiesByName[key] isKindOfClass:[NSRelationshipDescription class]]){
                    NSRelationshipDescription *relDesc = propertiesByName[key];
                    SMManagedObject *newObject = [self valueForKey:key];
                    int n_id = [[val valueForKey:@"id"]intValue];
                    if(newObject == nil || [[newObject valueForKey:@"n_id"] intValue] != n_id ) {
                        newObject = [SMManagedObject findOrCreateById:n_id andEntity:relDesc.destinationEntity.name inContext:self.managedObjectContext];
                    }
                    [newObject updateWithDict:(NSDictionary*)val];
                } else {
                    LOG_WARN(@"unknown description %@",propertiesByName[key]);
                }
            }
        }
    }
    
    // LOG_INFO(@"did update %@",self);
}


+(void)update:(NSString*)entityName withArray:(NSArray*)respArray delete:(bool)delete completion:(noneBlock)completion{
    [self scheduleUpdateOperationWithBlock:^(NSManagedObjectContext *context) {
        NSFetchRequest *r = [NSFetchRequest fetchRequestWithEntityName:entityName];
        NSArray *allObjects = [context executeFetchRequest:r error:nil];
        NSMutableDictionary *toDelete = [[NSMutableDictionary alloc]init];
        for(SMManagedObject *obj in allObjects){
            if(obj.n_id){
                toDelete[obj.n_id] = obj;
            }
        }
        
        for(NSDictionary *dict in respArray){
            int n_id = [[dict objectForKey:@"id"] intValue];
            
            SMManagedObject *managedObject = toDelete[@(n_id)];
            if(managedObject){
                [toDelete removeObjectForKey:@(n_id)];
            } else {
                managedObject = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
            }
            [managedObject updateWithDict:dict];
        }
        
        if(delete){
            for (SMManagedObject *managedObject in toDelete.allValues){
                if(managedObject.changed){
                    LOG_WARN(@"recreate object %@",managedObject);
                    managedObject.n_id = nil;
                } else {
                    [context deleteObject:managedObject];
                    LOG_WARN(@"delete object %@",managedObject);
                }
            }
        }
    } completion:completion];
}

+(void)scheduleUpdateOperationWithBlock:(ContextBlock) block completion:(noneBlock)completion{
    NSManagedObjectContext *context = SMTemporaryBGContext();
    [context performBlock:^{
        block(context);
        SMSaveContext(context);
        [context reset];
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