//
//  SMNetworkUpdate.m
//  RedmineTimeTracker
//
//  Created by pfy on 24.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import "SMNetworkUpdate.h"
#import "SMHttpClient.h"
#import "SMManagedObject+networkExtension.h"

@implementation SMNetworkUpdate
-(void)update{
    AFHTTPClient *client = [SMHttpClient sharedHTTPClient];
    [client getPath:@"stations.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([responseObject isKindOfClass:[NSArray class]]){
//            SMManagedObject
           /* SM
            [NSManagedObject update:[NSEntityDescription entityForName:@"Station" inManagedObjectContext:context] withArray:responseObject];*/
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error happend %@",error);
    } ];
    
}
@end
