//
//  StartTrackingWindowController.m
//  RedmineTimeTracker
//
//  Created by pfy on 28.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import "StartTrackingWindowController.h"

@interface StartTrackingWindowController ()

@end

@implementation StartTrackingWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        self.context = [(AppDelegate*)[NSApplication sharedApplication].delegate managedObjectContext];
        self.projectArrayController = [[NSArrayController alloc] initWithContent:nil];
        [self.projectArrayController setManagedObjectContext:self.context];
        [self.projectArrayController setEntityName:@"SMProjects"];
        
        NSError *error;
        [self.projectArrayController fetchWithRequest:nil merge:YES error:&error];
        LOG_INFO(@"fetched objects %@",[[self.projectArrayController arrangedObjects] valueForKey:@"n_name"]);
     

        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    [[self window] setLevel:NSFloatingWindowLevel];
    [[self window] makeKeyWindow];
    [NSApp activateIgnoringOtherApps:YES];
   //[self.projectField bind:@"contentValues" toObject:self.projectArrayController withKeyPath:@"arrangedObjects.n_name" options:nil];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
