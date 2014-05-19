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
    if (!self.n_project.n_id) {
        // To delete wrong things
        [self.managedObjectContext deleteObject:self];
        return;
    }
    
    NSMutableDictionary *issueParams = [NSMutableDictionary dictionary];
    issueParams[@"project_id"] = self.n_project.n_id;
    issueParams[@"tracker_id"] = self.n_tracker.n_id;
    issueParams[@"subject"] = self.n_subject;
    issueParams[@"description"] = self.n_description;
    if (self.n_due_date) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        issueParams[@"due_date"] = [dateFormatter stringFromDate:self.n_due_date];
    }
    if (self.n_estimated_hours.doubleValue > 0.0) {
        issueParams[@"estimated_hours"] = self.n_estimated_hours;
    }
    if (self.n_assigned_to) {
        issueParams[@"assigned_to_id"] = self.n_assigned_to.n_id;
    }
    if (self.n_parent) {
        issueParams[@"parent_issue_id"] = self.n_parent.n_id;
    }
    NSDictionary *params = @{@"issue": [issueParams copy]};
    if (self.n_id) {
        NSString *path = [NSString stringWithFormat:@"/issues/%@.json", self.n_id];
        [client PUT:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            LOG_INFO(@"Issue updated %@", responseObject);
            [self scheduleOperationWithBlock:^(SMManagedObject *newSelf) {
                newSelf.changed = @NO;
            }];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            LOG_WARN(@"Issue update failed %@", error);
        }];
    } else {
        NSString *path = @"issues.json";
        [client POST:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            LOG_INFO(@"Issue created %@",responseObject);
            [self scheduleOperationWithBlock:^(SMManagedObject *newSelf) {
                self.changed = @NO;
                [self updateWithDict:responseObject[@"issue"]];
            }];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            LOG_WARN(@"Issue creation failed %@ %@", error, params);
        }];
    }
}

@end
