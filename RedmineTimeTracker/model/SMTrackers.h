//
//  SMTrackers.h
//  RedmineTimeTracker
//
//  Created by pfy on 24.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SMManagedObject.h"

@class SMIssue;

@interface SMTrackers : SMManagedObject

@property (nonatomic, retain) NSString * n_name;
@property (nonatomic, retain) NSSet *issue;
@end

@interface SMTrackers (CoreDataGeneratedAccessors)

- (void)addIssueObject:(SMIssue *)value;
- (void)removeIssueObject:(SMIssue *)value;
- (void)addIssue:(NSSet *)values;
- (void)removeIssue:(NSSet *)values;

@end
