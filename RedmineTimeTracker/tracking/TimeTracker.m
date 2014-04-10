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
        self.idleTime = [IdleTime new];
        self.timer =     [NSTimer scheduledTimerWithTimeInterval:1.0
                                                          target:self
                                                        selector:@selector(update)
                                                        userInfo:nil
                                                         repeats:YES];
        if([self.timer respondsToSelector:@selector(setTolerance:)]){
            [self.timer setTolerance:10.0];
        }
    }
    return self;
}


-(void)update{
    NSDate *newDate = [NSDate date];
    double timePassed = [newDate timeIntervalSinceDate:self.lastTick]/3600.0;
    self.lastTick = newDate;
    NSTimeInterval newIdleTime = self.idleTime.secondsIdle;
    if(self.user.currentTimeEntry){
        double oldVal = [self.user.currentTimeEntry.n_hours doubleValue];
        oldVal += timePassed;
        //SAVE_APP_CONTEXT
        if(self.idleTimePassed > newIdleTime && self.idleTimePassed > 60*5){
            int seconds = self.idleTimePassed;
            int houres = seconds / 3600;
            seconds -= houres*3600;
            int minutes = seconds/ 60;
            seconds -= minutes*60;
            NSAlert *alert = [NSAlert alertWithMessageText:[NSString stringWithFormat:@"You have been idle since %02d:%02d:%02d, remove time ? ",houres,minutes,seconds] defaultButton:@"Ok"  alternateButton:@"Cancel" otherButton:nil informativeTextWithFormat:@""];
            [NSApp activateIgnoringOtherApps:YES];

            NSInteger resp = [alert runModal];
            if(resp == 1){
                oldVal -= self.idleTimePassed/3600;
            }
            LOG_INFO(@"user has been idle since %f seconds",self.idleTimePassed);
        }
        
        self.user.currentTimeEntry.n_hours = @(oldVal);
        self.user.currentTimeEntry.changed = @YES;
        self.user.currentTimeEntry.n_updated_on = newDate;

    }
    self.idleTimePassed = newIdleTime;
}

@end
