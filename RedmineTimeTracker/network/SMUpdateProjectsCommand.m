//
//  SMUpdateProjectsCommand.m
//  RedmineTimeTracker
//
//  Created by Florian Friedrich on 16.05.14.
//  Copyright (c) 2014 Smooh AG. All rights reserved.
//

#import "SMUpdateProjectsCommand.h"

@implementation SMUpdateProjectsCommand
-(void)run:(SMNetworkUpdate *)networkUpdateCenter{
    [super run:networkUpdateCenter];
    [self fetchWithUrl:@"projects.json?limit=100&offset=%d" andKey:@"projects" toEntity:@"SMProjects" andOffset:0];
}
@end
