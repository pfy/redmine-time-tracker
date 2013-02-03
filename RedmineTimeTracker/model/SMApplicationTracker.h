//
//  SMApplicationTracker.h
//  RedmineTimeTracker
//
//  Created by pfy on 03.02.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SMManagedObject.h"


@interface SMApplicationTracker : SMManagedObject

@property (nonatomic, retain) NSString * app_name;
@property (nonatomic, retain) NSDate * end_time;
@property (nonatomic, retain) NSDate * start_time;

@end
