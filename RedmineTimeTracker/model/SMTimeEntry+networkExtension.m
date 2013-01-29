//
//  SMTimeEntry+networkExtension.m
//  RedmineTimeTracker
//
//  Created by pfy on 29.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import "SMTimeEntry+networkExtension.h"
#import "SMManagedObject+networkExtension.h"
#import "SMHttpClient.h"
#import "SMActivity.h"
@implementation SMTimeEntry (networkExtension)
-(void)createRequest:(SMHttpClient *)client{
    NSString *path = @"time_entries.json";
    if(self.n_id){
        path = [NSString stringWithFormat:@"/time_entries/%@.json",self.n_id];
    }
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSDictionary dictionaryWithObjectsAndKeys:
                            self.n_issue.n_id,@"issue_id",
                             self.n_spent_on,@"spent_on",
                             self.n_hours,@"hours",
                           //  self.n_activity.n_id,@"activity_id",
                             self.n_comments,@"comments"
                             nil],
                            @"time_entry"
                            , nil];
    
    
    [client postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        LOG_INFO(@"time entry created %@",responseObject);
        self.changed = [NSNumber numberWithBool:NO];
        [self updateWithDict:[responseObject objectForKey:@"time_entry"]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LOG_WARN(@"time entry creation failed %@",error);
    } ];

    
    
}

@end
