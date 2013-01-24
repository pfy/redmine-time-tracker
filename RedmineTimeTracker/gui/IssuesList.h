//
//  IssuesList.h
//  RedmineTimeTracker
//
//  Created by pfy on 24.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IssuesList : NSObject<NSOutlineViewDataSource,NSOutlineViewDelegate>
@property (nonatomic,strong) NSArrayController *issuesArrayController;

@end
