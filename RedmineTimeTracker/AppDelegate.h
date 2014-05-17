//
//  AppDelegate.h
//  RedmineTimeTracker
//
//  Created by David Gunzinger Smooh GmbH on 23.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SMStatusBarMenu.h"
#import "ActiveApplicationTracker.h"
#import "TimeTracker.h"
#import "SMNetworkUpdate.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic,strong) SMStatusBarMenu *statusBarMenu;

@property (nonatomic,strong) TimeTracker *timeTracker;
@property (nonatomic,strong) ActiveApplicationTracker *activeApplicationTracker;

@property (nonatomic,strong) SMNetworkUpdate *updateCenter;

@end
