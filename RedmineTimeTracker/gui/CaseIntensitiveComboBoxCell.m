//
//  CaseIntensitiveComboBoxCell.m
//  RedmineTimeTracker
//
//  Created by pfy on 31.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import "CaseIntensitiveComboBoxCell.h"

@implementation CaseIntensitiveComboBoxCell
- (NSString *)completedString:(NSString *)string
{
    NSString *result = nil;
    
    if (string == nil)
        return result;
    
    for (NSString *item in self.objectValues) {
        NSString *truncatedString = [item substringToIndex:MIN(item.length, string.length)];
        if ([truncatedString caseInsensitiveCompare:string] == NSOrderedSame) {
            result = item;
            break;
        }
    }
    
    return result;
}
@end
