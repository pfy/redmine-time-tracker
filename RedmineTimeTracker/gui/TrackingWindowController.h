//
//  TrackingWindowController.h
//  RedmineTimeTracker
//
//  Created by pfy on 28.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TrackingWindowController : NSWindowController
@property (nonatomic,strong) IBOutlet NSArrayController *timeEntryArrayController;
@property (nonatomic,weak)  NSManagedObjectContext *context;

@end
