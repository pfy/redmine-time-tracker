//
//  SMStatisticsDataSource.h
//  RedmineTimeTracker
//
//  Created by Florian Friedrich on 18.5.14.
//  Copyright (c) 2014 Smooh AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMStatistics.h"

@interface SMStatisticsDataSource : NSObject <NSOutlineViewDataSource>

@property (nonatomic, weak) IBOutlet NSOutlineView *outlineView;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSArrayController *timeEntriesArrayController;
@property (nonatomic, strong) SMStatistics *statistics;

@end
