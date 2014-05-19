//
//  SMNewTimeEntryWindowController.m
//  RedmineTimeTracker
//
//  Created by Florian Friedrich on 17.05.14.
//  Copyright (c) 2014 Smooh AG. All rights reserved.
//

#import "SMNewTimeEntryWindowController.h"
#import "SMTimeEntry.h"
#import "SMCurrentUser+trackingExtension.h"

static NSString *const SMRecentProjectUserDefaultsKey = @"defaultsRecentProject";

@interface SMNewTimeEntryWindowController ()

@end

@implementation SMNewTimeEntryWindowController

- (instancetype)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
        self.managedObjectContext = SMMainContext();
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    [[self window] setLevel:NSFloatingWindowLevel];
    [[self window] makeKeyWindow];
    [NSApp activateIgnoringOtherApps:YES];
    
    self.descriptionField.stringValue = @"";
    
    self.datePicker.dateValue = [NSDate date];
    self.datePicker.maxDate = [NSDate date];
    
    self.activityArrayController.managedObjectContext = self.managedObjectContext;
    self.activityArrayController.entityName = @"SMActivity";
    
    __autoreleasing NSError *error;
    if (![self.activityArrayController fetchWithRequest:nil merge:YES error:&error]) {
        LOG_ERR(@"Activity Array Controller failed to fetch: %@", error);
        error = nil;
    }
    
    self.projectArrayController.managedObjectContext = self.managedObjectContext;
    self.projectArrayController.entityName = @"SMProjects";
    
    if (![self.projectArrayController fetchWithRequest:nil merge:YES error:&error]) {
        LOG_ERR(@"Project Array Controller failed to fetch: %@", error);
        error = nil;
    }
    
    self.issueArrayController.managedObjectContext = self.managedObjectContext;
    self.issueArrayController.entityName = @"SMIssue";
    
    self.currentProjectName = [[NSUserDefaults standardUserDefaults] objectForKey:SMRecentProjectUserDefaultsKey];
}

- (void)cancelOperation:(id)sender
{
    [self.window performClose:sender];
}

- (void)setCurrentProjectName:(id)currentProjectName
{
    if (![_currentProjectName isEqual:currentProjectName]) {
        _currentProjectName = currentProjectName;
        self.issueArrayController.fetchPredicate = [NSPredicate predicateWithFormat:@"n_project.n_name = %@", self.currentProjectName];
        __autoreleasing NSError *error;
        if (![self.issueArrayController fetchWithRequest:nil merge:NO error:&error]) {
            LOG_ERR(@"Parent Issue Array Controller failed to fetch: %@", error);
        }
    }
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
    if (self.timeField.doubleValue > 0.0 && self.selectedIssueSubject && self.commentTextView.string.length > 0) {
        __autoreleasing NSError *error;
        NSFetchRequest *projectFetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"SMProjects"];
        projectFetchRequest.predicate = [NSPredicate predicateWithFormat:@"n_name = %@", self.currentProjectName];
        SMProjects *project = [[self.managedObjectContext executeFetchRequest:projectFetchRequest
                                                                        error:&error] firstObject];
        if (error) {
            LOG_ERR(@"Failed to fetch project: %@", error);
            error = nil;
        }
        if (!project) {
            return;
        }
        
        NSFetchRequest *issueFetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"SMIssue"];
        issueFetchRequest.predicate = [NSPredicate predicateWithFormat:@"n_subject = %@ AND n_project = %@",
                                       self.selectedIssueSubject, project];
        SMIssue *issue = [[self.managedObjectContext executeFetchRequest:issueFetchRequest
                                                                   error:&error] firstObject];
        if (error) {
            LOG_ERR(@"Failed to fetch issue: %@", error);
        }
        if (!issue) {
            return;
        }
        
        SMTimeEntry *entry = [NSEntityDescription insertNewObjectForEntityForName:@"SMTimeEntry"
                                                           inManagedObjectContext:self.managedObjectContext];
        
        entry.n_user = [SMCurrentUser findOrCreate].n_user;
        entry.n_activity = [self.activityArrayController arrangedObjects][self.activityPopup.indexOfSelectedItem];
        entry.n_project = project;
        entry.n_issue = issue;
        entry.n_spent_on = self.datePicker.dateValue;
        entry.n_hours = @(self.timeField.doubleValue);
        entry.n_comments = [self.commentTextView string];
        entry.changed = @YES;
        
        SAVE_APP_CONTEXT;
        [[NSUserDefaults standardUserDefaults] setValue:self.currentProjectName forKey:SMRecentProjectUserDefaultsKey];
        
        PERFORM_SYNC;
        [self.window close];
    }
}

- (void)cancelTimeEntry:(id)sender {
    [self cancelOperation:sender];
}

@end
