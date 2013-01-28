//
//  TimeTracker.h
//  RedmineTimeTracker
//
//  Created by pfy on 28.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMCurrentUser.h"
@interface TimeTracker : NSObject
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) SMCurrentUser *user;
@property (nonatomic,strong) NSDate *lastTick;

@end
