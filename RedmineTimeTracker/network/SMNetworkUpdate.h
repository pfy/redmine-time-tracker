//
//  SMNetworkUpdate.h
//  RedmineTimeTracker
//
//  Created by pfy on 24.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMCurrentUser+trackingExtension.h"
#import "SMHttpClient.h"

@interface SMNetworkUpdate : NSObject
@property (nonatomic,retain) NSTimer *timer;
@property (nonatomic,retain) NSArrayController *arrayController;
@property (nonatomic,weak) SMCurrentUser *user;
@property (nonatomic,assign) bool updating;
@property (nonatomic,strong) SMHttpClient *client;
@property (nonatomic,strong) NSMutableArray *allIssues;
@property (nonatomic,strong) NSMutableArray *allTimeEntries;

-(void)update;
@end
