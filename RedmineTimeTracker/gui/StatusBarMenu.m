//
//  StatusBarMenu.m
//  RedmineTimeTracker
//
//  Created by pfy on 24.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import "StatusBarMenu.h"
#import "DDHotKeyCenter.h"
#import "SMCurrentUser+trackingExtension.h"

@implementation StatusBarMenu
-(id)init{
    self = [super init];
    if(self){
        self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
        
        self.statusMenu = [NSMenu new];
        self.startTrackingMenuItem = [[NSMenuItem alloc] initWithTitle:@"Start Tracking"  action:@selector(startTracking) keyEquivalent:@"1"];
        [self.startTrackingMenuItem setTarget:self];
        
        self.stopTrackingMenuItem = [[NSMenuItem alloc] initWithTitle:@"Stop Tracking"  action:@selector(stopTracking) keyEquivalent:@"2"];
        [self.stopTrackingMenuItem setTarget:self];

        [self.statusMenu setAutoenablesItems:NO];
        
        [self.statusMenu addItem:self.startTrackingMenuItem];
        [self.statusMenu addItem:self.stopTrackingMenuItem];
        
        
        
        [_statusItem setMenu:self.statusMenu];
        [_statusItem setTitle:@"Aaarbeeeiiiit"];
        [_statusItem setHighlightMode:YES];
        [self registerHotkey];
        LOG_INFO(@"statusItem %@",_statusItem);
    }
    return self;
}

-(bool)validateMenuItem:(NSMenuItem*)item{
    LOG_INFO(@"validateMenuItem");
    return YES;
}

-(void)startTracking{
    LOG_WARN(@"====== START TRARCKING =======");
    
    self.startTrackingWindowController = [[StartTrackingWindowController alloc] initWithWindowNibName:@"StartTrackingWindowController"];
    [self.startTrackingWindowController showWindow:self];

}
-(void)stopTracking{
    LOG_WARN(@"====== STOP TRARCKING =======");
    [SMCurrentUser findOrCreate].currentTimeEntry = nil;
    SAVE_APP_CONTEXT
    
}

-(void)registerHotkey{
    DDHotKeyCenter *center = [DDHotKeyCenter sharedHotKeyCenter];
    [center registerHotKeyWithKeyCode:18 modifierFlags:NSCommandKeyMask target:self action:@selector(startTracking) object:nil];
       [center registerHotKeyWithKeyCode:19 modifierFlags:NSCommandKeyMask target:self action:@selector(stopTracking) object:nil];
}




@end
