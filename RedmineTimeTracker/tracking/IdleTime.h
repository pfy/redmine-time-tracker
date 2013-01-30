//
//  IdleTime.h
//  RedmineTimeTracker
//
//  Created by pfy on 30.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <IOKit/IOKitLib.h>

@interface IdleTime: NSObject
{
@protected
    
    mach_port_t   ioPort;
    io_iterator_t ioIterator;
    io_object_t   ioObject;
    
@private
    
    id r1;
    id r2;
}

@property( readonly ) uint64_t timeIdle;
@property( readonly ) NSUInteger secondsIdle;

@end
