//
//  AppDelegate.m
//  RedmineTimeTracker
//
//  Created by David Gunzinger Smooh GmbH on 23.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import "AppDelegate.h"
#import "SMCurrentUser+trackingExtension.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    self.dayRoutineTracker = [SMDayRoutineTracker new];
    self.timeTracker = [TimeTracker new];
    self.activeApplicationTracker = [ActiveApplicationTracker new];
    
    self.updateCenter = [SMNetworkUpdate new];
    [self.updateCenter update];
    
    self.statusBarMenu = [SMStatusBarMenu new];
    
    SMCurrentUser *user = [SMCurrentUser findOrCreate];
    if (!user.serverUrl.length || !user.authToken.length) {
        [self.statusBarMenu.windowsManager showPreferencesWindow:self.statusBarMenu.preferencesMenuItem];
    }
    
    [self.statusBarMenu.windowsManager showTrackingWindow:self];
    
    LOG_INFO(@"App Started");
}

@end
