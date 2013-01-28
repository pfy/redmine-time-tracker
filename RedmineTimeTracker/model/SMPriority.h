//
//  SMPriority.h
//  RedmineTimeTracker
//
//  Created by pfy on 28.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SMManagedObject.h"

@class SMIssue;

@interface SMPriority : SMManagedObject

@property (nonatomic, retain) NSString * n_name;
@property (nonatomic, retain) NSSet *issues;
@end

@interface SMPriority (CoreDataGeneratedAccessors)

- (void)addIssuesObject:(SMIssue *)value;
- (void)removeIssuesObject:(SMIssue *)value;
- (void)addIssues:(NSSet *)values;
- (void)removeIssues:(NSSet *)values;

@end
