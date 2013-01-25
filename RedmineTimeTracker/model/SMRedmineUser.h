//
//  SMRedmineUser.h
//  RedmineTimeTracker
//
//  Created by pfy on 25.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SMManagedObject.h"

@class SMIssue;

@interface SMRedmineUser : SMManagedObject

@property (nonatomic, retain) NSString * n_firstname;
@property (nonatomic, retain) NSDate * n_last_login_on;
@property (nonatomic, retain) NSString * n_lastname;
@property (nonatomic, retain) NSString * n_login;
@property (nonatomic, retain) NSString * n_mail;
@property (nonatomic, retain) NSString * n_name;
@property (nonatomic, retain) NSSet *issues_created;
@property (nonatomic, retain) NSSet *issues_assigned;
@end

@interface SMRedmineUser (CoreDataGeneratedAccessors)

- (void)addIssues_createdObject:(SMIssue *)value;
- (void)removeIssues_createdObject:(SMIssue *)value;
- (void)addIssues_created:(NSSet *)values;
- (void)removeIssues_created:(NSSet *)values;

- (void)addIssues_assignedObject:(SMIssue *)value;
- (void)removeIssues_assignedObject:(SMIssue *)value;
- (void)addIssues_assigned:(NSSet *)values;
- (void)removeIssues_assigned:(NSSet *)values;

@end
