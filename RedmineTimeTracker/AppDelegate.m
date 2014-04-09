//
//  AppDelegate.m
//  RedmineTimeTracker
//
//  Created by David Gunzinger Smooh GmbH on 23.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import "AppDelegate.h"
#import "SMNetworkUpdate.h"
#import "SMCurrentUser+trackingExtension.h"

@implementation AppDelegate


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.asyncDbQueue = [[NSOperationQueue alloc]init];
    [self.asyncDbQueue setMaxConcurrentOperationCount:1];

    self.timeTracker = [TimeTracker new];
    
    
   self.updateCenter = [SMNetworkUpdate new];
   [self.updateCenter  update];
    SMCurrentUser *user = [SMCurrentUser findOrCreate];
    if(!user.serverUrl || !user.authToken){
        [self showPreferences];
    }
    
    
    self.statusBarMenu = [StatusBarMenu new];
    self.activeApplicationTracker = [ActiveApplicationTracker new];
 
    

    self.trackingVc = [[TrackingWindowController alloc] initWithWindowNibName:@"TrackingWindowController"];
    [self.trackingVc showWindow:self];

    LOG_INFO(@"App Started");
    // Insert code here to initialize your application
}

// Returns the directory the application uses to store the Core Data store file. This code uses a directory named "ch.smooh.RedmineTimeTracker" in the user's Application Support directory.
- (NSURL *)applicationFilesDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *appSupportURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    return [appSupportURL URLByAppendingPathComponent:@"ch.smooh.RedmineTimeTracker"];
}


-(void)showPreferences{
    self.preferences = [[PreferencesWindowController alloc] initWithWindowNibName:@"PreferencesWindowController"];
    [self.preferences showWindow:self];
}



-(void)showAppTracker{
    self.applicationTrackerWindowController = [[ApplicationTrackerWindowController alloc] initWithWindowNibName:@"ApplicationTrackerWindowController"];
    [self.applicationTrackerWindowController showWindow:self];
}



@end
