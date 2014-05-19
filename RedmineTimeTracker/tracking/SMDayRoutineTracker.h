//
//  SMDayRoutineTracker.h
//  RedmineTimeTracker
//
//  Created by Florian Friedrich on 18.5.14.
//  Copyright (c) 2014 Smooh AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IdleTime.h"
#import "SMCurrentUser+trackingExtension.h"

@interface SMDayRoutineTracker : NSObject

@property (nonatomic, strong) SMCurrentUser *user;
@property (nonatomic, strong) IdleTime *idleTime;
@property (nonatomic) NSTimeInterval idleTimePassed;
@property (nonatomic, strong) NSDate *lastUpdate;
@property (nonatomic, weak) NSTimer *updateTimer;

@end
