//
//  SMIssue.h
//  RedmineTimeTracker
//
//  Created by pfy on 25.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SMManagedObject.h"

@class SMIssue, SMPriority, SMProjects, SMRedmineUser, SMStatus, SMTimeEntry, SMTrackers;

@interface SMIssue : SMManagedObject

@property (nonatomic, retain) NSString * n_description;
@property (nonatomic, retain) NSNumber * n_done_ratio;
@property (nonatomic, retain) NSNumber * n_estimated_hours;
@property (nonatomic, retain) NSNumber * n_spent_hours;
@property (nonatomic, retain) NSDate * n_start_date;
@property (nonatomic, retain) NSString * n_subject;
@property (nonatomic, retain) SMRedmineUser *n_author;
@property (nonatomic, retain) SMProjects *n_project;
@property (nonatomic, retain) SMStatus *n_status;
@property (nonatomic, retain) SMTrackers *n_tracker;
@property (nonatomic, retain) SMIssue *n_parent;
@property (nonatomic, retain) SMIssue *child;
@property (nonatomic, retain) SMPriority *n_priority;
@property (nonatomic, retain) SMRedmineUser *n_assigned_to;
@property (nonatomic, retain) NSSet *time_entries;
@end

@interface SMIssue (CoreDataGeneratedAccessors)

- (void)addTime_entriesObject:(SMTimeEntry *)value;
- (void)removeTime_entriesObject:(SMTimeEntry *)value;
- (void)addTime_entries:(NSSet *)values;
- (void)removeTime_entries:(NSSet *)values;

@end
