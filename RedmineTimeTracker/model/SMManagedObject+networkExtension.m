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


@implementation SMManagedObject (NetworkExtension)
@dynamic requestOperation;
@dynamic updateOperations;

- (void)prepareForDeletion{
    [super willTurnIntoFault];
    AFHTTPRequestOperation *operation = self.requestOperation;
   [operation cancel];
    
    for(NSOperation *operation in self.updateOperations){
        [operation cancel];
        [operation removeObserver:self forKeyPath:@"isFinished"];
    }
    self.updateOperations = nil;
    self.requestOperation = nil;
    [super prepareForDeletion];
}

-(void)createRequest:(SMHttpClient *)client{
    
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
                if(strcmp(propertyAttrs,"T@\"NSDate\",&,D,N") == 0){
                    NSDate *newDate;
                    NSString *stringVal = val;
                    if(stringVal.length == 5){
                        NSArray *comps = [stringVal componentsSeparatedByString:@":"];
                        NSCalendar *cal = [NSCalendar currentCalendar];
                        NSDateComponents *net_comps = [NSDateComponents new];
                        net_comps.hour = [[comps objectAtIndex:0] intValue];
                        net_comps.minute = [[comps objectAtIndex:1] intValue];
                        NSDateComponents *cur_comps = [cal components:NSYearCalendarUnit|NSDayCalendarUnit|NSMonthCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:[NSDate date]];
                        
                        int addDay = 0;
                        if(net_comps.hour < 5 && cur_comps.hour > 20){
                            addDay = 1;
                        } else if ( cur_comps.hour < 5 && net_comps.hour > 20 ){
                            addDay = -1;
                        }
                        cur_comps.hour = net_comps.hour;
                        cur_comps.minute = net_comps.minute;
                        newDate = [cal dateFromComponents:cur_comps];
                        newDate = [newDate dateByAddingTimeInterval:3600*24.0*addDay];
                    } else {
                       // newDate = [stringVal getDateFromJSON];
                    }
                    if(! [newDate isEqual:[self valueForKey:newKey]]){
                        [self setValue:newDate forKey:newKey];
                    }
                    
                } else {
                    if(! [val isEqual:[self valueForKey:newKey]]){
                        [self setValue:val forKey:newKey];
                    }
                }
            } else {
                LOG_ERR(@"did not find property %@",newKey);
            }
        }
        
        //  LOG_INFO(@"did update %@",self);
        
    }
}


-(void)update:(NSString*)entityName withArray:(NSArray*)respArray{
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
        
        for (NSManagedObject* managedObject in toDelete){
            if(! [[toDelete valueForKey:@"n_id"] isEqual:[NSNumber numberWithInt:0]])
                [context deleteObject:managedObject];
        }
        NSError *error = nil;
        [context save:&error];
        if(error){
            NSLog(@"did fail safe managed object context %@",error);
        }
    }];
}

-(void)scheduleUpdateOperationWithBlock:(ContextBlock) block{
    SMUpdateOperation *operation = [SMUpdateOperation operationWithBlock:block];
    AppDelegate *app = [NSApplication sharedApplication].delegate;
    [operation addObserver:self forKeyPath:@"isFinished" options:NSKeyValueObservingOptionNew context:nil];
    [self.updateOperations addObject:operation];
    [app.asyncDbQueue addOperation:operation];
    return;
}

-(void)scheduleUpdateOperationOnMainWithBlock:(VoidBlock)block{
    AppDelegate *app = [NSApplication sharedApplication].delegate;
    NSManagedObjectID *selfID = self.objectID;
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSManagedObject *object = [app.managedObjectContext existingObjectWithID:selfID error:nil];
            if(object && ! object.isDeleted)
                block(object);
        });
    }];
    [operation addObserver:self forKeyPath:@"isFinished" options:NSKeyValueObservingOptionNew context:nil];
    [self.updateOperations addObject:operation];
    [app.asyncDbQueue addOperation:operation];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if([keyPath isEqualToString:@"isFinished"]){
        //LOG_INFO(@"update operation finished %@",object);
        //  [object removeObserver:self];
        [object removeObserver:self forKeyPath:@"isFinished"];
        [self.updateOperations removeObject:object];
    }
}

-(void)awakeFromFetch{
    if(![NSThread isMainThread])
        return;
    
    [super awakeFromFetch];
    self.updateOperations = [NSMutableArray new];
    
}
-(void)awakeFromInsert{
    if(![NSThread isMainThread])
        return;
    [super awakeFromInsert];
    self.updateOperations = [NSMutableArray new];
}

-(int)language{
    int lang_string = 1;
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if([language isEqualToString:@"fr"]){
        lang_string = 2;
    } else if([language isEqualToString:@"it"]){
        lang_string = 3;
    }
    return  lang_string;
}




@end