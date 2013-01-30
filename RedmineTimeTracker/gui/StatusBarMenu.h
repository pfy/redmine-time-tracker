//
//  StatusBarMenu.h
//  RedmineTimeTracker
//
//  Created by David Gunzinger Smooh GmbH on 24.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StartTrackingWindowController.h"
#import "SMCurrentUser+trackingExtension.h"
#import "SMTimeEntry+DisplayThingi.h"

@interface StatusBarMenu : NSObject
@property (nonatomic,strong) NSStatusItem *statusItem;
@property (nonatomic,strong) NSMenu *statusMenu;
@property (nonatomic,strong) NSMenuItem *startTrackingMenuItem;
@property (nonatomic,strong) NSMenuItem *stopTrackingMenuItem;
@property (nonatomic,strong) StartTrackingWindowController *startTrackingWindowController;
@property (nonatomic,strong) SMCurrentUser *user;
@property (nonatomic,strong) SMTimeEntry *entry;

@end
