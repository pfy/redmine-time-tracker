//
//  SMStatisticsObjects.h
//  RedmineTimeTracker
//
//  Created by Florian Friedrich on 19.05.14.
//  Copyright (c) 2014 Smooh AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMManagedObject.h"

@interface SMStatisticsObject : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, readonly) NSNumber *hours;
@property (nonatomic, readonly) BOOL isEditable;

@property (nonatomic, strong) SMManagedObject *statisticsManagedObject;

@property (nonatomic, weak) SMStatisticsObject *parent;
@property (nonatomic, strong) NSArrayController *subentriesController;
@property (nonatomic, readonly) NSUInteger count;

+ (instancetype)objectWithManagedObject:(SMManagedObject *)object title:(NSString *)title;

- (void)addSubentry:(SMStatisticsObject *)subentry;
- (void)removeSubentry:(SMStatisticsObject *)subentry;
@end

@interface SMStatisticsTimeEntry : SMStatisticsObject
@property (nonatomic) NSNumber *hours;
+ (instancetype)objectWithManagedObject:(SMManagedObject *)object title:(NSString *)title hours:(double)hours;
@end
