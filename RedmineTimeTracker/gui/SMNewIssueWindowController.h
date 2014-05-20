//
//  SMNewIssueWindowController.h
//  RedmineTimeTracker
//
//  Created by Florian Friedrich on 15.05.14.
//  Copyright (c) 2014 Smooh AG. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SMNewIssueWindowController : NSWindowController <NSTextViewDelegate>

@property (weak) IBOutlet NSTextField *trackerLabel;
@property (weak) IBOutlet NSPopUpButton *trackerPopUp;
@property (weak) IBOutlet NSTextField *projectLabel;
@property (weak) IBOutlet NSComboBox *projectCombo;
@property (weak) IBOutlet NSTextField *titleLabel;
@property (weak) IBOutlet NSTextField *titleField;
@property (weak) IBOutlet NSTextField *descriptionLabel;
@property (weak) IBOutlet NSScrollView *descriptionScrollView;
@property (strong) IBOutlet NSTextView *descriptionTextView;
@property (weak) IBOutlet NSTextField *parentIssueLabel;
@property (weak) IBOutlet NSComboBox *parentIssueCombo;
@property (weak) IBOutlet NSTextField *dueDateLabel;
@property (weak) IBOutlet NSDatePicker *dueDatePicker;
@property (weak) IBOutlet NSButton *dueDateEnabledCheckBox;
@property (weak) IBOutlet NSTextField *estimatedTimeLabel;
@property (weak) IBOutlet NSTextField *estimatedTimeField;
@property (weak) IBOutlet NSButton *createButton;
@property (strong) IBOutlet NSArrayController *trackerArrayController;
@property (strong) IBOutlet NSArrayController *projectArrayController;
@property (strong) IBOutlet NSArrayController *parentIssueArrayController;

@property (strong, nonatomic) id currentProjectName;

@property (readonly) NSArray *trackersSortDescriptors;
@property (readonly) NSArray *projectSortDescriptors;
@property (readonly) NSArray *parentIssueSortDescriptors;

@property (strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong) SMIssue *issue;

- (IBAction)createIssue:(id)sender;

@end
