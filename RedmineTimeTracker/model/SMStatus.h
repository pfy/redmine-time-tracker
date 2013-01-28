//
//  SMStatus.h
//  RedmineTimeTracker
//
//  Created by pfy on 28.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SMManagedObject.h"

@class SMIssue;

@interface SMStatus : SMManagedObject

@property (nonatomic, retain) NSNumber * n_is_closed;
@property (nonatomic, retain) NSNumber * n_is_default;
@property (nonatomic, retain) NSString * n_name;
@property (nonatomic, retain) SMIssue *issues;

@end
