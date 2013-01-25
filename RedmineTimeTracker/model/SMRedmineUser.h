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
@property (nonatomic, retain) NSSet *issues;
@end

@interface SMRedmineUser (CoreDataGeneratedAccessors)

- (void)addIssuesObject:(SMIssue *)value;
- (void)removeIssuesObject:(SMIssue *)value;
- (void)addIssues:(NSSet *)values;
- (void)removeIssues:(NSSet *)values;

@end
