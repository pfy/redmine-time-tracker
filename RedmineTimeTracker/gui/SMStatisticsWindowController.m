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

@interface SMStatisticsWindowController ()

@end

@implementation SMStatisticsWindowController

- (instancetype)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
        self.managedObjectContext = SMMainContext();
        self.statistics = [[SMStatistics alloc] init];
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
    
    self.usersArrayController.managedObjectContext = self.managedObjectContext;
    self.usersArrayController.entityName = @"SMRedmineUser";
    
    __autoreleasing NSError *error;
    if (![self.usersArrayController fetchWithRequest:nil merge:YES error:&error]) {
        LOG_ERR(@"Failed to fetch users: %@", error);
    }
    
}

- (void)addTime:(id)sender
{
    [[SMWindowsManager sharedWindowsManager] showNewTimeEntryWindow:sender];
}

- (void)changeStatisticsMode:(id)sender
{
    SMStatisticsMode mode = (self.statisticsModeControl.selectedSegment == 0) ? SMDayStatisticsMode : SMWeekStatisticsMode;
    [self.statistics setDate:self.statistics.startDate forStatisticsMode:mode];
}

- (void)changeUser:(id)sender
{
    SMRedmineUser *user = self.usersArrayController.arrangedObjects[self.userPopupButton.indexOfSelectedItem];
    self.statistics.statisticsUser = user;
    BOOL isMe = (user == [SMCurrentUser findOrCreate].n_user);
    [self.addTimeButton setHidden:!isMe];
    [self.missingHoursLabel setHidden:!isMe];
    [self.missingHoursField setHidden:!isMe];
}

@end
