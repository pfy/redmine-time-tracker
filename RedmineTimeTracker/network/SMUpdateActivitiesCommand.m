//
//  SMUpdateActivitiesCommand.m
//  RedmineTimeTracker
//
//  Created by Florian Friedrich on 16.05.14.
//  Copyright (c) 2014 Smooh AG. All rights reserved.
//

#import "SMUpdateActivitiesCommand.h"

@implementation SMUpdateActivitiesCommand

-(void)run:(SMNetworkUpdate *)networkUpdateCenter{
    [super run:networkUpdateCenter];
    [self fetchWithUrl:@"enumerations/time_entry_activities.json?limit=100&offset=%d" andKey:@"time_entry_activities" toEntity:@"SMActivity" andOffset:0];
}

@end
