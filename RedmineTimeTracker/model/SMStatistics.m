//
//  SMStatistics.m
//  RedmineTimeTracker
//
//  Created by Florian Friedrich on 18.5.14.
//  Copyright (c) 2014 Smooh AG. All rights reserved.
//

#import "SMStatistics.h"
#import "NSDate+SMAddons.h"
#import "SMRedmineUser.h"

@interface SMStatistics ()
@property (nonatomic, strong) SMCurrentUser *user;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic) SMStatisticsMode mode;
@property (nonatomic) NSTimeInterval missingTime;
@end

@implementation SMStatistics

+ (instancetype)sharedStatistics
{
    static SMStatistics *SharedStatistics = nil;
    static dispatch_once_t SharedStatisticsToken;
    dispatch_once(&SharedStatisticsToken, ^{
        SharedStatistics = [[self alloc] init];
    });
    return SharedStatistics;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.user = [SMCurrentUser findOrCreate];
        self.managedObjectContext = SMMainContext();
        self.statisticsUser = self.user.n_user;
        [self setDate:[NSDate date] forStatisticsMode:SMDayStatisticsMode];
    }
    return self;
}

- (void)setStatisticsUser:(SMRedmineUser *)statisticsUser
{
    if (![_statisticsUser isEqual:statisticsUser]) {
        _statisticsUser = statisticsUser;
        [self updateValues];
    }
}

- (void)setDate:(NSDate *)date forStatisticsMode:(SMStatisticsMode)mode
{
    self.mode = mode;
    switch (self.mode) {
        case SMWeekStatisticsMode:
            self.startDate = date.workWeekStartDate;
            self.endDate = date.workWeekEndDate;
            break;
            
        case SMDayStatisticsMode:
        default:
            self.startDate = date;
            self.endDate = date;
            break;
    }
    [self updateValues];
}

- (NSPredicate *)timePredicate
{
    NSPredicate *afterDatePredicate = [NSPredicate predicateWithFormat:@"n_spent_on >= %@", self.startDate];
    NSPredicate *beforeDatePredicate = [NSPredicate predicateWithFormat:@"n_spent_on <= %@", self.endDate];
    return [[NSCompoundPredicate alloc] initWithType:NSAndPredicateType
                                       subpredicates:@[afterDatePredicate,
                                                       beforeDatePredicate]];
}

- (void)updateValues
{
    NSPredicate *userPredicate = [NSPredicate predicateWithFormat:@"n_user = %@", self.statisticsUser];
    NSPredicate *timePredicate = [self timePredicate];
    NSPredicate *predicate = [[NSCompoundPredicate alloc] initWithType:NSAndPredicateType
                                                         subpredicates:@[timePredicate,
                                                                         userPredicate]];
    
    self.entriesArrayController = [[NSArrayController alloc] init];
    self.entriesArrayController.managedObjectContext = self.managedObjectContext;
    self.entriesArrayController.entityName = @"SMTimeEntry";
    self.entriesArrayController.fetchPredicate = predicate;
    
    __autoreleasing NSError *error;
    if (![self.entriesArrayController fetchWithRequest:nil merge:YES error:&error]) {
        LOG_ERR(@"Failed to fetch entries: %@", error);
    }
    
    [self calculateMissingTime];
}

- (void)calculateMissingTime
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"SMTimeEntry"];
    NSPredicate *userPredicate = [NSPredicate predicateWithFormat:@"n_user = %@", self.user.n_user];
    NSPredicate *timePredicate = [self timePredicate];
    fetchRequest.predicate = [[NSCompoundPredicate alloc] initWithType:NSAndPredicateType
                                                         subpredicates:@[timePredicate,
                                                                         userPredicate]];
    
    __autoreleasing NSError *error;
    NSArray *entries = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (!entries) {
        LOG_ERR(@"Failed to fetch entries: %@", error);
    }
    
    __block NSTimeInterval spent = 0.0;
    NSArray *hours = [entries valueForKey:@"n_hours"];
    [hours enumerateObjectsUsingBlock:^(NSNumber *spentHours, NSUInteger idx, BOOL *stop) {
        spent += [spentHours doubleValue];
    }];
    
    NSTimeInterval diff = (self.user.workdayDuration.doubleValue - self.user.workdayDurationTolerance.doubleValue) - spent;
    self.missingTime = (diff > 0.0) ? diff : 0.0;
}

@end
