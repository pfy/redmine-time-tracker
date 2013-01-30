//
//  SMTimeEntry+DisplayThingi.m
//  RedmineTimeTracker
//
//  Created by David Gunzinger Smooh GmbH on 28.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import "SMTimeEntry+DisplayThingi.h"

@implementation SMTimeEntry (DisplayThingi)
-(NSString*)formattedTime{
    double hours = [self.n_hours doubleValue];
    int hours_int = hours;
    hours -= hours_int;
    int minutes_int = 60*hours;
    hours -= minutes_int / 60.0;
    
    int seconds_int = 3600 * hours;
    
    return [NSString stringWithFormat:@"%d:%02d:%02d",hours_int,minutes_int,seconds_int ];
}

-(void)setN_hours:(NSNumber *)n_hours{
    [self willChangeValueForKey:@"n_hours"];
    [self willChangeValueForKey:@"formattedTime"];
    [self setPrimitiveValue:n_hours forKey:@"n_hours"];
    [self didChangeValueForKey:@"n_hours"];
    [self didChangeValueForKey:@"formattedTime"];
}




@end
