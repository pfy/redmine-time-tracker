//
//  SMUpdateIssuesCommand.m
//  RedmineTimeTracker
//
//  Created by pfy on 29.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import "SMUpdateIssuesCommand.h"
#import "SMManagedObject+networkExtension.h"

@implementation SMUpdateIssuesCommand
-(void)run:(SMNetworkUpdate *)networkUpdateCenter{
    self.allIssues = [NSMutableArray new];
    self.center = networkUpdateCenter;
    [self fetchIssues:0];
}


-(void)fetchIssues:(int)offset{
    NSMutableArray __block *allIssues = self.allIssues;
    LOG_INFO(@"fetch issues %d",offset);
    [self.center.client getPath:[NSString stringWithFormat:@"issues.json?limit=100&offset=%d&status_id=*",offset] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
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
                    [self.center queueItemFinished:self];
                }]];
                
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LOG_ERR(@"error happend %@",error);
        [self.center queueItemFailed:self];
    } ];
}
-(void)dealloc{
    self.allIssues = nil;
}
@end
