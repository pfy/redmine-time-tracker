//
//  SMCurrentUser+trackingExtension.m
//  RedmineTimeTracker
//
//  Created by David Gunzinger Smooh GmbH on 28.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import "SMCurrentUser+trackingExtension.h"

@implementation SMCurrentUser (trackingExtension)

+ (instancetype)_load {
    NSManagedObjectContext *context = SMMainContext();
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"SMCurrentUser"];
    NSArray *array = [context executeFetchRequest:fetchRequest error:nil];
    SMCurrentUser *managedObject = nil;
    if (array.count > 0) {
        managedObject = [array firstObject];
    } else {
        managedObject = [NSEntityDescription insertNewObjectForEntityForName:fetchRequest.entityName
                                                      inManagedObjectContext:context];
    }
    return managedObject;
}

+ (instancetype)findOrCreate {
    static id _current = nil;
    if (!_current) {
        @synchronized(self) {
            _current = [self _load];
        }
    }
    return _current;
}

@end
