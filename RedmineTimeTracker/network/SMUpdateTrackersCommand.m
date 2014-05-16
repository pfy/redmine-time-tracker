//
//  SMUpdateTrackersCommand.m
//  RedmineTimeTracker
//
//  Created by Florian Friedrich on 16.05.14.
//  Copyright (c) 2014 Smooh AG. All rights reserved.
//

#import "SMUpdateTrackersCommand.h"

@implementation SMUpdateTrackersCommand
-(void)run:(SMNetworkUpdate *)networkUpdateCenter{
    [super run:networkUpdateCenter];
    [self fetchWithUrl:@"trackers.json?limit=100&offset=%d" andKey:@"trackers" toEntity:@"SMTrackers" andOffset:0];
}
@end
