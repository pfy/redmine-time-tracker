//
//  SMUpdateIssuesCommand.m
//  RedmineTimeTracker
//
//  Created by David Gunzinger Smooh GmbH on 29.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import "SMUpdateIssuesCommand.h"
#import "SMManagedObject+networkExtension.h"
#import "AppDelegate.h"
@implementation SMUpdateIssuesCommand
-(void)run:(SMNetworkUpdate *)networkUpdateCenter{
    [super run:networkUpdateCenter];
    [self fetchWithUrl:@"issues.json?limit=100&offset=%d&status_id=open" andKey:@"issues" toEntity:@"SMIssue" andOffset:0];
}
@end
