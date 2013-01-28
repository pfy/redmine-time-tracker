//
//  SMActivity.h
//  RedmineTimeTracker
//
//  Created by pfy on 28.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SMManagedObject.h"

@class SMTimeEntry;

@interface SMActivity : SMManagedObject

@property (nonatomic, retain) NSString * n_name;
@property (nonatomic, retain) NSSet *time_entries;
@end

@interface SMActivity (CoreDataGeneratedAccessors)

- (void)addTime_entriesObject:(SMTimeEntry *)value;
- (void)removeTime_entriesObject:(SMTimeEntry *)value;
- (void)addTime_entries:(NSSet *)values;
- (void)removeTime_entries:(NSSet *)values;

@end
