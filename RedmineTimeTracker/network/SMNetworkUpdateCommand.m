//
//  SMNetworkUpdateCommand.m
//  RedmineTimeTracker
//
//  Created by David Gunzinger Smooh GmbH on 29.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import "SMNetworkUpdateCommand.h"
#import "SMNetworkUpdate.h"
#import "SMManagedObject+networkExtension.h"

@interface SMNetworkUpdateCommand()
@property NSMutableArray *allObjects;
@property (nonatomic,weak) SMNetworkUpdate *center;
@end


@implementation SMNetworkUpdateCommand

-(void)run:(SMNetworkUpdate*)networkUpdateCenter{
    self.allObjects = [NSMutableArray new];
    self.center = networkUpdateCenter;

}

-(void)fetchWithUrl:(NSString*)url andKey:(NSString*)key toEntity:(NSString*)entity andOffset:(int)offset{
    NSMutableArray __block *allObjects = self.allObjects;
    NSString *urlWithOffset =[NSString stringWithFormat:url,offset];
    
    LOG_INFO(@"fetch %@",urlWithOffset);
    [self.center.client getPath:urlWithOffset parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //LOG_INFO(@"issues requested %@",responseObject);
        if([responseObject isKindOfClass:[NSDictionary class]]){
            int totalCount = [[responseObject objectForKey:@"total_count"] intValue];
            int limit = [[responseObject objectForKey:@"limit"] intValue];
            [allObjects addObjectsFromArray:[responseObject objectForKey:key]];
            
            if(offset+limit < totalCount){
                [[NSOperationQueue currentQueue] addOperationWithBlock:^{
                    [ self fetchWithUrl:url andKey:key toEntity:entity andOffset:offset+limit ];
                }];
            } else {
                /* we are done */
                [SMManagedObject update:entity withArray:allObjects delete:YES completion:^{
                    [self.center queueItemFinished:self];
                }];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LOG_ERR(@"error happend %@",error);
        [self.center queueItemFailed:self];
    } ];
    
    
}

@end
