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
#import "SMStatistics.h"
#import "SMWindowsManager.h"
#import "SMIssue+IssueCreation.h"

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

    [self updateWithStatistics];
}

- (void)cancelOperation:(id)sender
{
    [self.window performClose:sender];
}

- (void)updateWithStatistics
{
    if (self.statistics.missingTime > 0.0) {
        self.descriptionField.stringValue = [NSString stringWithFormat:@"There are %.3f hours missing.",
                                             self.statistics.missingTime];
        self.timeField.doubleValue = self.statistics.missingTime;
    } else {
        self.descriptionField.stringValue = @"";
    }
}

#pragma mark - Properties
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

- (void)setStatistics:(SMStatistics *)statistics
{
    if (![_statistics isEqual:statistics]) {
        _statistics = statistics;
        [self updateWithStatistics];
    }
}

#pragma mark - Actions
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
        BOOL sync = YES;
        if (!issue) {
            sync = NO;
            issue = [SMIssue newIssueInContext:self.managedObjectContext];
            issue.n_project = project;
            issue.n_subject = self.selectedIssueSubject;
            SMWindowEvent *event = [SMWindowEvent eventWithSender:self.issueComboBox];
            event.issue = issue;
            [[SMWindowsManager sharedWindowsManager] showNewIssueWindowForEvent:event];
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
        
        [[NSUserDefaults standardUserDefaults] setValue:self.currentProjectName forKey:SMRecentProjectUserDefaultsKey];
        if (sync) {
            SAVE_APP_CONTEXT;
            PERFORM_SYNC;
        }
        [self.window close];
    }
}

- (void)cancelTimeEntry:(id)sender {
    [self cancelOperation:sender];
}

#pragma mark - Sort Descriptors
- (NSArray *)activitySortDescriptors
{
    return @[[NSSortDescriptor sortDescriptorWithKey:@"n_name"
                                           ascending:YES
                                            selector:@selector(caseInsensitiveCompare:)]];
}

- (NSArray *)projectSortDescriptors
{
    return @[[NSSortDescriptor sortDescriptorWithKey:@"n_name"
                                           ascending:YES
                                            selector:@selector(caseInsensitiveCompare:)]];
}

- (NSArray *)issueSortDescriptors
{
    return @[[NSSortDescriptor sortDescriptorWithKey:@"n_subject"
                                           ascending:YES
                                            selector:@selector(caseInsensitiveCompare:)]];
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

@end
