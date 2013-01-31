//
//  TimeEntryValueTransformer.m
//  RedmineTimeTracker
//
//  Created by pfy on 31.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import "TimeEntryValueTransformer.h"
#import "NSAttributedString+hyperlink.h"

@implementation TimeEntryValueTransformer
+ (Class)transformedValueClass {
    return [NSAttributedString class];
}

+ (BOOL)allowsReverseTransformation {
    return NO;
}

- (id)transformedValue:(id)value {
    if(value == nil)
        return nil;
    SMCurrentUser *user = [SMCurrentUser findOrCreate];
    NSAttributedString *str = [NSAttributedString hyperlinkFromString:[NSString stringWithFormat:@"%@",value] withURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/time_entries/%@/edit",user.serverUrl,value]]];
    return str;
    
}
@end
