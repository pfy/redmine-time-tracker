//
//  SMTimeEntry.h
//  RedmineTimeTracker
//
//  Created by pfy on 28.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SMManagedObject.h"

@class SMActivity, SMIssue, SMProjects, SMRedmineUser;

@interface SMTimeEntry : SMManagedObject

@property (nonatomic, retain) NSString * n_comments;
@property (nonatomic, retain) NSNumber * n_hours;
@property (nonatomic, retain) NSDate * n_spent_on;
@property (nonatomic, retain) SMActivity *n_activity;
@property (nonatomic, retain) SMIssue *n_issue;
@property (nonatomic, retain) SMProjects *n_project;
@property (nonatomic, retain) SMRedmineUser *n_user;
@property (nonatomic, retain) NSManagedObject *currentUser;

@end
