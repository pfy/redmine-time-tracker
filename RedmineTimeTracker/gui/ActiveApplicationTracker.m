//
//  ActiveApplicationTracker.m
//  RedmineTimeTracker
//
//  Created by David Gunzinger Smooh GmbH on 24.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import "ActiveApplicationTracker.h"

@implementation ActiveApplicationTracker
-(void)update{
    NSDictionary *activeApp = [NSWorkspace sharedWorkspace].activeApplication;
    NSString *appName = [activeApp objectForKey:@"NSApplicationName"];

    if(!self.currentTracker|| ! [self.currentTracker.app_name isEqualToString:appName]){
         NSManagedObjectContext *context =  [(AppDelegate*)[NSApplication sharedApplication].delegate managedObjectContext];
        self.currentTracker = [NSEntityDescription insertNewObjectForEntityForName:@"SMApplicationTracker" inManagedObjectContext:context];
        self.currentTracker.app_name = appName;
        self.currentTracker.start_time = [NSDate date];
        LOG_INFO(@"start tracking on %@",appName);
    }
    
    self.currentTracker.end_time = [NSDate date];
    
}


-(id)init{
    self = [super init];
    if(self){
        self.timer =     [NSTimer scheduledTimerWithTimeInterval:1.0
                                                          target:self
                                                        selector:@selector(update)
                                                        userInfo:nil
                                                         repeats:YES];

    }
    return self;
}


@end
