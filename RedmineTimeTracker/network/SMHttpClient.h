//
//  SMHttpClient.h
//  RedmineTimeTracker
//
//  Created by pfy on 24.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import "AFHTTPClient.h"
#import "SMCurrentUser+trackingExtension.h"

@interface SMHttpClient : AFHTTPClient
+(SMHttpClient*)sharedHTTPClient;
@property (nonatomic,weak) SMCurrentUser *user;
@property (readwrite, nonatomic, retain) NSURL *baseURL;
@end
