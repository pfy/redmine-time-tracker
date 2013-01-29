//
//  SMUpdateTimeEntriesCommand.h
//  RedmineTimeTracker
//
//  Created by pfy on 29.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import "SMNetworkUpdateCommand.h"

@interface SMUpdateTimeEntriesCommand : SMNetworkUpdateCommand
@property (nonatomic,strong) NSMutableArray *allTimeEntries;
@property (nonatomic,weak) SMNetworkUpdate *center;
@end
