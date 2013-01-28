//
//  TrackingWindowController.m
//  RedmineTimeTracker
//
//  Created by pfy on 28.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import "TrackingWindowController.h"

@interface TrackingWindowController ()

@end

@implementation TrackingWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
        self.context = [(AppDelegate*)[NSApplication sharedApplication].delegate managedObjectContext];

    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    [self.timeEntryArrayController setManagedObjectContext:self.context];
    [self.timeEntryArrayController setEntityName:@"SMTimeEntry"];
    
    NSError *error;
    [self.timeEntryArrayController fetchWithRequest:nil merge:YES error:&error];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
