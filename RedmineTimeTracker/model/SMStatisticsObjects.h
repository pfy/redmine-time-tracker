//
//  SMStatisticsObjects.h
//  RedmineTimeTracker
//
//  Created by Florian Friedrich on 19.05.14.
//  Copyright (c) 2014 Smooh AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMTimeEntry.h"

@class SMStatisticsGroup;
@interface SMStatisticsObject : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSNumber *hours;
@property (nonatomic, weak, readonly) SMStatisticsGroup *parent;
@end

@interface SMStatisticsGroup : SMStatisticsObject
@property (nonatomic, strong) NSSet *subentries;
+ (instancetype)groupWithTitle:(NSString *)title subentries:(NSSet *)subentries;
@end

@interface SMStatisticsProject : SMStatisticsGroup

@end

@interface SMStatisticsIssue : SMStatisticsGroup

@end

@interface SMStatisticsTimeEntry : SMStatisticsObject
+ (instancetype)entryWithTimeEntry:(SMTimeEntry *)entry;
@end
