//
//  PreferencesWindowController.m
//  RedmineTimeTracker
//
//  Created by pfy on 29.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import "PreferencesWindowController.h"

@interface PreferencesWindowController ()

@end

@implementation PreferencesWindowController

- (id)initWithWindow:(NSWindow *)window
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
    if(self.user.serverUrl)
        [self.hostnameTextField setStringValue:self.user.serverUrl];
    if(self.user.authToken)
        [self.tokenTextField setStringValue:self.user.authToken];
    
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

-(void)dealloc{
    self.user = nil;
}

-(IBAction)donePressed:(id)sender{
    self.user.serverUrl = [self.hostnameTextField stringValue];
    self.user.authToken = [self.tokenTextField stringValue];
    LOG_INFO(@"did save user %@",self.user);
    SAVE_APP_CONTEXT;
    [self.window close];

}



@end
