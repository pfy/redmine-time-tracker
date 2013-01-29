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
    NSMutableArray __block *allTimeEntries = self.allTimeEntries;
    [self.client getPath:[NSString stringWithFormat:@"time_entries.json?limit=100&offset=%d",offset] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // LOG_INFO(@"timenetries requested %@",responseObject);
        if([responseObject isKindOfClass:[NSDictionary class]]){
            int totalCount = [[responseObject objectForKey:@"total_count"] intValue];
            int limit = [[responseObject objectForKey:@"limit"] intValue];
            [allTimeEntries addObjectsFromArray:[responseObject objectForKey:@"time_entries"]];
            if(offset+limit < totalCount){
                AppDelegate *app = [NSApplication sharedApplication].delegate;
                [app.asyncDbQueue addOperation:[NSBlockOperation blockOperationWithBlock:^{
                    [  self fetchTimeEntries:offset+limit ];
                }]];
            } else {
                [SMManagedObject update:@"SMTimeEntry" withArray:allTimeEntries delete:YES];
                /* we are done */
                self.updating = NO;
            }
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LOG_ERR(@"error happend %@",error);
        self.updating = NO;

    } ];
}
-(void)fetchIssues:(int)offset{
    NSMutableArray __block *allIssues = self.allIssues;
    LOG_INFO(@"fetch issues %d",offset);
    [self.client getPath:[NSString stringWithFormat:@"issues.json?limit=100&offset=%d&status_id=*",offset] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //LOG_INFO(@"issues requested %@",responseObject);
        if([responseObject isKindOfClass:[NSDictionary class]]){
            int totalCount = [[responseObject objectForKey:@"total_count"] intValue];
            int limit = [[responseObject objectForKey:@"limit"] intValue];
            [allIssues addObjectsFromArray:[responseObject objectForKey:@"issues"]];
            
            if(offset+limit < totalCount){
                AppDelegate *app = [NSApplication sharedApplication].delegate;
                [app.asyncDbQueue addOperation:[NSBlockOperation blockOperationWithBlock:^{
                    [  self fetchIssues:offset+limit ];
                }]];
            } else {
                /* we are done */
                [SMManagedObject update:@"SMIssue" withArray:allIssues delete:YES];
                AppDelegate *app = [NSApplication sharedApplication].delegate;
                [app.asyncDbQueue addOperation:[NSBlockOperation blockOperationWithBlock:^{
                    [  self fetchTimeEntries:0 ];
                }]];
                
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LOG_ERR(@"error happend %@",error);
        self.updating = NO;

    } ];
}

-(void)getCurrentUser{
    [self.client getPath:@"users/current.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if([responseObject isKindOfClass:[NSDictionary class]]){
            [[SMCurrentUser findOrCreate] updateWithDict:responseObject andSet:nil];
            LOG_INFO(@"updated current user %@",[SMCurrentUser findOrCreate]);
            [  self fetchIssues:0 ];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LOG_ERR(@"error happend %@",error);
        self.updating = NO;

    } ];
}

-(void)update{
    if(self.user.authToken && self.user.serverUrl && ! self.updating ){
            SMCurrentUser *user = [SMCurrentUser findOrCreate];
        self.allIssues = [NSMutableArray new];
        self.allTimeEntries = [NSMutableArray new];

        self.client = [[SMHttpClient alloc] initWithBaseURL:[NSURL URLWithString:user.serverUrl]];
        [self.client setDefaultHeader:@"X-Redmine-API-Key" value:user.authToken];

        self.updating = YES;
        [self getCurrentUser];
        [self uploadChanges];
    }
}


-(void)uploadChanges{
    for (SMManagedObject *object in self.arrayController.arrangedObjects){
        [object createRequest:self.client];
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
