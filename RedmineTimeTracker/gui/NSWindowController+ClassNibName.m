//
//  NSWindowController+ClassNibName.m
//  RedmineTimeTracker
//
//  Created by Florian Friedrich on 17.5.14.
//  Copyright (c) 2014 Smooh AG. All rights reserved.
//

#import "NSWindowController+ClassNibName.h"

@implementation NSWindowController (ClassNibName)

+ (instancetype)windowControllerWithNib
{
    return [[self alloc] initWithWindowNibName:NSStringFromClass(self)];
}

@end
