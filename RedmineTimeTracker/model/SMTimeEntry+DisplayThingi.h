//
//  SMTimeEntry+DisplayThingi.h
//  RedmineTimeTracker
//
//  Created by David Gunzinger Smooh GmbH on 28.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import "SMTimeEntry.h"

@interface SMTimeEntry (DisplayThingi)

@property (nonatomic, strong, readonly) NSString *formattedTime;

@end
