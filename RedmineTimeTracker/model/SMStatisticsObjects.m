//
//  SMStatisticsObjects.m
//  RedmineTimeTracker
//
//  Created by Florian Friedrich on 19.05.14.
//  Copyright (c) 2014 Smooh AG. All rights reserved.
//

#import "SMStatisticsObjects.h"
#import "SMManagedObject.h"
#import "SMTimeEntry.h"
#import "SMCurrentUser+trackingExtension.h"

@interface SMStatisticsObject ()

@end

@implementation SMStatisticsObject {
    @protected
    double _hours;
}

+ (instancetype)objectWithManagedObject:(SMManagedObject *)object title:(NSString *)title
{
    SMStatisticsObject *obj = [[self alloc] init];
    obj.statisticsManagedObject = object;
    obj.title = title;
    return obj;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.subentriesController = [[NSArrayController alloc] init];
        self.subentriesController.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"hours" ascending:YES]];
    }
    return self;
}

- (BOOL)isEditable { return NO; }

- (NSUInteger)count
{
    return [self.subentriesController.arrangedObjects count];
}

- (double)hours
{
    NSArray *hours = [self.subentriesController.arrangedObjects valueForKeyPath:@"hours"];
    __block double sum = 0.0;
    [hours enumerateObjectsUsingBlock:^(NSNumber *nr, NSUInteger idx, BOOL *stop) {
        sum += nr.doubleValue;
    }];
    return sum;
}

- (void)setHours:(double)hours
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You can't set hours on a statistics group!"];
}

- (void)setParent:(SMStatisticsObject *)parent
{
    if ([_parent isEqual:parent]) {
        [_parent removeSubentry:self];
        _parent = parent;
        [_parent addSubentry:self];
    }
}

- (void)addSubentry:(SMStatisticsObject *)subentry
{
    [self.subentriesController addObject:subentry];
    if (subentry.parent != self) {
        subentry.parent = self;
    }
}

- (void)removeSubentry:(SMStatisticsObject *)subentry
{
    [self.subentriesController removeObject:subentry];
    if (subentry.parent == self) {
        subentry.parent = nil;
    }
}

@end


@interface SMStatisticsTimeEntry ()
@end

@implementation SMStatisticsTimeEntry

+ (instancetype)objectWithManagedObject:(SMManagedObject *)object title:(NSString *)title hours:(double)hours
{
    SMStatisticsTimeEntry *entry = [self objectWithManagedObject:object title:title];
    entry->_hours = hours;
    return entry;
}

- (BOOL)isEditable
{
    if ([self.statisticsManagedObject isKindOfClass:[SMTimeEntry class]]) {
        SMTimeEntry *timeEntry = (SMTimeEntry *)self.statisticsManagedObject;
        return (timeEntry.n_user == [SMCurrentUser findOrCreate].n_user);
    }
    return NO;
}

- (double)hours
{
    return _hours;
}

- (void)setHours:(double)hours
{
    if (![self.statisticsManagedObject isKindOfClass:[SMTimeEntry class]]) [super setHours:hours];
    SMTimeEntry *timeEntry = (SMTimeEntry *)self.statisticsManagedObject;
    if (_hours != hours) {
        _hours = hours;
        timeEntry.n_hours = @(hours);
        timeEntry.changed = @YES;
    }
}

@end
