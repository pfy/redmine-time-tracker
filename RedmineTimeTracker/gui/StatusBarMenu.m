//
//  StatusBarMenu.m
//  RedmineTimeTracker
//
//  Created by pfy on 24.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import "StatusBarMenu.h"
#import "DDHotKeyCenter.h"

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
}
-(void)stopTracking{
    LOG_WARN(@"====== STOP TRARCKING =======");
}

-(void)registerHotkey{
    DDHotKeyCenter *center = [DDHotKeyCenter sharedHotKeyCenter];
    center registerHotKeyWithKeyCode:'1' modifierFlags:<#(NSUInteger)#> target:<#(id)#> action:<#(SEL)#> object:<#(id)#>
}




@end
