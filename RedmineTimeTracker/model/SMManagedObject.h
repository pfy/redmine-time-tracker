//
//  SMManagedObject.h
//  RedmineTimeTracker
//
//  Created by pfy on 29.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SMManagedObject : NSManagedObject

@property (nonatomic, retain) NSDate * n_created_on;
@property (nonatomic, retain) NSNumber * n_id;
@property (nonatomic, retain) NSDate * n_updated_on;
@property (nonatomic, retain) NSNumber * changed;

@end
