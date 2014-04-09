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
    [super run:networkUpdateCenter];
    [self fetchWithUrl:@"time_entries.json?limit=100&offset=%d" andKey:@"time_entries" toEntity:@"SMTimeEntry" andOffset:0];
}

@end
