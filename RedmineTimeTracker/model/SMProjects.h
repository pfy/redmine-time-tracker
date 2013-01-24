//
//  SMProjects.h
//  RedmineTimeTracker
//
//  Created by pfy on 24.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SMManagedObject.h"

@class SMIssue;

@interface SMProjects : SMManagedObject

@property (nonatomic, retain) NSString * n_description;
@property (nonatomic, retain) NSString * n_identifier;
@property (nonatomic, retain) NSString * n_name;
@property (nonatomic, retain) NSSet *issues;
@end

@interface SMProjects (CoreDataGeneratedAccessors)

- (void)addIssuesObject:(SMIssue *)value;
- (void)removeIssuesObject:(SMIssue *)value;
- (void)addIssues:(NSSet *)values;
- (void)removeIssues:(NSSet *)values;

@end
