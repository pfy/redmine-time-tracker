//
//  SMCurrentUser.h
//  RedmineTimeTracker
//
//  Created by David Gunzinger Smooh GmbH on 29.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SMManagedObject.h"

@class SMRedmineUser, SMTimeEntry;

@interface SMCurrentUser : SMManagedObject

@property (nonatomic, retain) NSString * authToken;
@property (nonatomic, retain) NSString * serverUrl;
@property (nonatomic, retain) SMTimeEntry *currentTimeEntry;
@property (nonatomic, retain) SMRedmineUser *n_user;

@end
