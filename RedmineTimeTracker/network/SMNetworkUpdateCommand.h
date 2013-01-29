//
//  SMNetworkUpdateCommand.h
//  RedmineTimeTracker
//
//  Created by pfy on 29.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMNetworkUpdate.h"
@interface SMNetworkUpdateCommand : NSObject
-(void)run:(SMNetworkUpdate*)networkUpdateCenter;

@end
