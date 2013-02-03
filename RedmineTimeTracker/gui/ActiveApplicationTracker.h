//
//  ActiveApplicationTracker.h
//  RedmineTimeTracker
//
//  Created by David Gunzinger Smooh GmbH on 24.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMApplicationTracker.h"
@interface ActiveApplicationTracker : NSObject
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) SMApplicationTracker *currentTracker;
@property (nonatomic,strong) NSDate *lastUpdate;

@end
