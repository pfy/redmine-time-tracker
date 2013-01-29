//
//  SMNetworkUpdate.m
//  RedmineTimeTracker
//
//  Created by pfy on 24.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import "SMNetworkUpdate.h"
#import "SMHttpClient.h"
#import "SMManagedObject+networkExtension.h"
#import "SMCurrentUser+trackingExtension.h"
#import "AppDelegate.h"

@implementation SMNetworkUpdate

-(void)fetchTimeEntries:(int)offset{
    AFHTTPClient *client = [SMHttpClient sharedHTTPClient];
    [client getPath:[NSString stringWithFormat:@"time_entries.json?limit=100&offset=%d",offset] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // LOG_INFO(@"timenetries requested %@",responseObject);
        if([responseObject isKindOfClass:[NSDictionary class]]){
            int totalCount = [[responseObject objectForKey:@"total_count"] intValue];
            int limit = [[responseObject objectForKey:@"limit"] intValue];
            [SMManagedObject update:@"SMTimeEntry" withArray:[responseObject objectForKey:@"time_entries"] delete:NO];
            if(offset+limit < totalCount){
                AppDelegate *app = [NSApplication sharedApplication].delegate;
                [app.asyncDbQueue addOperation:[NSBlockOperation blockOperationWithBlock:^{
                    [  self fetchTimeEntries:offset+limit ];
                }]];
            } else {
                /* we are done */
                self.updating = NO;
            }
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LOG_ERR(@"error happend %@",error);
    } ];
}
-(void)fetchIssues:(int)offset{
    AFHTTPClient *client = [SMHttpClient sharedHTTPClient];
    [client getPath:[NSString stringWithFormat:@"issues.json?limit=100&offset=%d",offset] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //LOG_INFO(@"issues requested %@",responseObject);
        if([responseObject isKindOfClass:[NSDictionary class]]){
            int totalCount = [[responseObject objectForKey:@"total_count"] intValue];
            int limit = [[responseObject objectForKey:@"limit"] intValue];
            [SMManagedObject update:@"SMIssue" withArray:[responseObject objectForKey:@"issues"] delete:NO];
            
            if(offset+limit < totalCount){
                AppDelegate *app = [NSApplication sharedApplication].delegate;
                [app.asyncDbQueue addOperation:[NSBlockOperation blockOperationWithBlock:^{
                    [  self fetchIssues:offset+limit ];
                }]];
            } else {
                /* we are done */
                AppDelegate *app = [NSApplication sharedApplication].delegate;
                [app.asyncDbQueue addOperation:[NSBlockOperation blockOperationWithBlock:^{
                    [  self fetchTimeEntries:0 ];
                }]];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LOG_ERR(@"error happend %@",error);
    } ];
}

-(void)getCurrentUser{
    AFHTTPClient *client = [SMHttpClient sharedHTTPClient];
    [client getPath:@"users/current.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if([responseObject isKindOfClass:[NSDictionary class]]){
            [[SMCurrentUser findOrCreate] updateWithDict:responseObject];
            LOG_INFO(@"updated current user %@",[SMCurrentUser findOrCreate]);
            [  self fetchIssues:0 ];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LOG_ERR(@"error happend %@",error);
    } ];
}

-(void)update{
    if(self.user.authToken && self.user.serverUrl && ! self.updating ){
        self.updating = YES;
        [self getCurrentUser];
        [self uploadChanges];
    }
}


-(void)uploadChanges{
    for (SMManagedObject *object in self.arrayController.arrangedObjects){
        [object createRequest:[SMHttpClient sharedHTTPClient]];
    }
}

-(id)init{
    self = [super init];
    if(self){
        self.arrayController = [NSArrayController new];
        self.arrayController.managedObjectContext = [(AppDelegate*)[NSApplication sharedApplication].delegate managedObjectContext];
        
        [self.arrayController setEntityName:@"SMManagedObject"];
        self.arrayController.fetchPredicate = [NSPredicate predicateWithFormat:@"changed = %@",[NSNumber numberWithBool:YES] ];
        [self.arrayController fetchWithRequest:nil merge:NO error:nil];
        self.timer =     [NSTimer scheduledTimerWithTimeInterval:60.0
                                                          target:self
                                                        selector:@selector(update)
                                                        userInfo:nil
                                                         repeats:YES];
        self.user = [SMCurrentUser findOrCreate];
        [self.user addObserver:self forKeyPath:@"authToken" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        [self.user addObserver:self forKeyPath:@"serverUrl" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        self.updating = NO;

    }
    return self;
}

-(void)dealloc{
    [self.timer invalidate];
    self.timer = nil;
    self.user = nil;
    self.arrayController = nil;
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    [self update];
}
@end
