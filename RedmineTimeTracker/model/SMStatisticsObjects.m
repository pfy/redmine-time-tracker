//
//  SMStatisticsObjects.m
//  RedmineTimeTracker
//
//  Created by Florian Friedrich on 19.05.14.
//  Copyright (c) 2014 Smooh AG. All rights reserved.
//

#import "SMStatisticsObjects.h"

@interface SMStatisticsObject ()
@property (nonatomic, weak) SMStatisticsGroup *parent;
@end

@implementation SMStatisticsObject{
    @protected
    NSNumber *_hours;
}
+ (instancetype)objectWithTitle:(NSString *)title
{
    SMStatisticsObject *obj = [[self alloc] init];
    obj.title = title;
    return obj;
}
@end

@implementation SMStatisticsGroup

+ (instancetype)groupWithTitle:(NSString *)title subentries:(NSSet *)subentries
{
    SMStatisticsGroup *group = [self objectWithTitle:title];
    group.subentries = subentries;
    return group;
}

- (NSNumber *)hours
{
    NSSet *hours = [self.subentries valueForKeyPath:@"hours"];
    __block double sum = 0.0;
    [hours enumerateObjectsUsingBlock:^(NSNumber *nr, BOOL *stop) {
        sum += nr.doubleValue;
    }];
    return @(sum);
}

- (void)setHours:(NSNumber *)hours
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You can't set hours on a statistics group!"];
}

- (void)setSubentries:(NSSet *)subentries
{
    if (![_subentries isEqual:subentries]) {
        if (_subentries) {
            [_subentries enumerateObjectsUsingBlock:^(SMStatisticsObject *obj, BOOL *stop) {
                if (![subentries containsObject:obj]) {
                    obj.parent = nil;
                } else if (obj.parent != self) {
                    obj.parent = self;
                }
            }];
        } else {
            [subentries enumerateObjectsUsingBlock:^(SMStatisticsObject *obj, BOOL *stop) {
                obj.parent = self;
            }];
        }
        _subentries = subentries;
    }
}

@end

@interface SMStatisticsTimeEntry ()
@property (nonatomic, strong) SMTimeEntry *timeEntry;
@end

@implementation SMStatisticsTimeEntry

+ (instancetype)entryWithTimeEntry:(SMTimeEntry *)entry
{
    SMStatisticsTimeEntry *e = [self objectWithTitle:entry.n_comments];
    e.hours = entry.n_hours;
    e.timeEntry = entry;
    return e;
}

- (void)setHours:(NSNumber *)hours
{
    if (![_hours isEqualToNumber:hours]) {
        _hours = hours;
        self.timeEntry.n_hours = hours;
        self.timeEntry.changed = @YES;
    }
}

@end
