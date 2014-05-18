//
//  SMWindowsManager.m
//  RedmineTimeTracker
//
//  Created by Florian Friedrich on 17.5.14.
//  Copyright (c) 2014 Smooh AG. All rights reserved.
//

#import "SMWindowsManager.h"
#import "NSWindowController+ClassNibName.h"
#import "TrackingWindowController.h"
#import "StartTrackingWindowController.h"
#import "SMNewTimeEntryWindowController.h"
#import "SMNewIssueWindowController.h"
#import "SMStatisticsWindowController.h"
#import "ApplicationTrackerWindowController.h"
#import "PreferencesWindowController.h"

@interface SMWindowsManager ()
@property (nonatomic, strong) TrackingWindowController *trackingWindowController;
@property (nonatomic, strong) StartTrackingWindowController *startTrackingWindowController;
@property (nonatomic, strong) SMNewTimeEntryWindowController *createNewTimeEntryWindowController;
@property (nonatomic, strong) SMNewIssueWindowController *createNewIssueWindowController;
@property (nonatomic, strong) SMStatisticsWindowController *statisticsWindowController;
@property (nonatomic, strong) ApplicationTrackerWindowController *applicationTrackerWindowController;
@property (nonatomic, strong) PreferencesWindowController *preferencesWindowController;
@end

@implementation SMWindowsManager

+ (instancetype)sharedWindowsManager
{
    static SMWindowsManager *SharedWindowsManager = nil;
    static dispatch_once_t SharedWindowsManagerToken;
    @synchronized(self) {
        dispatch_once(&SharedWindowsManagerToken, ^{
            SharedWindowsManager = [[self alloc] init];
        });
    }
    return SharedWindowsManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowWillClose:) name:NSWindowWillCloseNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Show Windows
- (void)showTrackingWindow:(id)sender
{
    self.trackingWindowController = [TrackingWindowController windowControllerWithNib];
    [self.trackingWindowController showWindow:sender];
}

- (void)showStartTrackingWindow:(id)sender
{
    self.startTrackingWindowController = [StartTrackingWindowController windowControllerWithNib];
    [self.startTrackingWindowController showWindow:sender];
}

- (void)showNewTimeEntryWindow:(id)sender
{
    self.createNewTimeEntryWindowController = [SMNewTimeEntryWindowController windowControllerWithNib];
    [self.createNewTimeEntryWindowController showWindow:sender];
}

- (void)showNewIssueWindow:(id)sender
{
    self.createNewIssueWindowController = [SMNewIssueWindowController windowControllerWithNib];
    [self.createNewIssueWindowController showWindow:sender];
}

- (void)showStatisticsWindow:(id)sender
{
//    self.statisticsWindowController = [SMStatisticsWindowController windowControllerWithNib];
//    [self.statisticsWindowController showWindow:sender];
}

- (void)showApplicationTrackerWindow:(id)sender
{
    self.applicationTrackerWindowController = [ApplicationTrackerWindowController windowControllerWithNib];
    [self.applicationTrackerWindowController showWindow:sender];
}

- (void)showPreferencesWindow:(id)sender
{
    self.preferencesWindowController = [PreferencesWindowController windowControllerWithNib];
    [self.preferencesWindowController showWindow:sender];
}

#pragma mark - Window Will Close
- (void)windowWillClose:(NSNotification *)notification
{
    NSWindowController *windowController = notification.object;
    if (windowController == self.trackingWindowController) {
        self.trackingWindowController = nil;
    }
    if (windowController == self.startTrackingWindowController) {
        self.startTrackingWindowController = nil;
    }
    if (windowController == self.createNewTimeEntryWindowController) {
        self.createNewTimeEntryWindowController = nil;
    }
    if (windowController == self.createNewIssueWindowController) {
        self.createNewIssueWindowController = nil;
    }
    if (windowController == self.statisticsWindowController) {
        self.statisticsWindowController = nil;
    }
    if (windowController == self.applicationTrackerWindowController) {
        self.applicationTrackerWindowController = nil;
    }
    if (windowController == self.preferencesWindowController) {
        self.preferencesWindowController = nil;
    }
}

@end
