//
//  SMNetworkUpdate.m
//  RedmineTimeTracker
//
//  Created by David Gunzinger Smooh GmbH on 24.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import "SMNetworkUpdate.h"
#import "SMManagedObject+networkExtension.h"
#import "SMCurrentUser+trackingExtension.h"
#import "AppDelegate.h"
#import "SMNetworkUpdateCommand.h"
#import "SMUpdateCurrentUserCommand.h"
#import "SMUpdateIssuesCommand.h"
#import "SMUpdateTimeEntriesCommand.h"
#import "SMUploadCommand.h"


@implementation SMNetworkUpdate


-(void)update{
    if(self.user.authToken && self.user.serverUrl && self.allCommands.count == 0 ){
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:self.user.serverUrl]];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        self.client = manager;
        [self.client.requestSerializer setValue:self.user.authToken forHTTPHeaderField:@"X-Redmine-API-Key"];
        
        [self.allCommands addObject:[SMUploadCommand new]];
        [self.allCommands addObject:[SMUpdateTimeEntriesCommand new]];
        [self.allCommands addObject:[SMUpdateIssuesCommand new]];
        [self.allCommands addObject:[SMUpdateCurrentUserCommand new]];
        [self runNext ];
    }
}

-(void)runNext{
    if(self.allCommands.count > 0 && !self.running){
        self.running = YES;
        SMNetworkUpdateCommand *cmd = [self.allCommands lastObject];
        LOG_INFO(@"running %@",cmd);
        [cmd run:self];
    }
}

-(void)queueItemFinished:(SMNetworkUpdateCommand *)cmd{
    [self.allCommands removeObject:cmd];
    self.running = NO;
    LOG_INFO(@"finished %@",cmd);
    
    [self runNext];
}
-(void)queueItemFailed:(SMNetworkUpdateCommand *)cmd{
    self.running = NO;
    LOG_INFO(@"aborted %@",cmd);
    
    [self.allCommands removeAllObjects];
}

-(instancetype)init{
    self = [super init];
    if (self) {
        self.allCommands = [NSMutableArray new];
        self.running = NO;
        self.timer =     [NSTimer scheduledTimerWithTimeInterval:60.0
                                                          target:self
                                                        selector:@selector(update)
                                                        userInfo:nil
                                                         repeats:YES];
        if([self.timer respondsToSelector:@selector(setTolerance:)]){
            [self.timer setTolerance:10.0];
        }
        self.user = [SMCurrentUser findOrCreate];
        [self.user addObserver:self forKeyPath:@"authToken" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        [self.user addObserver:self forKeyPath:@"serverUrl" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        [self update];
    }
    return self;
}

-(void)dealloc{
    [self.timer invalidate];
    // !!!: FIXME: Remove observers
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    [self update];
}
@end
