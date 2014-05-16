//
//  PreferencesWindowController.h
//  RedmineTimeTracker
//
//  Created by David Gunzinger Smooh GmbH on 29.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MASShortcutView.h"
#import "SMCurrentUser+trackingExtension.h"

@interface PreferencesWindowController : NSWindowController <NSWindowDelegate>

@property (nonatomic,weak) IBOutlet NSTextField *hostnameTextField;
@property (nonatomic,weak) IBOutlet NSTextField *tokenTextField;
@property (weak) IBOutlet MASShortcutView *startTrackingShortcutView;
@property (weak) IBOutlet MASShortcutView *stopTrackingShortcutView;
@property (weak) IBOutlet MASShortcutView *createNewIssueShortcutView;
@property (weak) IBOutlet NSTextField *workdayDurationField;
@property (weak) IBOutlet NSTextField *workdayDurationToleranceField;

@property (nonatomic,strong) SMCurrentUser *user;

- (IBAction)donePressed:(id)sender;

@end
