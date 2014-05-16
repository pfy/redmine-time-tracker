//
//  StartTrackingWindowController.h
//  RedmineTimeTracker
//
//  Created by David Gunzinger Smooh GmbH on 28.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SMProjects.h"
#import "SMIssue.h"

@interface StartTrackingWindowController : NSWindowController <NSTextViewDelegate>

@property (nonatomic,strong) IBOutlet NSPopUpButton *activityPopup;
@property (nonatomic,strong) IBOutlet NSComboBox *projectField;
@property (nonatomic,strong) IBOutlet NSComboBox *issuesField;
@property (nonatomic,strong) IBOutlet NSTextView *commentTextView;
@property (nonatomic,strong) IBOutlet NSArrayController *activityArrayController;
@property (nonatomic,strong) IBOutlet NSArrayController *projectArrayController;
@property (nonatomic,strong) IBOutlet NSArrayController *issueArrayController;

@property (nonatomic,weak)  NSManagedObjectContext *context;
@property (nonatomic,strong) id currentProject;
@property (nonatomic,strong) id currentIssue;

- (IBAction)startTracking:(id)sender;
- (IBAction)cancelTracking:(id)sender;

@property (nonatomic,strong,readonly) NSArray *activitySortDescriptors;
@property (nonatomic,strong,readonly) NSArray *projectSortDescriptors;
@property (nonatomic,strong,readonly) NSArray *issueSortDescriptors;

@end
