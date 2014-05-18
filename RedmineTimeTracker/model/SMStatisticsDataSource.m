//
//  SMStatisticsDataSource.m
//  RedmineTimeTracker
//
//  Created by Florian Friedrich on 18.5.14.
//  Copyright (c) 2014 Smooh AG. All rights reserved.
//

#import "SMStatisticsDataSource.h"

@interface SMStatisticsDataSource ()

@end

@implementation SMStatisticsDataSource

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.managedObjectContext = SMMainContext();
    }
    return self;
}

#pragma mark - Properties
- (void)setStatistics:(SMStatistics *)statistics
{
    if (![_statistics isEqual:statistics]) {
        _statistics = statistics;
        [self.outlineView reloadData];
    }
}

- (void)setOutlineView:(NSOutlineView *)outlineView
{
    if ([_outlineView isEqual:outlineView]) {
        _outlineView = outlineView;
        _outlineView.dataSource = self;
    }
}

#pragma mark - NSOutlineView DataSource

@end
