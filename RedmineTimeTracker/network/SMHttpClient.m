//
//  SMHttpClient.m
//  RedmineTimeTracker
//
//  Created by pfy on 24.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import "SMHttpClient.h"
#import "AFJSONRequestOperation.h"

#define kServerUrl @"http://redmine.smooh.ch"

@implementation SMHttpClient
+ (id)sharedHTTPClient
{
    static dispatch_once_t pred = 0;
    __strong static id __httpClient = nil;
    dispatch_once(&pred, ^{
        __httpClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kServerUrl]];
        [__httpClient setParameterEncoding:AFJSONParameterEncoding];
        [__httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [__httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
        [[__httpClient operationQueue ] setMaxConcurrentOperationCount:1] ;
    });
    return __httpClient;
}
@end
