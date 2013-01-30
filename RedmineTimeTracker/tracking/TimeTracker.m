//
//  TimeTracker.m
//  RedmineTimeTracker
//
//  Created by David Gunzinger Smooh GmbH on 28.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import "TimeTracker.h"
#import "SMCurrentUser+trackingExtension.h"
#import "SMTimeEntry.h"


@implementation TimeTracker
-(id)init {
    self = [super init];
    if(self){
        self.user = [SMCurrentUser findOrCreate];
        self.lastTick = [NSDate date];
        self.timer =     [NSTimer scheduledTimerWithTimeInterval:1.0
                                                          target:self
                                                        selector:@selector(update)
                                                        userInfo:nil
                                                         repeats:YES];
    }
    return self;
}


-(void)update{
    NSDate *newDate = [NSDate date];
    double timePassed = [newDate timeIntervalSinceDate:self.lastTick]/3600.0;
    self.lastTick = newDate;
    if(self.user.currentTimeEntry){
        double oldVal = [self.user.currentTimeEntry.n_hours doubleValue];
        oldVal += timePassed;
        self.user.currentTimeEntry.n_hours = [NSNumber numberWithDouble:oldVal];
        self.user.currentTimeEntry.changed = [NSNumber numberWithBool:YES];
        self.user.currentTimeEntry.n_updated_on = newDate;

        //SAVE_APP_CONTEXT

    }
}

@end
