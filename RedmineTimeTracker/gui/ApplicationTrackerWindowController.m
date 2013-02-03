//
//  ApplicationTrackerWindowController.m
//  RedmineTimeTracker
//
//  Created by pfy on 03.02.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import "ApplicationTrackerWindowController.h"

@interface ApplicationTrackerWindowController ()

@end

@implementation ApplicationTrackerWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    NSManagedObjectContext *context = [(AppDelegate*)[NSApplication sharedApplication].delegate managedObjectContext];
    [self.applicationEntryArrayController setManagedObjectContext:context];
    [self.applicationEntryArrayController setEntityName:@"SMApplicationTracker"];
    
    
    self.formatter = [NSDateFormatter new];
    [self.formatter setTimeStyle:NSDateFormatterNoStyle];
    [self.formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [self addObserver:self forKeyPath:@"currentDate" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    self.currentDate = [NSDate date];

    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

-(IBAction)today:(id)sender{
    self.currentDate = [NSDate date];
}
-(IBAction)nextDay:(id)sender{
    self.currentDate = [self.currentDate dateByAddingTimeInterval:24*3600];
}
-(IBAction)prevDay:(id)sender{
    self.currentDate = [self.currentDate dateByAddingTimeInterval:-24*3600];
}
-(void)updateFetcher{
    self.currentDateString = [self.formatter stringFromDate:self.currentDate];
    NSCalendar *calendar = [NSCalendar currentCalendar]; // gets default calendar
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit) fromDate:self.currentDate]; // gets the year, month, and day for today's date
    NSDate *firstDate = [calendar dateFromComponents:components]; // makes a new NSDate keeping only the year, month, and day
    NSDate *secondDate = [firstDate dateByAddingTimeInterval:24*3600];
    
    NSPredicate *firstPredicate = [NSPredicate predicateWithFormat:@"spent_on >= %@", firstDate];
    NSPredicate *secondPredicate = [NSPredicate predicateWithFormat:@"spent_on < %@", secondDate];
    
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:firstPredicate,secondPredicate, nil]];
    
    
    self.applicationEntryArrayController.fetchPredicate = predicate;
    __weak NSError *error;
    [self.applicationEntryArrayController fetchWithRequest:nil merge:YES error:&error];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if([keyPath isEqualToString:@"currentDate"]){
        [self updateFetcher];
    }
}

@end
