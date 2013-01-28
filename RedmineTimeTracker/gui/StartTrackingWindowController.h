//
//  StartTrackingWindowController.h
//  RedmineTimeTracker
//
//  Created by pfy on 28.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SMProjects.h"
#import "SMIssue.h"

@interface StartTrackingWindowController : NSWindowController
@property (nonatomic,strong) IBOutlet NSComboBox *projectField;
@property (nonatomic,strong) IBOutlet NSComboBox *issuesField;
@property (nonatomic,strong) IBOutlet NSTextView *commentTextView;
@property (nonatomic,weak)  NSManagedObjectContext *context;
@property (nonatomic,strong) IBOutlet NSArrayController *projectArrayController;
@property (nonatomic,strong) IBOutlet NSArrayController *issueArrayController;



@end
