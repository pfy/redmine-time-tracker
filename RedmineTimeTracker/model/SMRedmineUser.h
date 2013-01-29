//
//  SMRedmineUser.h
//  RedmineTimeTracker
//
//  Created by pfy on 29.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SMManagedObject.h"

@class SMCurrentUser, SMIssue, SMTimeEntry;

@interface SMRedmineUser : SMManagedObject

@property (nonatomic, retain) NSString * n_firstname;
@property (nonatomic, retain) NSDate * n_last_login_on;
@property (nonatomic, retain) NSString * n_lastname;
@property (nonatomic, retain) NSString * n_login;
@property (nonatomic, retain) NSString * n_mail;
@property (nonatomic, retain) NSString * n_name;
@property (nonatomic, retain) SMCurrentUser *currentUser;
@property (nonatomic, retain) NSSet *issues_assigned;
@property (nonatomic, retain) NSSet *issues_created;
@property (nonatomic, retain) NSSet *time_entries;
@end

@interface SMRedmineUser (CoreDataGeneratedAccessors)

- (void)addIssues_assignedObject:(SMIssue *)value;
- (void)removeIssues_assignedObject:(SMIssue *)value;
- (void)addIssues_assigned:(NSSet *)values;
- (void)removeIssues_assigned:(NSSet *)values;

- (void)addIssues_createdObject:(SMIssue *)value;
- (void)removeIssues_createdObject:(SMIssue *)value;
- (void)addIssues_created:(NSSet *)values;
- (void)removeIssues_created:(NSSet *)values;

- (void)addTime_entriesObject:(SMTimeEntry *)value;
- (void)removeTime_entriesObject:(SMTimeEntry *)value;
- (void)addTime_entries:(NSSet *)values;
- (void)removeTime_entries:(NSSet *)values;

@end
