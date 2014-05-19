//
//  SMDayRoutineTracker.m
//  RedmineTimeTracker
//
//  Created by Florian Friedrich on 18.5.14.
//  Copyright (c) 2014 Smooh AG. All rights reserved.
//

#import "SMDayRoutineTracker.h"
#import "SMWindowsManager.h"
#import "NSDate+SMAddons.h"
#import "SMStatistics.h"

static NSString *const SMLastStartDayReminderDateKey = @"LastStartDayReminderDate";
static NSString *const SMLastEndDayReminderDateKey = @"LastEndDayReminderDate";

@interface SMDayRoutineTracker ()
@property (nonatomic, strong) NSDate *lastStartDayReminderDate;
@property (nonatomic, strong) NSDate *lastEndDayReminderDate;
@end

@implementation SMDayRoutineTracker

- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.lastStartDayReminderDate = nil;
//        self.lastEndDayReminderDate = nil;
//        [[NSUserDefaults standardUserDefaults] synchronize];
        self.user = [SMCurrentUser findOrCreate];
        self.idleTime = [[IdleTime alloc] init];
        NSTimer *updateTimer = [NSTimer scheduledTimerWithTimeInterval:10.0
                                                                target:self selector:@selector(timerUpdated:)
                                                              userInfo:nil repeats:YES];
        if ([updateTimer respondsToSelector:@selector(setTolerance:)]) {
            [updateTimer setTolerance:10.0];
        }
        self.updateTimer = updateTimer;
    }
    return self;
}

- (void)dealloc
{
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.updateTimer invalidate];
    self.updateTimer = nil;
}

#pragma mark - Properties
- (NSDate *)lastStartDayReminderDate
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:SMLastStartDayReminderDateKey];
}

- (void)setLastStartDayReminderDate:(NSDate *)lastStartDayReminderDate
{
    [[NSUserDefaults standardUserDefaults] setObject:lastStartDayReminderDate forKey:SMLastStartDayReminderDateKey];
}

- (NSDate *)lastEndDayReminderDate
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:SMLastEndDayReminderDateKey];
}

- (void)setLastEndDayReminderDate:(NSDate *)lastEndDayReminderDate
{
    [[NSUserDefaults standardUserDefaults] setObject:lastEndDayReminderDate forKey:SMLastEndDayReminderDateKey];
}

#pragma mark - Reminders
- (BOOL)showStartDayReminderIfNeeded
{
    if (self.user.currentTimeEntry) return NO;
    NSDate *lastRem = self.lastStartDayReminderDate;
    if ([lastRem isSameDay:[NSDate date]]) return NO;
    
    NSUInteger secIdle = self.idleTime.secondsIdle;
    if (secIdle > self.idleTimePassed) {
        self.idleTimePassed = (NSTimeInterval)secIdle;
        return NO;
    }
    
    [[SMWindowsManager sharedWindowsManager] showStartTrackingWindow:self];
    self.idleTimePassed = (NSTimeInterval)secIdle;
    self.lastStartDayReminderDate = [NSDate date];
    return YES;
}

- (BOOL)showEndDayReminderIfNeeded
{
    NSDate *startRem = self.lastStartDayReminderDate;
    if (![startRem isSameDay:[NSDate date]]) return NO;
    NSDate *endRem = self.lastEndDayReminderDate;
    if ([endRem isSameDay:[NSDate date]]) return NO;
    NSTimeInterval dayDurationInterval = self.user.workdayDuration.doubleValue * 3600.0;
    NSTimeInterval tolerance = self.user.workdayDurationTolerance.doubleValue * 3600.0;
    NSDate *endOfWorkday = [startRem dateByAddingTimeInterval:dayDurationInterval];
    if ([endOfWorkday isEqualToDate:[NSDate date] withTolerance:tolerance]) {
        SMStatistics *stats = [[SMStatistics alloc] init];
        if (stats.missingTime > 0.0) {
            [[SMWindowsManager sharedWindowsManager] showNewTimeEntryWindow:self];
        }
        [[SMWindowsManager sharedWindowsManager] showStatisticsWindow:self];
        self.lastEndDayReminderDate = [NSDate date];
        return YES;
    }
    return NO;
}

#pragma mark - Timer Method
- (void)timerUpdated:(NSTimer *)timer
{
    // If it's no workday, we don't care.
    if (![NSDate date].isWorkDay) return;
    // Check for start day reminder and if not check for end day reminder too.
    if (![self showStartDayReminderIfNeeded]) [self showEndDayReminderIfNeeded];
}

@end
