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
// Make properties readwrite
@property (nonatomic, strong) SMCurrentUser *user;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic) double missingTime;
@property (nonatomic) double spentHours;
@property (nonatomic) double projectCount;
@property (nonatomic) double issueCount;

@property (nonatomic, strong) NSArrayController *entriesArrayController;
@property (nonatomic, strong) NSDate *referenceDate;
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
        
        self.referenceDate = [NSDate date];
        self.startDate = self.referenceDate.dayStartDate;
        self.endDate = self.referenceDate.dayEndDate;
        [self calculateCounts];
    }
    return self;
}

#pragma mark - Properties
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

- (void)setStatisticsUser:(SMRedmineUser *)statisticsUser
{
    if (![_statisticsUser isEqual:statisticsUser]) {
        _statisticsUser = statisticsUser;
        [self setupArrayController];
        // Needed?
//        [self updateValues];
    }
}

- (void)setMode:(SMStatisticsMode)mode
{
    if (_mode != mode) {
        _mode = mode;
        [self setDate:self.referenceDate forStatisticsMode:mode];
    }
}

- (void)setDate:(NSDate *)date forStatisticsMode:(SMStatisticsMode)mode
{
    self.referenceDate = date;
    _mode = mode;
    switch (mode) {
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
- (NSPredicate *)statPredicate
{
    NSPredicate *timePredicate = [self timePredicate];
    NSPredicate *userPredicate = [NSPredicate predicateWithFormat:@"n_user == %@", self.statisticsUser];
    return [NSCompoundPredicate andPredicateWithSubpredicates:@[userPredicate, timePredicate]];
}

- (NSPredicate *)timePredicate
{
    NSPredicate *afterDatePredicate = [NSPredicate predicateWithFormat:@"n_spent_on >= %@", self.startDate];
    NSPredicate *beforeDatePredicate = [NSPredicate predicateWithFormat:@"n_spent_on <= %@", self.endDate];
    return [NSCompoundPredicate andPredicateWithSubpredicates:@[afterDatePredicate, beforeDatePredicate]];
}

- (void)setupArrayController
{
    self.entriesArrayController = [[NSArrayController alloc] init];
    self.entriesArrayController.managedObjectContext = self.managedObjectContext;
    self.entriesArrayController.entityName = @"SMTimeEntry";
    self.entriesArrayController.fetchPredicate = [self statPredicate];
    self.entriesArrayController.automaticallyPreparesContent = YES;
    self.entriesArrayController.automaticallyRearrangesObjects = YES;
    
    __autoreleasing NSError *error;
    if (![self.entriesArrayController fetchWithRequest:nil merge:YES error:&error]) {
        LOG_ERR(@"Failed to fetch entries: %@", error);
    }
}

#pragma mark - Update Values
- (void)updateValues
{
    if ([self.delegate respondsToSelector:@selector(statisticsWillUpdateContents:)]) {
        [self.delegate statisticsWillUpdateContents:self];
    }
    
    NSArray *objects = [self.entriesArrayController arrangedObjects];
    
    SMStatisticsTreeFactory *factory = [[SMStatisticsTreeFactory alloc] init];
    [self.statisticsController setContent:[factory projectsForTimeEntries:objects]];
    
    [self calculateCounts];
    
    if ([self.delegate respondsToSelector:@selector(statisticsDidUpdateContents:)]) {
        [self.delegate statisticsDidUpdateContents:self];
    }
}

#pragma mark - Missing Time
- (void)calculateCounts
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"SMTimeEntry"];
    fetchRequest.predicate = [self statPredicate];
    
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
    self.spentHours = spent;
    self.issueCount = [[NSSet setWithArray:[entries valueForKey:@"n_issue"]] count];
    self.projectCount = [[NSSet setWithArray:[entries valueForKey:@"n_project"]] count];
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
