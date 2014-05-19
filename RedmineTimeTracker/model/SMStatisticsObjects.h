//
//  SMStatisticsObjects.h
//  RedmineTimeTracker
//
//  Created by Florian Friedrich on 19.05.14.
//  Copyright (c) 2014 Smooh AG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMStatisticsObject : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSSet *subentries;
@end

@interface SMStatisticsProject : SMStatisticsObject

@end

@interface SMStatisticsIssue : SMStatisticsObject

@end

@interface SMStatisticsTimeEntry : NSObject
@property (nonatomic, strong) NSString *title;
@end