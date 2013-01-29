//
//  SMNetworkUpdate.h
//  RedmineTimeTracker
//
//  Created by pfy on 24.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMNetworkUpdate : NSObject
@property (nonatomic,retain) NSTimer *timer;
@property (nonatomic,retain) NSArrayController *arrayController;
-(void)update;
@end
