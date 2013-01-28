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
    
    
    [self addObserver:self forKeyPath:@"currentProject" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [self addObserver:self forKeyPath:@"currentIssue" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    [self.projectArrayController setManagedObjectContext:self.context];
    [self.projectArrayController setEntityName:@"SMProjects"];
    
    NSError *error;
    [self.projectArrayController fetchWithRequest:nil merge:YES error:&error];
    
    [self.issueArrayController setManagedObjectContext:self.context];
    [self.issueArrayController setEntityName:@"SMIssue"];
    self.issueArrayController.fetchPredicate = [NSPredicate predicateWithFormat:@"n_project = %@",self.projectArrayController.selection];
    [self.issueArrayController fetchWithRequest:nil merge:YES error:&error];
    
    
    
    LOG_INFO(@"fetched objects %@",[[self.projectArrayController arrangedObjects] valueForKey:@"n_name"]);
    
    
    
    
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

-(IBAction)startTracking:(id)sender{
    if(self.currentIssue){
    [self.window close];
    }

}
-(IBAction)cancelTracking:(id)sender{
    [self.window close];
}



-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if([keyPath isEqualToString:@"currentProject"]){
        NSError *error;
        self.issueArrayController.fetchPredicate = [NSPredicate predicateWithFormat:@"n_project.n_name = %@",self.currentProject];
        [self.issueArrayController fetchWithRequest:nil merge:YES error:&error];
        LOG_INFO(@"fetch complete, got %@ objects",[self.issueArrayController.arrangedObjects valueForKey:@"n_subject"]);
    } else if ([keyPath isEqualToString:@"currentIssue"]){
        
    }
    
}
@end
