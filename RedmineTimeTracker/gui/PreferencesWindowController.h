//
//  PreferencesWindowController.h
//  RedmineTimeTracker
//
//  Created by pfy on 29.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SMCurrentUser+trackingExtension.h"

@interface PreferencesWindowController : NSWindowController
@property (nonatomic,weak)  IBOutlet NSTextField *hostnameTextField;
@property (nonatomic,weak)  IBOutlet NSTextField *tokenTextField;
@property (nonatomic,strong)  SMCurrentUser *user;


-(IBAction)donePressed:(id)sender;


@end
