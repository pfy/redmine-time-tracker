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
    [self getCurrentUser];
}
@end
