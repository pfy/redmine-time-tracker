//
//  SMIssue.m
//  RedmineTimeTracker
//
//  Created by David Gunzinger Smooh GmbH on 29.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import "SMIssue.h"
#import "SMIssue.h"
#import "SMPriority.h"
#import "SMProjects.h"
#import "SMRedmineUser.h"
#import "SMStatus.h"
#import "SMTimeEntry.h"
#import "SMTrackers.h"


@implementation SMIssue

@dynamic n_description;
@dynamic n_done_ratio;
@dynamic n_due_date;
@dynamic n_estimated_hours;
@dynamic n_spent_hours;
@dynamic n_start_date;
@dynamic n_subject;
@dynamic child;
@dynamic n_assigned_to;
@dynamic n_author;
@dynamic n_parent;
@dynamic n_priority;
@dynamic n_project;
@dynamic n_status;
@dynamic n_tracker;
@dynamic time_entries;

@end
