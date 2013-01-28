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
    
    
    [self.projectArrayController setManagedObjectContext:self.context];
    [self.projectArrayController setEntityName:@"SMProjects"];
    
    NSError *error;
    [self.projectArrayController fetchWithRequest:nil merge:YES error:&error];
    
    [self.issueArrayController setManagedObjectContext:self.context];
    [self.issueArrayController setEntityName:@"SMIssue"];
    [self.issueArrayController fetchWithRequest:nil merge:YES error:&error];
    
    
    LOG_INFO(@"fetched objects %@",[[self.projectArrayController arrangedObjects] valueForKey:@"n_name"]);
    
    
    [self.projectArrayController addObserver:self forKeyPath:@"selection.n_name" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];


       // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    LOG_INFO(@"did observer change %@ at %@ for %@",change,keyPath,object);
    LOG_INFO(@"array section %@ ",[self.projectArrayController.selection valueForKey:@"issues"]);
    
}
@end
