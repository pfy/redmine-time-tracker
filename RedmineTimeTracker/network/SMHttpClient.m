//
//  SMHttpClient.m
//  RedmineTimeTracker
//
//  Created by pfy on 24.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import "SMHttpClient.h"
#import "AFJSONRequestOperation.h"


@implementation SMHttpClient
+ (id)sharedHTTPClient
{
    static dispatch_once_t pred = 0;
    __strong static id __httpClient = nil;
    dispatch_once(&pred, ^{
        __httpClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:@""]];
        [__httpClient setParameterEncoding:AFJSONParameterEncoding];
        [__httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [__httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
        [[__httpClient operationQueue ] setMaxConcurrentOperationCount:1] ;
        SMCurrentUser *user = [SMCurrentUser findOrCreate];
        [__httpClient setUser:user];
        [user addObserver:__httpClient forKeyPath:@"authToken" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        [user addObserver:__httpClient forKeyPath:@"serverUrl" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    });
    return __httpClient;
}

-(void)dealloc{
    [self.user removeObserver:self forKeyPath:@"authToken"];
    [self.user removeObserver:self forKeyPath:@"serverUrl"];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    [self setDefaultHeader:@"X-Redmine-API-Key" value:self.user.authToken];
    self.baseURL = [NSURL URLWithString:self.user.serverUrl];
}



@end
