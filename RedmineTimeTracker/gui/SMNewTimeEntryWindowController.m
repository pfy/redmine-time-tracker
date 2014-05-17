//
//  SMNewTimeEntryWindowController.m
//  RedmineTimeTracker
//
//  Created by Florian Friedrich on 17.05.14.
//  Copyright (c) 2014 Smooh AG. All rights reserved.
//

#import "SMNewTimeEntryWindowController.h"

@interface SMNewTimeEntryWindowController ()

@end

@implementation SMNewTimeEntryWindowController

- (instancetype)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (void)cancelOperation:(id)sender
{
    [self.window performClose:sender];
}

#pragma mark - NSTextViewDelegate
- (BOOL)textView:(NSTextView *)textView doCommandBySelector:(SEL)commandSelector
{
    if (commandSelector == @selector(insertTab:)) {
        [self.window selectNextKeyView:textView];
        return YES;
    }
    if (commandSelector == @selector(insertBacktab:)) {
        [self.window selectPreviousKeyView:textView];
        return YES;
    }
    return NO;
}


- (void)createTimeEntry:(id)sender {
    
}

- (void)cancelTimeEntry:(id)sender {
    [self cancelOperation:sender];
}

@end
