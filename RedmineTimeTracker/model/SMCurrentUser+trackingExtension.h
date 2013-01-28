//
//  SMCurrentUser+trackingExtension.h
//  RedmineTimeTracker
//
//  Created by pfy on 28.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import "SMCurrentUser.h"

@interface SMCurrentUser (trackingExtension)

+(SMCurrentUser*)findOrCreate;

@end
