//
//  SMUploadCommand.m
//  RedmineTimeTracker
//
//  Created by David Gunzinger Smooh GmbH on 29.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import "SMUploadCommand.h"
#import "SMManagedObject+networkExtension.h"

@implementation SMUploadCommand
-(void)run:(SMNetworkUpdate *)networkUpdateCenter{
    self.center = networkUpdateCenter;
    self.client = self.center.client;
    
    
    NSManagedObjectContext *context = [(AppDelegate*)[NSApplication sharedApplication].delegate managedObjectContext];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SMManagedObject"];
    request.predicate  =  [NSPredicate predicateWithFormat:@"changed = %@",[NSNumber numberWithBool:YES] ];
    NSArray *fetched = [context executeFetchRequest:request error:nil];
    for (SMManagedObject *obj in fetched){
        [obj createRequest:self.client];
    }
    [self.client.operationQueue addObserver:self forKeyPath:@"operationCount" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [self check];
}

-(void)dealloc{
    [self.client.operationQueue  removeObserver:self forKeyPath:@"operationCount"];
    self.client = nil;
    self.center = nil;
}
-(void)check{
    if(self.client.operationQueue.operationCount == 0){
        [self.center queueItemFinished:self];
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    LOG_INFO(@"queue item count changed %ld",(unsigned long)self.client.operationQueue.operationCount );
    [self check];
}

@end
