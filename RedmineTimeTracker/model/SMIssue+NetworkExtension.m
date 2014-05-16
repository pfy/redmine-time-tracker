//
//  SMIssue+NetworkExtension.m
//  RedmineTimeTracker
//
//  Created by Florian Friedrich on 16.05.14.
//  Copyright (c) 2014 Smooh AG. All rights reserved.
//

#import "SMIssue+NetworkExtension.h"
#import "SMManagedObject+networkExtension.h"

#import "SMProjects.h"
#import "SMTrackers.h"
#import "SMRedmineUser.h"

@implementation SMIssue (NetworkExtension)

- (void)createRequest:(AFHTTPRequestOperationManager *)client
{
    NSString *path = @"issues.json";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] initWithDateFormat:@"yyyy-MM-dd"
                                                            allowNaturalLanguage:NO];
    
    NSDictionary *params = @{@"issue": @{@"project_id": self.n_project.n_id,
                                         @"tracker_id": self.n_tracker.n_id,
                                         @"subject": self.n_subject,
                                         @"description": self.n_description,
                                         @"due_date": [dateFormatter stringFromDate:self.n_due_date],
                                         @"estimated_hours": self.n_estimated_hours,
                                         @"assigned_to_id": self.n_assigned_to.n_id,
                                         @"parent_issue_id": self.n_parent.n_id ?: [NSNull null]
                                         }};
    if (self.n_id) {
        path = [NSString stringWithFormat:@"/issues/%@.json", self.n_id];
        [client PUT:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            LOG_INFO(@"issue updated %@", responseObject);
            [self scheduleOperationWithBlock:^(SMManagedObject *newSelf) {
                newSelf.changed = @NO;
            }];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            LOG_WARN(@"issue update failed %@", error);
        }];
    } else {
        [client POST:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            LOG_INFO(@"time entry created %@",responseObject);
            [self scheduleOperationWithBlock:^(SMManagedObject *newSelf) {
                self.changed = @NO;
                [self updateWithDict:responseObject[@"issue"]];
            }];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            LOG_WARN(@"time entry creation failed %@ %@",error,params);
        }];
    }
}

@end
