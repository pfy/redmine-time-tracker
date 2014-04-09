//
//  SMCurrentUser+trackingExtension.m
//  RedmineTimeTracker
//
//  Created by David Gunzinger Smooh GmbH on 28.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import "SMCurrentUser+trackingExtension.h"

@implementation SMCurrentUser (trackingExtension)
+(SMCurrentUser*)findOrCreate{
    NSManagedObjectContext *context =  SMMainContext();
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SMCurrentUser" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *array = [context executeFetchRequest:fetchRequest error:nil];
    SMCurrentUser *managedObject = nil;
    if(array.count > 0){
        managedObject = [array objectAtIndex:0];
    } else {
        managedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    }
    return managedObject;
    
    
}
@end
