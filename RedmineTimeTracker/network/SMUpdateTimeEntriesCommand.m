//
//  SMUpdateTimeEntriesCommand.m
//  RedmineTimeTracker
//
//  Created by David Gunzinger Smooh GmbH on 29.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import "SMUpdateTimeEntriesCommand.h"
#import "SMManagedObject+networkExtension.h"

@implementation SMUpdateTimeEntriesCommand
-(void)run:(SMNetworkUpdate *)networkUpdateCenter{
    self.center = networkUpdateCenter;
    self.allTimeEntries = [NSMutableArray new];
    [self fetchTimeEntries:0];
}


-(void)fetchTimeEntries:(int)offset{
    NSMutableArray __block *allTimeEntries = self.allTimeEntries;
    [self.center.client getPath:[NSString stringWithFormat:@"time_entries.json?limit=100&offset=%d",offset] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
                [SMManagedObject scheduleOperationOnMainWithBlock:^{
                    [self.center queueItemFinished:self];
                }];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LOG_ERR(@"error happend %@",error);
        [self.center queueItemFailed:self];
    } ];
}

-(void)dealloc{
    self.allTimeEntries = nil;
}

@end
