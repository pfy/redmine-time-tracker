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
    if(! [self.currentAppName isEqualToString:appName]){
        self.currentAppName = appName;
        LOG_INFO(@"appName %@, app dict %@",appName,activeApp);
    }
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
