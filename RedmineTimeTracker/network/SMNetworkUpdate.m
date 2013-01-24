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

@implementation SMNetworkUpdate

-(void)fetchIssues:(int)offset{
    AFHTTPClient *client = [SMHttpClient sharedHTTPClient];
    [client getPath:[NSString stringWithFormat:@"issues.json?limit=100&offset=%d",offset] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        LOG_INFO(@"issues requested %@",responseObject);
        if([responseObject isKindOfClass:[NSDictionary class]]){
            int totalCount = [[responseObject objectForKey:@"total_count"] intValue];
            int limit = [[responseObject objectForKey:@"limit"] intValue];

            if(offset+limit < totalCount){
                [  self fetchIssues:offset+limit ];
            }
            [SMManagedObject update:@"SMIssue" withArray:[responseObject objectForKey:@"issues"] delete:NO];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error happend %@",error);
    } ];
}
-(void)update{
    [self fetchIssues:0];
}
@end
