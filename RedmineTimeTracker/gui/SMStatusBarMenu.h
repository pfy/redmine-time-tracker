//
//  SMStatusBarMenu.h
//  RedmineTimeTracker
//
//  Created by Florian Friedrich on 17.5.14.
//  Copyright (c) 2014 Smooh AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMWindowsManager.h"

@class SMCurrentUser;
@class SMTimeEntry;
@interface SMStatusBarMenu : NSObject

@property (nonatomic, strong) NSStatusItem *statusItem;
@property (nonatomic, strong) NSMenu *statusMenu;

@property (nonatomic, strong) NSMenuItem *startTrackingMenuItem;
@property (nonatomic, strong) NSMenuItem *stopTrackingMenuItem;
@property (nonatomic, strong) NSMenuItem *createNewIssueMenuItem;
@property (nonatomic, strong) NSMenuItem *createNewTimeEntryMenuItem;
@property (nonatomic, strong) NSMenuItem *statisticsMenuItem;
@property (nonatomic, strong) NSMenuItem *applicationsTrackerMenuItem;
@property (nonatomic, strong) NSMenuItem *preferencesMenuItem;

@property (nonatomic, strong) SMWindowsManager *windowsManager;

@property (nonatomic, strong) SMCurrentUser *user;
@property (nonatomic, strong) SMTimeEntry *entry;

@end
