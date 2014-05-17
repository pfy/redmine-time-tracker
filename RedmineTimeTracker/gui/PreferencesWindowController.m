//
//  PreferencesWindowController.m
//  RedmineTimeTracker
//
//  Created by David Gunzinger Smooh GmbH on 29.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import "PreferencesWindowController.h"
#import "MASShortcutView+UserDefaults.h"

@interface PreferencesWindowController ()

@end

@implementation PreferencesWindowController

- (instancetype)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
        self.user = [SMCurrentUser findOrCreate];
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    [[self window] setLevel:NSFloatingWindowLevel];
    [[self window] makeKeyWindow];
    [NSApp activateIgnoringOtherApps:YES];
    
    self.startTrackingShortcutView.associatedUserDefaultsKey = @"SMStartTrackingShortcut";
    self.stopTrackingShortcutView.associatedUserDefaultsKey = @"SMStopTrackingShortcut";
    self.createNewIssueShortcutView.associatedUserDefaultsKey = @"SMNewIssueShortcut";
    
    if (self.user.serverUrl) {
        [self.hostnameTextField setStringValue:self.user.serverUrl];
    }
    if (self.user.authToken.length > 0) {
        [self.tokenTextField setStringValue:self.user.authToken];
    } else {
        [self.tokenTextField becomeFirstResponder];
    }
    
    self.workdayDurationField.floatValue = self.user.workdayDuration.floatValue;
    self.workdayDurationToleranceField.floatValue = self.user.workdayDurationTolerance.floatValue;
    
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (void)windowWillClose:(NSNotification *)notification
{
    // Maybe safe the things here too?
}

- (void)dealloc {
    self.user = nil;
}

- (void)donePressed:(id)sender {
    self.user.serverUrl = [self.hostnameTextField stringValue];
    self.user.authToken = [self.tokenTextField stringValue];
    self.user.workdayDuration = @(self.workdayDurationField.floatValue);
    self.user.workdayDurationTolerance = @(self.workdayDurationToleranceField.floatValue);
    LOG_INFO(@"Did save user %@", self.user);
    
    SAVE_APP_CONTEXT;
    [self.window close];
}

@end
