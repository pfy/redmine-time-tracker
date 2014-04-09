//
//  NSString+Date.m
//  RedmineTimeTracker
//
//  Created by pfy on 09.04.14.
//  Copyright (c) 2014 smooh GmbH. All rights reserved.
//

#import "NSString+Date.h"

@implementation NSString (Date)
-(NSDate*)toDate {
    NSDate *newDate;
    if(self.length == 20){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
        newDate = [dateFormatter dateFromString:self];
    } else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        newDate = [dateFormatter dateFromString:self];
    }
    if(newDate == nil){
        LOG_ERR(@"did fail to parse date %@",self);
    }
    return newDate;
}

@end
