//
//  ActiveApplicationTracker.h
//  RedmineTimeTracker
//
//  Created by pfy on 24.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActiveApplicationTracker : NSObject
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) NSString *currentAppName;

@end
