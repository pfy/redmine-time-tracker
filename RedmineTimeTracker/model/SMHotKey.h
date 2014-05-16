//
//  SMHotKey.h
//  RedmineTimeTracker
//
//  Created by Florian Friedrich on 16.05.14.
//  Copyright (c) 2014 Smooh AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SMHotKey : NSManagedObject

@property (nonatomic, retain) NSNumber * keyIdentifier;
@property (nonatomic, retain) NSNumber * modifierFlags;
@property (nonatomic, retain) NSNumber * type;

@end
