//
//  SMTimeEntry+networkExtension.m
//  RedmineTimeTracker
//
//  Created by David Gunzinger Smooh GmbH on 29.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import "SMTimeEntry+networkExtension.h"
#import "SMManagedObject+networkExtension.h"

#import "SMActivity.h"
#import "SMIssue.h"

@implementation SMTimeEntry (networkExtension)

- (void)createRequest:(AFHTTPRequestOperationManager *)client {
    if(!self.n_issue.n_id)
        return;
    
    NSString *path = @"time_entries.json";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    
    
    NSDictionary *params = @{@"time_entry": @{@"issue_id": self.n_issue.n_id,
                                              @"spent_on": [dateFormatter stringFromDate:self.n_spent_on],
                                              @"hours": self.n_hours,
                                              @"activity_id": self.n_activity.n_id,
                                              @"comments": self.n_comments}};
    if (self.n_id) {
        path = [NSString stringWithFormat:@"/time_entries/%@.json",self.n_id];
        [client PUT:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            LOG_INFO(@"time entry updated %@",responseObject);
            [self scheduleOperationWithBlock:^(SMManagedObject *newSelf) {
                newSelf.changed = @NO;
            }];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            LOG_WARN(@"time entry update failed %@",error);
        }];
    } else {
        [client POST:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            LOG_INFO(@"time entry created %@",responseObject);
            [self scheduleOperationWithBlock:^(SMManagedObject *newSelf) {
                self.changed = @NO;
                [self updateWithDict:responseObject[@"time_entry"]];
            }];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            LOG_WARN(@"time entry creation failed %@ %@",error,params);
        }];
    }
}

@end
