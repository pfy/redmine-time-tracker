//
//  AppDelegate.h
//  RedmineTimeTracker
//
//  Created by David Gunzinger Smooh GmbH on 23.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "StatusBarMenu.h"
#import "ActiveApplicationTracker.h"
#import "TrackingWindowController.h"
#import "TimeTracker.h"
#import "PreferencesWindowController.h"
#import "SMNetworkUpdate.h"
#import "ApplicationTrackerWindowController.h"


@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,retain) NSOperationQueue *asyncDbQueue;
@property (nonatomic,weak)  IBOutlet NSOutlineView *outlineView;
@property (nonatomic,strong) TrackingWindowController *trackingVc;
@property (nonatomic,strong) TimeTracker *timeTracker;
@property (nonatomic,strong) PreferencesWindowController *preferences;
@property (nonatomic,strong) SMNetworkUpdate *updateCenter;



@property (nonatomic,strong) StatusBarMenu  *statusBarMenu;
@property (nonatomic,strong)  ActiveApplicationTracker *activeApplicationTracker;
@property (nonatomic,strong)  ApplicationTrackerWindowController *applicationTrackerWindowController;

- (IBAction)saveAction:(id)sender;
- (void)saveContext;
-(void)showPreferences;
-(void)showAppTracker;

@end
