//
//  SMStatisticsTreeFactory.h
//  RedmineTimeTracker
//
//  Created by Florian Friedrich on 19.05.14.
//  Copyright (c) 2014 Smooh AG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMStatisticsTreeFactory : NSObject

/**
 *  Creates an array of SMStatisticsObjects representing SMProjects from an array of SMTimeEntries.
 *  @param timeEntries An array of SMTimeEntry instances from which the tree should be built.
 *  @return An array of SMStatisticObjects which represent a project containing subentries down to the SMStatisticTimeEntries.
 */
- (NSArray *)projectsForTimeEntries:(NSArray *)timeEntries;

@end
