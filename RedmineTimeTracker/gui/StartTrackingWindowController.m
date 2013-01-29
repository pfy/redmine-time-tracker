//
//  StartTrackingWindowController.m
//  RedmineTimeTracker
//
//  Created by pfy on 28.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import "StartTrackingWindowController.h"
#import "SMTimeEntry.h"
#import "SMCurrentUser+trackingExtension.h"
static NSString *recentProjectDefaultsKey = @"defaultsRecentProject";


@interface StartTrackingWindowController ()

@end

@implementation StartTrackingWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        self.context = [(AppDelegate*)[NSApplication sharedApplication].delegate managedObjectContext];
        self.currentProject = [[NSUserDefaults standardUserDefaults]objectForKey:recentProjectDefaultsKey];

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
    if(self.currentIssue && [[self.commentTextView stringValue] isNotEqualTo:@""]){
        SMTimeEntry *entry = [NSEntityDescription insertNewObjectForEntityForName:@"SMTimeEntry" inManagedObjectContext:self.context];
        NSError *error;
        NSFetchRequest *projectFetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"SMProjects"];
        projectFetchRequest.predicate = [NSPredicate predicateWithFormat:@"n_name = %@",self.currentProject];
        SMProjects *currentProject = [[self.context executeFetchRequest:projectFetchRequest error:&error] objectAtIndex:0];
        if(error){
            LOG_ERR(@"error happend %@",error);
            error = nil;
        }
        
        NSFetchRequest *issueFetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"SMIssue"];
        issueFetchRequest.predicate = [NSPredicate predicateWithFormat:@"n_subject =  %@ and n_project=%@",self.currentIssue,currentProject];
        SMIssue *currentIssue = [[self.context executeFetchRequest:issueFetchRequest error:&error] objectAtIndex:0];
        if(error){
            LOG_ERR(@"error happend %@",error);
            error = nil;
        }
        entry.n_issue = currentIssue;
        entry.n_spent_on = [NSDate date];
        entry.n_project = currentProject;
        entry.n_comments = [self.commentTextView stringValue];
        entry.n_user = [SMCurrentUser findOrCreate].n_user;
        entry.changed = [NSNumber numberWithBool:YES];
        [SMCurrentUser findOrCreate].currentTimeEntry = entry;

        SAVE_APP_CONTEXT
        [[NSUserDefaults standardUserDefaults]setValue:self.currentProject forKey:recentProjectDefaultsKey];
        
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
        [self.issueArrayController fetchWithRequest:nil merge:NO error:&error];
       // LOG_INFO(@"fetch complete, got %@ objects",self.issueArrayController.arrangedObjects);
    } else if ([keyPath isEqualToString:@"currentIssue"]){
        
    }
}


- (NSArray *)projectSortDescriptors {
    return [NSArray arrayWithObject:
            [NSSortDescriptor sortDescriptorWithKey:@"n_name"
                                          ascending:YES selector:@selector(caseInsensitiveCompare:)]];
}
- (NSArray *)issueSortDescriptors {
    return [NSArray arrayWithObject:
            [NSSortDescriptor sortDescriptorWithKey:@"n_subject"
                                          ascending:YES selector:@selector(caseInsensitiveCompare:)]];
}

@end
