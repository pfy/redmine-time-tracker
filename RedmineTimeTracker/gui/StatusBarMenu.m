//
//  StatusBarMenu.m
//  RedmineTimeTracker
//
//  Created by pfy on 24.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import "StatusBarMenu.h"

@implementation StatusBarMenu
-(id)init{
    self = [super init];
    if(self){
        self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
        
//        [_statusItem setMenu:self.statusMenu];
        [_statusItem setTitle:@"Aaarbeeeiiiit"];
        [_statusItem setHighlightMode:YES];
        
        
        LOG_INFO(@"statusItem %@",_statusItem);
    }
    return self;
}


@end
