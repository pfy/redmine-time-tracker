//
//  NSApplication+Information.m
//  RedmineTimeTracker
//
//  Created by Florian Friedrich on 16.05.14.
//  Copyright (c) 2014 Smooh AG. All rights reserved.
//

#import "NSApplication+Information.h"

@implementation NSApplication (Information)

- (NSString *)identifier
{
    return [[NSBundle mainBundle] infoDictionary][@"CFBundleIdentifier"];
}

- (NSString *)name
{
    return [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
}

- (NSString *)version
{
    return [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
}

- (NSString *)build
{
    return [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
}

@end
