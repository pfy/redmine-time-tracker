//
//  ProjectValueTransformer.m
//  RedmineTimeTracker
//
//  Created by pfy on 31.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import "ProjectValueTransformer.h"
#import "NSAttributedString+hyperlink.h"
#import "SMCurrentUser+trackingExtension.h"

@implementation ProjectValueTransformer
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
    LOG_INFO(@"transform %@",value);
    NSAttributedString *str = [NSAttributedString hyperlinkFromString:[NSString stringWithFormat:@"%@",value] withURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/projects/%@",user.serverUrl,value]]];
    return str;
    
}

@end
