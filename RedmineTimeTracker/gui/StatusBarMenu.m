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
#import "SMTimeEntry+DisplayThingi.h"

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
        NSMenuItem *preferencesMenuItem = [[NSMenuItem alloc] initWithTitle:@"Preferences" action:@selector(preferences) keyEquivalent: @""];
        [preferencesMenuItem setTarget:self];
        [self.statusMenu addItem:preferencesMenuItem];
        [_statusItem setMenu:self.statusMenu];
        [_statusItem setTitle:@"Aaarbeeeiiiit"];
        [_statusItem setHighlightMode:YES];
        [self registerHotkey];
        
        self.user = [SMCurrentUser findOrCreate];
        [self.user addObserver:self forKeyPath:@"currentTimeEntry" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        [self updateStatusText];
        LOG_INFO(@"statusItem %@",_statusItem);
    }
    return self;
}

-(bool)validateMenuItem:(NSMenuItem*)item{
    LOG_INFO(@"validateMenuItem");
    return YES;
}

-(void)preferences{
    LOG_INFO(@"show preferences");

    AppDelegate *app = [NSApplication sharedApplication].delegate;
    [app showPreferences];
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
-(void)setEntry:(SMTimeEntry *)entry{
    if(entry != _entry){
        [_entry removeObserver:self forKeyPath:@"formattedTime"];
        [entry addObserver:self forKeyPath:@"formattedTime" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        _entry = entry;
    }
}

-(void)updateStatusText{
    [self setEntry:self.user.currentTimeEntry];
    if(self.entry){
        [_statusItem setTitle:[NSString stringWithFormat:@"%@",self.entry.formattedTime]];
    } else {
        [_statusItem setTitle:@"Idle"];

    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    [self updateStatusText];
}

@end
