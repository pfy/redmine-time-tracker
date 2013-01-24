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
-(void)update{
    AFHTTPClient *client = [SMHttpClient sharedHTTPClient];
    [client getPath:@"issues.json?limit=0" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        LOG_INFO(@"issues requested %@",responseObject);
        if([responseObject isKindOfClass:[NSDictionary class]]){
            [SMManagedObject update:@"SMIssue" withArray:[responseObject objectForKey:@"issues"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error happend %@",error);
    } ];
    
}
@end
