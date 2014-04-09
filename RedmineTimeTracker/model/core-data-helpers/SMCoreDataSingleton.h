//
//  SMCoreDataSignleton.h
//  timeTracker
//
//  Created by pfy on 09.04.14.
//  Copyright (c) 2014 smooh GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
extern NSManagedObjectContext *SMMainContext();
extern NSManagedObjectContext *SMTemporaryBGContext();
extern void SMSaveContext(NSManagedObjectContext *context);


@interface SMCoreDataSingleton : NSObject

@end
