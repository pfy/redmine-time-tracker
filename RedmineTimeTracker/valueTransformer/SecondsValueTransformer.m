//
//  SecondsValueTransformer.m
//  RedmineTimeTracker
//
//  Created by pfy on 03.02.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import "SecondsValueTransformer.h"

@implementation SecondsValueTransformer
+ (Class)transformedValueClass {
    return [NSString class];
}

+ (BOOL)allowsReverseTransformation {
    return NO;
}

- (id)transformedValue:(id)value {
    if(value == nil)
        return nil;
    long seconds = [value longValue];
    long minutes = seconds / 60;
    long hours = minutes / 60;
    
    seconds = seconds % 60;
    minutes = minutes % 60;

    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld",hours,minutes,seconds];
}
@end
