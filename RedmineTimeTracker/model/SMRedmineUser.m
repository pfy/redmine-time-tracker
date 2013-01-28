//
//  SMRedmineUser.m
//  RedmineTimeTracker
//
//  Created by pfy on 28.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import "SMRedmineUser.h"
#import "SMCurrentUser.h"
#import "SMIssue.h"
#import "SMTimeEntry.h"


@implementation SMRedmineUser

@dynamic n_firstname;
@dynamic n_last_login_on;
@dynamic n_lastname;
@dynamic n_login;
@dynamic n_mail;
@dynamic n_name;
@dynamic issues_assigned;
@dynamic issues_created;
@dynamic time_entries;
@dynamic currentUser;

@end
