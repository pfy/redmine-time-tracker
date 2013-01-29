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


-(id)initWithBaseURL:(NSURL*)url{
    self = [super initWithBaseURL:url];
    if(self){
        [self setParameterEncoding:AFJSONParameterEncoding];
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self registerHTTPOperationClass:[AFHTTPRequestOperation class]];
        [[self operationQueue ] setMaxConcurrentOperationCount:1] ;
    }
    return self;
}







@end
