//
//  SMStatistics.h
//  RedmineTimeTracker
//
//  Created by Florian Friedrich on 18.5.14.
//  Copyright (c) 2014 Smooh AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMCurrentUser+trackingExtension.h"

@protocol SMStatisticsDelegate <NSObject>
@optional
- (void)statisticsWillUpdateContents:(SMStatistics *)statistics;
- (void)statisticsDidUpdateContents:(SMStatistics *)statistics;
@end

typedef NS_ENUM(NSUInteger, SMStatisticsMode) {
    SMDayStatisticsMode = 1,
    SMWeekStatisticsMode
};

@interface SMStatistics : NSObject

@property (nonatomic, strong) SMRedmineUser *statisticsUser;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSTreeController *statisticsController;

@property (nonatomic, weak) id<SMStatisticsDelegate> delegate;

@property (nonatomic, strong, readonly) NSDate *startDate;
@property (nonatomic, strong, readonly) NSDate *endDate;
@property (nonatomic) SMStatisticsMode mode;

@property (nonatomic, readonly) double missingTime;
@property (nonatomic, readonly) double spentHours;
@property (nonatomic, readonly) double projectCount;
@property (nonatomic, readonly) double issueCount;

- (void)setDate:(NSDate *)date forStatisticsMode:(SMStatisticsMode)mode;

@end
