//
//  SMWindowsManager.h
//  RedmineTimeTracker
//
//  Created by Florian Friedrich on 17.5.14.
//  Copyright (c) 2014 Smooh AG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMWindowsManager : NSObject

+ (instancetype)sharedWindowsManager;

- (void)showTrackingWindow:(id)sender;
- (void)showStartTrackingWindow:(id)sender;
- (void)showNewTimeEntryWindow:(id)sender;
- (void)showNewIssueWindow:(id)sender;
- (void)showStatisticsWindow:(id)sender;
- (void)showApplicationTrackerWindow:(id)sender;
- (void)showPreferencesWindow:(id)sender;

@end
