//
//  SMCurrentUser.h
//  RedmineTimeTracker
//
//  Created by pfy on 28.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SMRedmineUser, SMTimeEntry;

@interface SMCurrentUser : NSManagedObject

@property (nonatomic, retain) NSString * serverUrl;
@property (nonatomic, retain) NSString * authToken;
@property (nonatomic, retain) SMTimeEntry *currentTimeEntry;
@property (nonatomic, retain) SMRedmineUser *myUserObject;

@end
