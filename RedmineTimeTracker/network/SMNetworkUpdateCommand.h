//
//  SMNetworkUpdateCommand.h
//  RedmineTimeTracker
//
//  Created by David Gunzinger Smooh GmbH on 29.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMNetworkUpdate.h"
@interface SMNetworkUpdateCommand : NSObject
-(void)run:(SMNetworkUpdate*)networkUpdateCenter;
-(void)fetchWithUrl:(NSString*)url andKey:(NSString*)key toEntity:(NSString*)entity andOffset:(int)offset;
@end
