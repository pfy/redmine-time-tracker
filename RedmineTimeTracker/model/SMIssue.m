//
//  SMIssue.m
//  RedmineTimeTracker
//
//  Created by pfy on 25.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import "SMIssue.h"
#import "SMIssue.h"
#import "SMPriority.h"
#import "SMProjects.h"
#import "SMRedmineUser.h"
#import "SMStatus.h"
#import "SMTrackers.h"


@implementation SMIssue

@dynamic n_description;
@dynamic n_done_ratio;
@dynamic n_estimated_hours;
@dynamic n_spent_hours;
@dynamic n_start_date;
@dynamic n_subject;
@dynamic n_author;
@dynamic n_project;
@dynamic n_status;
@dynamic n_tracker;
@dynamic n_parent;
@dynamic child;
@dynamic n_priority;
@dynamic n_assigned_to;

@end
