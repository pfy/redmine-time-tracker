//
//  StatusBarMenu.h
//  RedmineTimeTracker
//
//  Created by pfy on 24.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatusBarMenu : NSObject
@property (nonatomic,strong) NSStatusItem *statusItem;
@property (nonatomic,strong) NSMenu *statusMenu;
@property (nonatomic,strong) NSMenuItem *startTrackingMenuItem;
@property (nonatomic,strong) NSMenuItem *stopTrackingMenuItem;


@end
