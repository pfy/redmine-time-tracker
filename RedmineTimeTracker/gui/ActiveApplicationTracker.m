//
//  ActiveApplicationTracker.m
//  RedmineTimeTracker
//
//  Created by David Gunzinger Smooh GmbH on 24.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import "ActiveApplicationTracker.h"
#import "AppDelegate.h"

@implementation ActiveApplicationTracker

-(SMApplicationTracker*)trackerForName:(NSString*)name andDate:(NSDate*)now{
    NSCalendar *calendar = [NSCalendar currentCalendar]; // gets default calendar
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit) fromDate:now]; // gets the year, month, and day for today's date
    NSDate *firstDate = [calendar dateFromComponents:components]; // makes a new NSDate keeping only the year, month, and day
    NSDate *secondDate = [firstDate dateByAddingTimeInterval:24*3600];
    
    NSPredicate *firstPredicate = [NSPredicate predicateWithFormat:@"spent_on >= %@", firstDate];
    NSPredicate *secondPredicate = [NSPredicate predicateWithFormat:@"spent_on < %@", secondDate];
    NSPredicate *thirdPredicate = [NSPredicate predicateWithFormat:@"app_name = %@", name];

    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[firstPredicate,secondPredicate,thirdPredicate]];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SMApplicationTracker"];
    request.predicate = predicate;
    NSManagedObjectContext *context =  SMMainContext();
    NSArray *objects = [context executeFetchRequest:request error:nil];
    SMApplicationTracker *tracker;
    if(objects.count > 0){
        tracker = objects[0];
    } else {
        tracker = [NSEntityDescription insertNewObjectForEntityForName:@"SMApplicationTracker" inManagedObjectContext:context];
        tracker.app_name = name;
        tracker.spent_on = now;
    }
    
    return tracker;
}

-(void)update{
    NSDate *now = [NSDate date];
    NSTimeInterval delta = [now timeIntervalSinceDate:self.lastUpdate];
    self.lastUpdate = now;
    NSDictionary *activeApp = [NSWorkspace sharedWorkspace].activeApplication;
    NSString *appName = activeApp[@"NSApplicationName"];

    if(!self.currentTracker|| ! [self.currentTracker.app_name isEqualToString:appName]){
        self.currentTracker = [self trackerForName:appName andDate:now];
    }
    delta += [self.currentTracker.seconds doubleValue];
self.currentTracker.seconds = @(delta);
}


-(id)init{
    self = [super init];
    if(self){
        self.lastUpdate = [NSDate date];
        self.timer =     [NSTimer scheduledTimerWithTimeInterval:1.0
                                                          target:self
                                                        selector:@selector(update)
                                                        userInfo:nil
                                                         repeats:YES];

    }
    return self;
}


@end
