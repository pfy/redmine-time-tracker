//
//  SMCurrentUser+trackingExtension.m
//  RedmineTimeTracker
//
//  Created by David Gunzinger Smooh GmbH on 28.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import "SMCurrentUser+trackingExtension.h"

@implementation SMCurrentUser (trackingExtension)

+(instancetype) _load{
    NSManagedObjectContext *context =  SMMainContext();
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SMCurrentUser" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *array = [context executeFetchRequest:fetchRequest error:nil];
    SMCurrentUser *managedObject = nil;
    if(array.count > 0){
        managedObject = array[0];
    } else {
        managedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    }
    return managedObject;
    
}
+(instancetype)findOrCreate{
    static id _current = nil;
    if(_current)
        return _current;
    
    @synchronized(self){
        if(!_current){
            _current = [self _load];
        }
    }
    return _current;
}
@end
