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

@implementation SMWindowEvent
+ (instancetype)event { return [self eventWithSender:nil]; }
+ (instancetype)eventWithSender:(id)sender { return [[self alloc] initWithSender:sender]; }
- (instancetype)init { return [self initWithSender:nil]; }
- (instancetype)initWithSender:(id)sender
{
    self = [super init];
    if (self) {
        self.sender = sender;
    }
    return self;
}
@end

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
- (void)showTrackingWindowForEvent:(SMWindowEvent *)event
{
    self.trackingWindowController = [TrackingWindowController windowControllerWithNib];
    [self.trackingWindowController showWindow:event.sender];
}
- (void)showTrackingWindow:(id)sender
{
    [self showTrackingWindowForEvent:[SMWindowEvent eventWithSender:sender]];
}

- (void)showStartTrackingWindowForEvent:(SMWindowEvent *)event
{
    self.startTrackingWindowController = [StartTrackingWindowController windowControllerWithNib];
    [self.startTrackingWindowController showWindow:event.sender];
}
- (void)showStartTrackingWindow:(id)sender
{
    [self showStartTrackingWindowForEvent:[SMWindowEvent eventWithSender:sender]];
}

- (void)showNewTimeEntryWindowForEvent:(SMWindowEvent *)event
{
    self.createNewTimeEntryWindowController = [SMNewTimeEntryWindowController windowControllerWithNib];
    self.createNewTimeEntryWindowController.statistics = event.statistics;
    [self.createNewTimeEntryWindowController showWindow:event.sender];
}
- (void)showNewTimeEntryWindow:(id)sender
{
    [self showNewTimeEntryWindowForEvent:[SMWindowEvent eventWithSender:sender]];
}

- (void)showNewIssueWindowForEvent:(SMWindowEvent *)event
{
    self.createNewIssueWindowController = [SMNewIssueWindowController windowControllerWithNib];
    self.createNewIssueWindowController.issue = event.issue;
    [self.createNewIssueWindowController showWindow:event.sender];
}
- (void)showNewIssueWindow:(id)sender
{
    [self showNewIssueWindowForEvent:[SMWindowEvent eventWithSender:sender]];
}

- (void)showStatisticsWindowForEvent:(SMWindowEvent *)event
{
    self.statisticsWindowController = [SMStatisticsWindowController windowControllerWithNib];
    self.statisticsWindowController.statistics = event.statistics;
    [self.statisticsWindowController showWindow:event.sender];
}
- (void)showStatisticsWindow:(id)sender
{
    [self showStatisticsWindowForEvent:[SMWindowEvent eventWithSender:sender]];
}

- (void)showApplicationTrackerWindowForEvent:(SMWindowEvent *)event
{
    self.applicationTrackerWindowController = [ApplicationTrackerWindowController windowControllerWithNib];
    [self.applicationTrackerWindowController showWindow:event.sender];
}
- (void)showApplicationTrackerWindow:(id)sender
{
    [self showApplicationTrackerWindowForEvent:[SMWindowEvent eventWithSender:sender]];
}

- (void)showPreferencesWindowForEvent:(SMWindowEvent *)event
{
    self.preferencesWindowController = [PreferencesWindowController windowControllerWithNib];
    [self.preferencesWindowController showWindow:event.sender];
}
- (void)showPreferencesWindow:(id)sender
{
    [self showPreferencesWindowForEvent:[SMWindowEvent eventWithSender:sender]];
}

#pragma mark - Window Will Close
- (void)windowWillClose:(NSNotification *)notification
{
    NSWindow *window = notification.object;
    NSWindowController *windowController = window.windowController;
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
