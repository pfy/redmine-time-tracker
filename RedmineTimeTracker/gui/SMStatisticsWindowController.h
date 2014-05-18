//
//  SMStatisticsWindowController.h
//  RedmineTimeTracker
//
//  Created by Florian Friedrich on 14.05.14.
//  Copyright (c) 2014 Smooh AG. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SMStatistics.h"

@interface SMStatisticsWindowController : NSWindowController
@property (weak) IBOutlet NSSegmentedControl *statisticsModeControl;
@property (weak) IBOutlet NSPopUpButton *userPopupButton;
@property (weak) IBOutlet NSScrollView *statisticsScrollView;
@property (weak) IBOutlet NSOutlineView *statisticsOutlineView;
@property (weak) IBOutlet NSTextField *totalProjectsLabel;
@property (weak) IBOutlet NSTextField *totalProjectsField;
@property (weak) IBOutlet NSTextField *totalIssuesLabel;
@property (weak) IBOutlet NSTextField *totalIssuesField;
@property (weak) IBOutlet NSTextField *totalHoursLabel;
@property (weak) IBOutlet NSTextField *totalHoursField;
@property (weak) IBOutlet NSTextField *missingHoursLabel;
@property (weak) IBOutlet NSTextField *missingHoursField;
@property (weak) IBOutlet NSButton *addTimeButton;

@property (strong) IBOutlet NSArrayController *usersArrayController;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) SMStatistics *statistics;

- (IBAction)addTime:(id)sender;
- (IBAction)changeStatisticsMode:(id)sender;
- (IBAction)changeUser:(id)sender;

@end
