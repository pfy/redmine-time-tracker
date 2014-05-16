//
//  StatusBarMenu.m
//  RedmineTimeTracker
//
//  Created by David Gunzinger Smooh GmbH on 24.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import "StatusBarMenu.h"
#import "SMCurrentUser+trackingExtension.h"
#import "SMTimeEntry+DisplayThingi.h"
#import "AppDelegate.h"
#import "MASShortcut+UserDefaults.h"
//#import "DDHotKeyCenter.h"

@interface StatusBarMenu ()
@property (nonatomic, strong, readonly) NSSet *shortcutKeys;
@end

@implementation StatusBarMenu
@synthesize shortcutKeys = _shortcutKeys;

-(instancetype)init{
    self = [super init];
    if(self){
        self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
        
        self.createNewIssueMenuItem = [[NSMenuItem alloc] initWithTitle:@"Create Issue"
                                                                 action:@selector(createNewIssue)
                                                          keyEquivalent:@""];
        self.createNewIssueMenuItem.target = self;
        
        self.startTrackingMenuItem = [[NSMenuItem alloc] initWithTitle:@"Start Tracking"
                                                                action:@selector(startTracking)
                                                         keyEquivalent:@""];
        [self.startTrackingMenuItem setTarget:self];
        
        self.stopTrackingMenuItem = [[NSMenuItem alloc] initWithTitle:@"Stop Tracking"
                                                               action:@selector(stopTracking)
                                                        keyEquivalent:@""];
        [self.stopTrackingMenuItem setTarget:self];
        
        [self configureMenuItemsWithShortcuts];
        
        self.statusMenu = [NSMenu new];
        [self.statusMenu setAutoenablesItems:NO];
        [self.statusMenu addItem:self.createNewIssueMenuItem];
        [self.statusMenu addItem:self.startTrackingMenuItem];
        [self.statusMenu addItem:self.stopTrackingMenuItem];
        
        NSMenuItem *preferencesMenuItem = [[NSMenuItem alloc] initWithTitle:@"Preferences"
                                                                     action:@selector(preferences)
                                                              keyEquivalent: @""];
        [preferencesMenuItem setTarget:self];
        [self.statusMenu addItem:preferencesMenuItem];
        
        NSMenuItem *applicationTrackerMenuItem = [[NSMenuItem alloc] initWithTitle:@"Applications"
                                                                            action:@selector(showAppTracker)
                                                                     keyEquivalent:@""];
        [applicationTrackerMenuItem setTarget:[NSApplication sharedApplication].delegate];
        [self.statusMenu addItem:applicationTrackerMenuItem];
        
        [self.statusItem setMenu:self.statusMenu];
        [self.statusItem setTitle:@"Aaarbeeeiiiit"];
        [self.statusItem setHighlightMode:YES];
        [self registerHotkey];
        
        self.user = [SMCurrentUser findOrCreate];
        [self.user addObserver:self forKeyPath:@"currentTimeEntry"
                       options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                       context:nil];
        [self updateStatusText];
        LOG_INFO(@"statusItem %@", _statusItem);
        
        [self addShortcutObservers];
    }
    return self;
}

- (void)dealloc
{
    [self removeShortcutObservers];
}

-(BOOL)validateMenuItem:(NSMenuItem*)item{
    LOG_INFO(@"validateMenuItem");
    return YES;
}

-(void)preferences{
    LOG_INFO(@"show preferences");
    
    AppDelegate *app = [NSApplication sharedApplication].delegate;
    [app showPreferences];
}

- (void)createNewIssue
{
    SMNewIssueWindowController *issueWindowController = [[SMNewIssueWindowController alloc] initWithWindowNibName:NSStringFromClass([SMNewIssueWindowController class])];
    [issueWindowController showWindow:self.createNewIssueMenuItem];
    self.createNewIssueWindowController = issueWindowController;
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

- (NSSet *)shortcutKeys
{
    if (!_shortcutKeys) {
        _shortcutKeys = [NSSet setWithArray:@[@"SMStartTrackingShortcut",
                                              @"SMStopTrackingShortcut",
                                              @"SMNewIssueShortcut"]];
    }
    return _shortcutKeys;
}

- (void)addShortcutObservers
{
    [self.shortcutKeys enumerateObjectsUsingBlock:^(NSString *key, BOOL *stop) {
        NSString *keyPath = [@"values." stringByAppendingString:key];
        [[NSUserDefaultsController sharedUserDefaultsController] addObserver:self
                                                                  forKeyPath:keyPath
                                                                     options:(NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew)
                                                                     context:nil];
    }];
}

- (void)removeShortcutObservers
{
    [self.shortcutKeys enumerateObjectsUsingBlock:^(NSString *key, BOOL *stop) {
        NSString *keyPath = [@"values." stringByAppendingString:key];
        [[NSUserDefaultsController sharedUserDefaultsController] removeObserver:self forKeyPath:keyPath];
    }];
}

- (void)configureMenuItemsWithShortcuts
{
    [self.shortcutKeys enumerateObjectsUsingBlock:^(NSString *key, BOOL *stop) {
        NSString *keyPath = [@"values." stringByAppendingString:key];
        NSData *data = [[NSUserDefaultsController sharedUserDefaultsController] valueForKeyPath:keyPath];
        MASShortcut *shortcut = [MASShortcut shortcutWithData:data];
        NSString *keyEquiv = shortcut.keyCodeStringForKeyEquivalent ?: @"";
        NSUInteger *modifierMask = shortcut.modifierFlags;
        if ([keyPath isEqualToString:@"values.SMStartTrackingShortcut"]) {
            self.startTrackingMenuItem.keyEquivalent = keyEquiv;
            self.startTrackingMenuItem.keyEquivalentModifierMask = modifierMask;
        }
        if ([keyPath isEqualToString:@"values.SMStopTrackingShortcut"]) {
            self.stopTrackingMenuItem.keyEquivalent = keyEquiv;
            self.stopTrackingMenuItem.keyEquivalentModifierMask = modifierMask;
        }
        if ([keyPath isEqualToString:@"values.SMNewIssueShortcut"]) {
            self.createNewIssueMenuItem.keyEquivalent = keyEquiv;
            self.createNewIssueMenuItem.keyEquivalentModifierMask = modifierMask;
        }
    }];
}

- (void)registerHotkey {
    [MASShortcut registerGlobalShortcutWithUserDefaultsKey:@"SMStartTrackingShortcut" handler:^{
        [self startTracking];
    }];
    [MASShortcut registerGlobalShortcutWithUserDefaultsKey:@"SMStopTrackingShortcut" handler:^{
        [self stopTracking];
    }];
    [MASShortcut registerGlobalShortcutWithUserDefaultsKey:@"SMNewIssueShortcut" handler:^{
        [self createNewIssue];
    }];
}

-(void)setEntry:(SMTimeEntry *)entry{
    if (entry != _entry){
        [_entry removeObserver:self forKeyPath:@"formattedTime"];
        [entry addObserver:self forKeyPath:@"formattedTime"
                   options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                   context:nil];
        _entry = entry;
    }
}

-(void)updateStatusText{
    [self setEntry:self.user.currentTimeEntry];
    if(self.entry){
        [_statusItem setTitle:[NSString stringWithFormat:@"%@", self.entry.formattedTime]];
    } else {
        [_statusItem setTitle:@"Idle"];
        
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary *)change
                      context:(void *)context{
    if (object == [NSUserDefaultsController sharedUserDefaultsController]) {
        [self configureMenuItemsWithShortcuts];
    } else if (object == self.entry) {
        [self updateStatusText];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
