//
//  SMIssue+IssueCreation.h
//  RedmineTimeTracker
//
//  Created by Florian Friedrich on 20.05.14.
//  Copyright (c) 2014 Smooh AG. All rights reserved.
//

#import "SMIssue.h"

@interface SMIssue (IssueCreation)

+ (instancetype)newIssueInContext:(NSManagedObjectContext *)context;

@end
