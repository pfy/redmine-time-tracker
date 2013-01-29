//
//  SMUploadCommand.m
//  RedmineTimeTracker
//
//  Created by pfy on 29.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import "SMUploadCommand.h"
#import "SMManagedObject+networkExtension.h"

@implementation SMUploadCommand
-(void)run:(SMNetworkUpdate *)networkUpdateCenter{
    
    NSManagedObjectContext *context = [(AppDelegate*)[NSApplication sharedApplication].delegate managedObjectContext];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SMManagedObject"];
    request.predicate  =  [NSPredicate predicateWithFormat:@"changed = %@",[NSNumber numberWithBool:YES] ];
    NSArray *fetched = [context executeFetchRequest:request error:nil];
    for (SMManagedObject *obj in fetched){
        [obj createRequest:networkUpdateCenter.client];
    }
    [networkUpdateCenter queueItemFinished:self];
}

@end
