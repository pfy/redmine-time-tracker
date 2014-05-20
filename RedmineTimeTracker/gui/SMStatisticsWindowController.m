//
//  SMStatisticsWindowController.m
//  RedmineTimeTracker
//
//  Created by Florian Friedrich on 14.05.14.
//  Copyright (c) 2014 Smooh AG. All rights reserved.
//

#import "SMStatisticsWindowController.h"
#import "SMCurrentUser+trackingExtension.h"
#import "SMWindowsManager.h"
#import "SMStatisticsObjects.h"
#import "NSDate+SMAddons.h"

@interface SMStatisticsWindowController () <SMStatisticsDelegate>

@end

@implementation SMStatisticsWindowController

- (instancetype)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
        self.managedObjectContext = SMMainContext();
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    self.totalProjectsField.integerValue = 0;
    self.totalIssuesField.integerValue = 0;
    self.totalHoursField.doubleValue = 0.0;
    self.missingHoursField.doubleValue = 0.0;
    
    self.datePicker.dateValue = [NSDate date];
    
    self.usersArrayController.managedObjectContext = self.managedObjectContext;
    self.usersArrayController.entityName = @"SMRedmineUser";
    
    __autoreleasing NSError *error;
    if (![self.usersArrayController fetchWithRequest:nil merge:YES error:&error]) {
        LOG_ERR(@"Failed to fetch users: %@", error);
    }
    
    NSUInteger myIndex = [self.usersArrayController.arrangedObjects indexOfObject:[SMCurrentUser findOrCreate].n_user];
    [self.userPopupButton selectItemAtIndex:myIndex];
    
    if (!self.statistics) self.statistics = [[SMStatistics alloc] init];
    else {
        [self.missingHoursField bind:@"doubleValue" toObject:_statistics withKeyPath:@"missingTime" options:nil];
        [self.totalHoursField bind:@"doubleValue" toObject:_statistics withKeyPath:@"spentHours" options:nil];
        [self.totalIssuesField bind:@"integerValue" toObject:_statistics withKeyPath:@"issueCount" options:nil];
        [self.totalProjectsField bind:@"integerValue" toObject:_statistics withKeyPath:@"projectCount" options:nil];
        self.statistics.statisticsController = self.statisticsTreeController;
    }
    [self.statistics setDate:[NSDate date] forStatisticsMode:SMDayStatisticsMode];
}

#pragma mark - Properties
- (void)setStatistics:(SMStatistics *)statistics
{
    if (![_statistics isEqual:statistics]) {
        [self.missingHoursField unbind:@"doubleValue"];
        [self.totalHoursField unbind:@"doubleValue"];
        [self.totalIssuesField unbind:@"integerValue"];
        [self.totalProjectsField unbind:@"integerValue"];
        _statistics = statistics;
        if (_statistics) {
            [self.missingHoursField bind:@"doubleValue" toObject:_statistics withKeyPath:@"missingTime" options:nil];
            [self.totalHoursField bind:@"doubleValue" toObject:_statistics withKeyPath:@"spentHours" options:nil];
            [self.totalIssuesField bind:@"integerValue" toObject:_statistics withKeyPath:@"issueCount" options:nil];
            [self.totalProjectsField bind:@"integerValue" toObject:_statistics withKeyPath:@"projectCount" options:nil];
            _statistics.statisticsController = self.statisticsTreeController;
            _statistics.delegate = self;
        }
    }
}

#pragma mark - Actions
- (void)addTime:(id)sender
{
    SMWindowEvent *event = [SMWindowEvent eventWithSender:sender];
    if ([self.datePicker.dateValue isSameDay:[NSDate date]]) {
        event.statistics = self.statistics;
    }
    [[SMWindowsManager sharedWindowsManager] showNewTimeEntryWindowForEvent:event];
}

- (void)changeStatisticsMode:(id)sender
{
    SMStatisticsMode mode = (self.statisticsModeControl.selectedSegment == 0) ? SMDayStatisticsMode : SMWeekStatisticsMode;
    [self.statistics setMode:mode];
    BOOL missingTimeControlsShown = (mode == SMWeekStatisticsMode);
    [self.addTimeButton setHidden:missingTimeControlsShown];
    [self.missingHoursField setHidden:missingTimeControlsShown];
    [self.missingHoursLabel setHidden:missingTimeControlsShown];
}

- (void)changeDate:(id)sender
{
    [self.statistics setDate:self.datePicker.dateValue forStatisticsMode:self.statistics.mode];
}

- (void)changeUser:(id)sender
{
    SMRedmineUser *user = [self.usersArrayController.selectedObjects firstObject];
    self.statistics.statisticsUser = user;
    BOOL isMe = (user == [SMCurrentUser findOrCreate].n_user);
    [self.addTimeButton setHidden:!isMe];
}

#pragma mark - Sort Descriptors
- (NSArray *)usersSortDescriptors
{
    return @[[NSSortDescriptor sortDescriptorWithKey:@"n_name"
                                           ascending:YES
                                            selector:@selector(caseInsensitiveCompare:)]];
}

- (NSArray *)statisticsSortDescriptors
{
    return @[[NSSortDescriptor sortDescriptorWithKey:@"hours" ascending:NO]];
}

#pragma mark - SMStatisticsDelegate
- (void)statisticsDidUpdateContents:(SMStatistics *)statistics
{
    if (statistics.mode == SMDayStatisticsMode) {
        [self.statisticsOutlineView expandItem:nil expandChildren:YES];
    }
}

@end
