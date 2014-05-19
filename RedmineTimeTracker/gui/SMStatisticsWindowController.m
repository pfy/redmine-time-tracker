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

@interface SMStatisticsWindowController () <NSOutlineViewDelegate>

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
    self.statisticsOutlineView.delegate = self;
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
    
    NSUInteger myIndex = [self.usersArrayController.arrangedObjects indexOfObject:[SMCurrentUser findOrCreate].n_user];
    [self.userPopupButton selectItemAtIndex:myIndex];
    
    self.statistics = [[SMStatistics alloc] init];
    self.statistics.statisticsController = self.statisticsTreeController;
    [self.statistics setDate:[NSDate date] forStatisticsMode:SMDayStatisticsMode];
    if (self.statistics.mode == SMDayStatisticsMode) {
        [self.statisticsOutlineView expandItem:nil expandChildren:YES];
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
    if (mode == SMDayStatisticsMode) {
        [self.statisticsOutlineView expandItem:nil expandChildren:YES];
    }
}

- (void)changeUser:(id)sender
{
    SMRedmineUser *user = [self.usersArrayController.selectedObjects firstObject];
    self.statistics.statisticsUser = user;
    BOOL isMe = (user == [SMCurrentUser findOrCreate].n_user);
    [self.addTimeButton setHidden:!isMe];
    
    [self.missingHoursLabel setHidden:!isMe];
    [self.missingHoursField setHidden:!isMe];
}

#pragma mark - Sort Descriptors
- (NSArray *)usersSortDescriptors
{
    return @[[NSSortDescriptor sortDescriptorWithKey:@"n_name" ascending:YES]];
}

- (NSArray *)statisticsSortDescriptors
{
    return @[[NSSortDescriptor sortDescriptorWithKey:@"hours" ascending:YES]];
}

#pragma mark - NSOutlineView Delegate
- (BOOL)outlineView:(NSOutlineView *)outlineView shouldEditTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    if ([item isKindOfClass:[NSTreeNode class]]) {
        NSTreeNode *node = item;
        if ([node.representedObject isKindOfClass:[SMStatisticsObject class]]) {
            SMStatisticsObject *statObject = node.representedObject;
            return statObject.isEditable;
        }
    }
    return NO;
}

@end
