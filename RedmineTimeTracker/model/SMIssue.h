//
//  SMIssue.h
//  RedmineTimeTracker
//
//  Created by pfy on 24.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SMManagedObject.h"

@class SMRedmineUser;

@interface SMIssue : SMManagedObject

@property (nonatomic, retain) NSString * n_description;
@property (nonatomic, retain) NSNumber * n_done_ratio;
@property (nonatomic, retain) NSNumber * n_estimated_hours;
@property (nonatomic, retain) NSNumber * n_spent_hours;
@property (nonatomic, retain) NSDate * n_start_date;
@property (nonatomic, retain) NSString * n_subject;
@property (nonatomic, retain) SMRedmineUser *author;
@property (nonatomic, retain) NSManagedObject *project;
@property (nonatomic, retain) NSManagedObject *status;
@property (nonatomic, retain) NSManagedObject *tracker;

@end
