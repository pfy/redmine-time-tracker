//
//  SMNewIssueWindowController.m
//  RedmineTimeTracker
//
//  Created by Florian Friedrich on 15.05.14.
//  Copyright (c) 2014 Smooh AG. All rights reserved.
//

#import "SMNewIssueWindowController.h"
#import "SMIssue.h"
#import "SMCurrentUser+trackingExtension.h"
#import "AppDelegate.h"

static NSString *const SMRecentProjectUserDefaultsKey = @"defaultsRecentProject";

@interface SMNewIssueWindowController ()

@end


@implementation SMNewIssueWindowController

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
    
    self.dueDatePicker.minDate = [NSDate date];
    self.dueDatePicker.dateValue = [NSDate date];
    
    self.trackerArrayController.managedObjectContext = self.managedObjectContext;
    self.trackerArrayController.entityName = @"SMTrackers";
    
    __autoreleasing NSError *error = nil;
    if (![self.trackerArrayController fetchWithRequest:nil merge:YES error:&error]) {
        LOG_ERR(@"Tracker Array Controller failed to fetch: %@", error);
    }
    
    self.projectArrayController.managedObjectContext = self.managedObjectContext;
    self.projectArrayController.entityName = @"SMProjects";
    
    error = nil;
    if (![self.projectArrayController fetchWithRequest:nil merge:YES error:&error]) {
        LOG_ERR(@"Project Array Controller failed to fetch: %@", error);
    }
    
    self.parentIssueArrayController.managedObjectContext = self.managedObjectContext;
    self.parentIssueArrayController.entityName = @"SMIssue";
    
    self.currentProjectName = [[NSUserDefaults standardUserDefaults] objectForKey:SMRecentProjectUserDefaultsKey];
}

- (void)setCurrentProjectName:(id)currentProjectName
{
    if (![_currentProjectName isEqual:currentProjectName]) {
        _currentProjectName = currentProjectName;
        self.parentIssueArrayController.fetchPredicate = [NSPredicate predicateWithFormat:@"n_project.n_name = %@",
                                                          self.currentProjectName];
        __autoreleasing NSError *error;
        if (![self.parentIssueArrayController fetchWithRequest:nil merge:NO error:&error]) {
            LOG_ERR(@"Parent Issue Array Controller failed to fetch: %@", error);
        }
    }
}

- (void)createIssue:(id)sender {
    BOOL valid = (self.currentProjectName &&
                  self.titleField.stringValue.length > 0 &&
                  self.descriptionTextView.string.length > 0);
    if (valid) {
        SMIssue *issue = [NSEntityDescription insertNewObjectForEntityForName:@"SMIssue"
                                                           inManagedObjectContext:self.managedObjectContext];
        __autoreleasing NSError *error;
        NSFetchRequest *projectFetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"SMProjects"];
        projectFetchRequest.predicate = [NSPredicate predicateWithFormat:@"n_name = %@", self.currentProjectName];
        SMProjects *project = [[self.managedObjectContext executeFetchRequest:projectFetchRequest
                                                                        error:&error] firstObject];
        if (error) {
            LOG_ERR(@"Error while fetching project: %@", error);
            error = nil;
        }
        
        if (self.parentIssueCombo.stringValue.length > 0) {
            NSFetchRequest *parentIssueFetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"SMIssue"];
            parentIssueFetchRequest.predicate = [NSPredicate predicateWithFormat:@"n_subject = %@ AND n_project = %@",
                                                 self.parentIssueCombo.stringValue, project];
            SMIssue *parentIssue = [[self.managedObjectContext executeFetchRequest:parentIssueFetchRequest
                                                                             error:&error] firstObject];
            if (error) {
                LOG_ERR(@"Error while fetching parent issue: %@",error);
                error = nil;
            }
            issue.n_parent = parentIssue;
        }
        
        issue.n_project = project;
        issue.n_tracker = self.trackerArrayController.arrangedObjects[self.trackerPopUp.indexOfSelectedItem];
        issue.n_subject = self.titleField.stringValue;
        issue.n_description = self.descriptionTextView.string;
        issue.n_estimated_hours = @(self.estimatedTimeField.floatValue);
        issue.n_assigned_to = [SMCurrentUser findOrCreate].n_user;
        
        if (self.dueDateEnabledCheckBox.state == NSOnState) {
            issue.n_due_date = self.dueDatePicker.dateValue;
        }
        
        issue.changed = @YES;
        
        SAVE_APP_CONTEXT
        [[NSUserDefaults standardUserDefaults] setValue:self.currentProjectName forKey:SMRecentProjectUserDefaultsKey];
        
        AppDelegate *app = [NSApp delegate];
        [app.updateCenter update];
        
        [self.window close];
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

#pragma mark - Sort Descriptors
- (NSArray *)trackersSortDescriptors
{
    return @[[NSSortDescriptor sortDescriptorWithKey:@"n_name"
                                           ascending:YES
                                            selector:@selector(caseInsensitiveCompare:)]];
}

- (NSArray *)projectSortDescriptors {
    return @[[NSSortDescriptor sortDescriptorWithKey:@"n_name"
                                           ascending:YES
                                            selector:@selector(caseInsensitiveCompare:)]];
}
- (NSArray *)parentIssueSortDescriptors {
    return @[[NSSortDescriptor sortDescriptorWithKey:@"n_subject"
                                           ascending:YES
                                            selector:@selector(caseInsensitiveCompare:)]];
}

@end
