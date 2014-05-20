//
//  SMNewTimeEntryWindowController.h
//  RedmineTimeTracker
//
//  Created by Florian Friedrich on 17.05.14.
//  Copyright (c) 2014 Smooh AG. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SMNewTimeEntryWindowController : NSWindowController <NSTextViewDelegate>

@property (weak) IBOutlet NSTextField *descriptionField;
@property (weak) IBOutlet NSTextField *activityLabel;
@property (weak) IBOutlet NSPopUpButton *activityPopup;
@property (weak) IBOutlet NSTextField *projectLabel;
@property (weak) IBOutlet NSComboBox *projectComboBox;
@property (weak) IBOutlet NSTextField *issueLabel;
@property (weak) IBOutlet NSComboBox *issueComboBox;
@property (weak) IBOutlet NSTextField *timeLabel;
@property (weak) IBOutlet NSTextField *timeField;
@property (weak) IBOutlet NSTextField *dateLabel;
@property (weak) IBOutlet NSDatePicker *datePicker;
@property (weak) IBOutlet NSTextField *commentLabel;
@property (strong) IBOutlet NSTextView *commentTextView;
@property (weak) IBOutlet NSButton *cancelButton;
@property (weak) IBOutlet NSButton *createButton;

@property (strong) IBOutlet NSArrayController *activityArrayController;
@property (strong) IBOutlet NSArrayController *projectArrayController;
@property (strong) IBOutlet NSArrayController *issueArrayController;

@property (nonatomic) id currentProjectName;
@property (nonatomic) id selectedIssueSubject;

@property (nonatomic, strong, readonly) NSArray *activitySortDescriptors;
@property (nonatomic, strong, readonly) NSArray *projectSortDescriptors;
@property (nonatomic, strong, readonly) NSArray *issueSortDescriptors;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong) SMStatistics *statistics;

- (IBAction)createTimeEntry:(id)sender;
- (IBAction)cancelTimeEntry:(id)sender;

@end
