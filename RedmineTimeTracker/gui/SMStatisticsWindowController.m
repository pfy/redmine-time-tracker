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
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    self.statisticsOutlineView.delegate = self;
    
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
    [self.statistics setDate:[NSDate date] forStatisticsMode:SMDayStatisticsMode];
    [self.statisticsOutlineView expandItem:nil expandChildren:YES];
}

#pragma mark - Properties
- (void)setStatistics:(SMStatistics *)statistics
{
    if (![_statistics isEqual:statistics]) {
        [self.missingHoursField unbind:@"doubleValue"];
        [self.totalHoursField unbind:@"doubleValue"];
        [self.totalProjectsField unbind:@"doubleValue"];
        [self.totalIssuesField unbind:@"doubleValue"];
        _statistics = statistics;
        [self.missingHoursField bind:@"doubleValue" toObject:_statistics withKeyPath:@"missingTime" options:nil];
        [self.totalHoursField bind:@"doubleValue" toObject:_statistics withKeyPath:@"spentHours" options:nil];
        [self.totalProjectsField bind:@"doubleValue" toObject:_statistics withKeyPath:@"projectCount" options:nil];
        [self.totalIssuesField bind:@"doubleValue" toObject:_statistics withKeyPath:@"issueCount" options:nil];
        _statistics.statisticsController = self.statisticsTreeController;
    }
}

#pragma mark - Actions
- (void)addTime:(id)sender
{
    SMWindowEvent *event = [SMWindowEvent eventWithSender:sender];
    event.statistics = self.statistics;
    [[SMWindowsManager sharedWindowsManager] showNewTimeEntryWindowForEvent:event];
}

- (void)changeStatisticsMode:(id)sender
{
    SMStatisticsMode mode = (self.statisticsModeControl.selectedSegment == 0) ? SMDayStatisticsMode : SMWeekStatisticsMode;
    [self.statistics setMode:mode];
    if (mode == SMDayStatisticsMode) {
        [self.statisticsOutlineView expandItem:nil expandChildren:YES];
    }
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
