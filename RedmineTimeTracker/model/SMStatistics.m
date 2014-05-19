//
//  SMStatistics.m
//  RedmineTimeTracker
//
//  Created by Florian Friedrich on 18.5.14.
//  Copyright (c) 2014 Smooh AG. All rights reserved.
//

#import "SMStatistics.h"
#import "SMStatisticsObjects.h"
#import "SMStatisticsTreeFactory.h"
#import "NSDate+SMAddons.h"
#import "SMRedmineUser.h"

@interface SMStatistics ()
@property (nonatomic, strong) SMCurrentUser *user;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic) SMStatisticsMode mode;
@property (nonatomic) double missingTime;
@property (nonatomic, strong) NSArrayController *entriesArrayController;
@end

@implementation SMStatistics

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.user = [SMCurrentUser findOrCreate];
        self.managedObjectContext = SMMainContext();
        _statisticsUser = self.user.n_user;
        
        _mode = SMDayStatisticsMode;
        _startDate = [NSDate date].dayStartDate;
        _endDate = [NSDate date].dayEndDate;
        [self calculateMissingTime];
    }
    return self;
}

#pragma mark - Properties
- (void)setStatisticsUser:(SMRedmineUser *)statisticsUser
{
    if (![_statisticsUser isEqual:statisticsUser]) {
        _statisticsUser = statisticsUser;
        [self setupArrayController];
        // Needed?
//        [self updateValues];
    }
}

- (void)setEntriesArrayController:(NSArrayController *)entriesArrayController
{
    if (_entriesArrayController != entriesArrayController) {
        [_entriesArrayController removeObserver:self forKeyPath:@"arrangedObjects"];
        _entriesArrayController = entriesArrayController;
        [_entriesArrayController addObserver:self forKeyPath:@"arrangedObjects"
                                     options:(NSKeyValueObservingOptionOld |NSKeyValueObservingOptionNew)
                                     context:nil];
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
            self.startDate = date.dayStartDate;
            self.endDate = date.dayEndDate;
            break;
    }
    [self setupArrayController];
    // Needed?
//    [self updateValues];
}

#pragma mark - Helpers
- (NSPredicate *)timePredicate
{
    NSPredicate *afterDatePredicate = [NSPredicate predicateWithFormat:@"n_spent_on >= %@", self.startDate];
    NSPredicate *beforeDatePredicate = [NSPredicate predicateWithFormat:@"n_spent_on <= %@", self.endDate];
    return [[NSCompoundPredicate alloc] initWithType:NSAndPredicateType
                                       subpredicates:@[afterDatePredicate,
                                                       beforeDatePredicate]];
}

- (void)setupArrayController
{
    NSPredicate *userPredicate = [NSPredicate predicateWithFormat:@"n_user = %@", self.statisticsUser];
    NSPredicate *timePredicate = [self timePredicate];
    NSPredicate *predicate = [[NSCompoundPredicate alloc] initWithType:NSAndPredicateType
                                                         subpredicates:@[timePredicate, userPredicate]];
    
    self.entriesArrayController = [[NSArrayController alloc] init];
    self.entriesArrayController.managedObjectContext = self.managedObjectContext;
    self.entriesArrayController.entityName = @"SMTimeEntry";
    self.entriesArrayController.fetchPredicate = predicate;
    
    __autoreleasing NSError *error;
    if (![self.entriesArrayController fetchWithRequest:nil merge:YES error:&error]) {
        LOG_ERR(@"Failed to fetch entries: %@", error);
    }
}

#pragma mark - Values
- (void)updateValues
{
    NSArray *objects = [self.entriesArrayController arrangedObjects];
    
    SMStatisticsTreeFactory *factory = [[SMStatisticsTreeFactory alloc] init];
    [self.statisticsController setContent:[factory projectsForTimeEntries:objects]];
    
    [self calculateMissingTime];
}

#pragma mark - Missing Time
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
    
    double diff = (self.user.workdayDuration.doubleValue -
                   self.user.workdayDurationTolerance.doubleValue) - spent;
    self.missingTime = (diff > 0.0) ? diff : 0.0;
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context
{
    if (object == self.entriesArrayController && [keyPath isEqualToString:@"arrangedObjects"]) {
        LOG_INFO(@"Observed entries array controller change");
        [self updateValues];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
