//
//  NSDate+SMAddons.h
//  RedmineTimeTracker
//
//  Created by Florian Friedrich on 18.5.14.
//  Copyright (c) 2014 Smooh AG. All rights reserved.
//

#import "NSDate+SMAddons.h"
#import <EventKit/EventKit.h>

@implementation NSDate (SMAddons)

- (NSDateComponents *)timelessComponents
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:(NSYearCalendarUnit |
                                                   NSMonthCalendarUnit |
                                                   NSDayCalendarUnit |
                                                   NSWeekdayCalendarUnit)
                                         fromDate:self];
    
    return comp;
}

- (BOOL)isSameDay:(NSDate *)date
{
    if (!date) return NO;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *myComps = [self timelessComponents];
    NSDateComponents *theirComps = [date timelessComponents];
    return [[calendar dateFromComponents:myComps] isEqualToDate:[calendar dateFromComponents:theirComps]];
}

- (BOOL)isEqualToDate:(NSDate *)date withTolerance:(NSTimeInterval)tolerance
{
    if (!date) return NO;
    NSTimeInterval diff = ABS([self timeIntervalSinceDate:date]);
    return (diff <= 2*tolerance);
}

#pragma mark - Work Week
- (NSDate *)workWeekStartDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [self timelessComponents];
    NSDate *startOfDate = [calendar dateFromComponents:comp];
    
    NSInteger day = [comp weekday];
    NSInteger diff = EKMonday - day;

    NSDateComponents *correction = [[NSDateComponents alloc] init];
    correction.day = diff;
    return [calendar dateByAddingComponents:correction toDate:startOfDate options:kNilOptions];
}

- (NSDate *)workWeekEndDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [self timelessComponents];
    NSDate *startOfDate = [calendar dateFromComponents:comp];
    
    NSInteger day = [comp weekday];
    NSInteger diff = EKFriday - day;
    
    NSDateComponents *correction = [[NSDateComponents alloc] init];
    correction.day = diff;
    correction.hour = 23;
    correction.minute = 59;
    correction.second = 59;
    return [calendar dateByAddingComponents:correction toDate:startOfDate options:kNilOptions];
}

- (BOOL)isStartOfWorkWeek
{
    return [self timelessComponents].weekday == EKMonday;
}

- (BOOL)isEndOfWorkWeek
{
    return [self timelessComponents].weekday == EKFriday;
}

- (BOOL)isWorkDay
{
    NSDateComponents *comp = [self timelessComponents];
    return !(comp.weekday == EKSaturday || comp.weekday == EKSunday);
}

@end
