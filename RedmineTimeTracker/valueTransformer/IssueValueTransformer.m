//
//  IssueValueTransformer.m
//  RedmineTimeTracker
//
//  Created by pfy on 31.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import "IssueValueTransformer.h"
#import "NSAttributedString+hyperlink.h"

@implementation IssueValueTransformer
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
    NSAttributedString *str = [NSAttributedString hyperlinkFromString:[NSString stringWithFormat:@"%@",value] withURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/issues/%@",user.serverUrl,value]]];
    return str;
    
}
@end
