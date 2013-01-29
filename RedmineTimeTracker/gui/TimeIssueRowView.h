//
//  TimeIssueRowView.h
//  RedmineTimeTracker
//
//  Created by pfy on 29.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TimeIssueRowView : NSTableCellView
@property (nonatomic,weak) IBOutlet NSButton *pauseButton;

-(IBAction)pressPause:(id)sender;
@end
