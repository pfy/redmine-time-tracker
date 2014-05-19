//
//  SMWindowsManager.h
//  RedmineTimeTracker
//
//  Created by Florian Friedrich on 17.5.14.
//  Copyright (c) 2014 Smooh AG. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SMStatistics;
@class SMTimeEntry;
@class SMIssue;
@interface SMWindowEvent : NSObject
@property (nonatomic, assign) id sender;
@property (nonatomic, strong) SMStatistics *statistics;
@property (nonatomic, strong) SMTimeEntry *timeEntry;
@property (nonatomic, strong) SMIssue *issue;
+ (instancetype)event;
+ (instancetype)eventWithSender:(id)sender;
@end

@interface SMWindowsManager : NSObject

+ (instancetype)sharedWindowsManager;

- (void)showTrackingWindowForEvent:(SMWindowEvent *)event;
- (void)showTrackingWindow:(id)sender;

- (void)showStartTrackingWindowForEvent:(SMWindowEvent *)event;
- (void)showStartTrackingWindow:(id)sender;

- (void)showNewTimeEntryWindowForEvent:(SMWindowEvent *)event;
- (void)showNewTimeEntryWindow:(id)sender;

- (void)showNewIssueWindowForEvent:(SMWindowEvent *)event;
- (void)showNewIssueWindow:(id)sender;

- (void)showStatisticsWindowForEvent:(SMWindowEvent *)event;
- (void)showStatisticsWindow:(id)sender;


- (void)showApplicationTrackerWindowForEvent:(SMWindowEvent *)event;
- (void)showApplicationTrackerWindow:(id)sender;

- (void)showPreferencesWindowForEvent:(SMWindowEvent *)event;
- (void)showPreferencesWindow:(id)sender;

@end
