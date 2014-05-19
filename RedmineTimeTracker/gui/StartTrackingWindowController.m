//
//  StartTrackingWindowController.m
//  RedmineTimeTracker
//
//  Created by David Gunzinger Smooh GmbH on 28.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import "StartTrackingWindowController.h"
#import "SMTimeEntry.h"
#import "SMCurrentUser+trackingExtension.h"

static NSString *recentProjectDefaultsKey = @"defaultsRecentProject";

@interface StartTrackingWindowController ()

@end

@implementation StartTrackingWindowController

- (instancetype)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        self.context = SMMainContext();
        
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
    
    [self addObserver:self forKeyPath:@"currentProject"
              options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
              context:nil];
    [self addObserver:self forKeyPath:@"currentIssue"
              options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
              context:nil];
    
    [self.activityArrayController setManagedObjectContext:self.context];
    [self.activityArrayController setEntityName:@"SMActivity"];
    
    __autoreleasing NSError *error;
    [self.activityArrayController fetchWithRequest:nil merge:YES error:&error];
//    self.activityArrayController.selection = [[self.activityArrayController arrangedObjects] firstObject];
    
    [self.projectArrayController setManagedObjectContext:self.context];
    [self.projectArrayController setEntityName:@"SMProjects"];
    
    error = nil;
    [self.projectArrayController fetchWithRequest:nil merge:YES error:&error];
    
    [self.issueArrayController setManagedObjectContext:self.context];
    [self.issueArrayController setEntityName:@"SMIssue"];
    
    
    self.currentProject = [[NSUserDefaults standardUserDefaults] objectForKey:recentProjectDefaultsKey];
    
    LOG_INFO(@"fetched objects %@", [[self.projectArrayController arrangedObjects] valueForKey:@"n_name"]);
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"currentProject"];
    [self removeObserver:self forKeyPath:@"currentIssue"];
}

-(void)startTracking:(id)sender {
    if(self.currentIssue && self.commentTextView.string.length > 0){
        __autoreleasing NSError *error;
        NSFetchRequest *projectFetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"SMProjects"];
        projectFetchRequest.predicate = [NSPredicate predicateWithFormat:@"n_name = %@", self.currentProject];
        SMProjects *currentProject = [self.context executeFetchRequest:projectFetchRequest error:&error][0];
        if(error){
            LOG_ERR(@"error happend %@",error);
            error = nil;
        }
        
        if (!currentProject) {
            return;
        }
        
        NSFetchRequest *issueFetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"SMIssue"];
        issueFetchRequest.predicate = [NSPredicate predicateWithFormat:@"n_subject = %@ AND n_project = %@", self.currentIssue, currentProject];
        SMIssue *currentIssue = [[self.context executeFetchRequest:issueFetchRequest error:&error] firstObject];
        if (error) {
            LOG_ERR(@"error happend %@",error);
            error = nil;
        }
        if (!currentIssue) {
            return;
        }
        
        SMTimeEntry *entry = [NSEntityDescription insertNewObjectForEntityForName:@"SMTimeEntry"
                                                           inManagedObjectContext:self.context];
        
        entry.n_activity = [self.activityArrayController arrangedObjects][self.activityPopup.indexOfSelectedItem];
        entry.n_issue = currentIssue;
        entry.n_spent_on = [NSDate date];
        entry.n_project = currentProject;
        entry.n_comments = [self.commentTextView string];
        entry.n_user = [SMCurrentUser findOrCreate].n_user;
        entry.changed = @YES;
        [SMCurrentUser findOrCreate].currentTimeEntry = entry;
        
        SAVE_APP_CONTEXT;
        [[NSUserDefaults standardUserDefaults] setValue:self.currentProject forKey:recentProjectDefaultsKey];
        
        [self.window close];
    }
}

-(void)cancelTracking:(id)sender{
    [self.window close];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if([keyPath isEqualToString:@"currentProject"]){
        __autoreleasing NSError *error;
        self.issueArrayController.fetchPredicate = [NSPredicate predicateWithFormat:@"n_project.n_name = %@",self.currentProject];
        [self.issueArrayController fetchWithRequest:nil merge:NO error:&error];
        // LOG_INFO(@"fetch complete, got %@ objects",self.issueArrayController.arrangedObjects);
    } else if ([keyPath isEqualToString:@"currentIssue"]){
        
    } else {
        // TODO: Call super
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
- (NSArray *)activitySortDescriptors {
    return @[[NSSortDescriptor sortDescriptorWithKey:@"n_name"
                                           ascending:YES selector:@selector(caseInsensitiveCompare:)]];
}

- (NSArray *)projectSortDescriptors {
    return @[[NSSortDescriptor sortDescriptorWithKey:@"n_name"
                                           ascending:YES selector:@selector(caseInsensitiveCompare:)]];
}
- (NSArray *)issueSortDescriptors {
    return @[[NSSortDescriptor sortDescriptorWithKey:@"n_subject"
                                           ascending:YES selector:@selector(caseInsensitiveCompare:)]];
}

@end
