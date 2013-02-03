//
//  ApplicationTrackerWindowController.h
//  RedmineTimeTracker
//
//  Created by pfy on 03.02.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ApplicationTrackerWindowController : NSWindowController
@property (nonatomic,weak) IBOutlet NSProgressIndicator *progressIndicator;

@property (nonatomic,weak) IBOutlet NSArrayController *applicationEntryArrayController;
@property (nonatomic,strong)  NSDate *currentDate;
@property (nonatomic,strong)  NSString *currentDateString;
@property (nonatomic,strong) NSDateFormatter *formatter;

-(IBAction)nextDay:(id)sender;
-(IBAction)prevDay:(id)sender;
-(IBAction)today:(id)sender;
@end
