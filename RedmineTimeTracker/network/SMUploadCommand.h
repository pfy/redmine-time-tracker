//
//  SMUploadCommand.h
//  RedmineTimeTracker
//
//  Created by David Gunzinger Smooh GmbH on 29.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import "SMNetworkUpdateCommand.h"

@interface SMUploadCommand : SMNetworkUpdateCommand
@property (nonatomic,strong) AFHTTPRequestOperationManager *client;
@property (nonatomic,strong) SMNetworkUpdate *center;

@end
