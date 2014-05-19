//
//  NSDate+SMAddons.h
//  RedmineTimeTracker
//
//  Created by Florian Friedrich on 18.5.14.
//  Copyright (c) 2014 Smooh AG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (SMAddons)

/**
 *  Compares date to the receiver and returns YES if both are on the same day. NO otherwise.
 *  @param date The date to compare to.
 *  @return YES if the receiver and the date argument are on the same day. NO otherwise or if date is nil.
 */
- (BOOL)isSameDay:(NSDate *)date;

/**
 *  Compares date to the receiver with a given tolerance and returns YES if date is within the receiver +/- the tolerance
 *  @param date      The date to compare to.
 *  @param tolerance The tolerance applied to the receiver and the date.
 *  @return YES if the two dates are equal +/- the tolerance. NO otherwise of if date is nil;
 */
- (BOOL)isEqualToDate:(NSDate *)date withTolerance:(NSTimeInterval)tolerance;

#pragma mark - Day
/**
 *  Returns the date with time set to 00:00:00 of the receiver's date.
 */
@property (nonatomic, strong, readonly) NSDate *dayStartDate;
/**
 *  Returns the date with time set to 23:59:59 of the receiver's date.
 */
@property (nonatomic, strong, readonly) NSDate *dayEndDate;

#pragma mark - Work Week
/**
 *  Returns the first day of the work week.
 *  If the receiver is a Saturday it returns the last Monday.
 *  If the receiver is a Sunday it returns the next Monday.
 */
@property (nonatomic, strong, readonly) NSDate *workWeekStartDate;
/**
 *  Returns the last day of the work week.
 *  If the receiver is a Saturday it returns the last Friday.
 *  If the receiver is a Sunday it returns the next Friday.
 */
@property (nonatomic, strong, readonly) NSDate *workWeekEndDate;

/**
 *  Returns YES if the receiver is the beginning of the work week. NO otherwise.
 */
@property (nonatomic, readonly) BOOL isStartOfWorkWeek;
/**
 *  Returns YES if the receiver is the end of the work week. NO otherwise.
 */
@property (nonatomic, readonly) BOOL isEndOfWorkWeek;

/**
 *  Returns YES if the receiver is a workday (Monday to Friday).
 */
@property (nonatomic, readonly) BOOL isWorkDay;

@end
