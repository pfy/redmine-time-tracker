//
//  SMIssue+IssueCreation.m
//  RedmineTimeTracker
//
//  Created by Florian Friedrich on 20.05.14.
//  Copyright (c) 2014 Smooh AG. All rights reserved.
//

#import "SMIssue+IssueCreation.h"
#import "SMCurrentUser+trackingExtension.h"

@implementation SMIssue (IssueCreation)

+ (instancetype)newIssueInContext:(NSManagedObjectContext *)context
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([self class])
                                              inManagedObjectContext:context];
    SMIssue *issue = [[self alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    issue.n_assigned_to = [SMCurrentUser findOrCreate].n_user;
    issue.n_author = [SMCurrentUser findOrCreate].n_user;
    return issue;
}

@end
