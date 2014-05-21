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

@implementation SMStatisticsObject {
    @protected
    NSNumber *_hours;
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
//        self.subentriesController.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"hours" ascending:NO]];
    }
    return self;
}

- (BOOL)isEditable { return NO; }

- (NSUInteger)count
{
    return [self.subentriesController.arrangedObjects count];
}

- (NSNumber *)hours
{
    NSArray *hours = [self.subentriesController.arrangedObjects valueForKeyPath:@"hours"];
    __block double sum = 0.0;
    [hours enumerateObjectsUsingBlock:^(NSNumber *nr, NSUInteger idx, BOOL *stop) {
        sum += nr.doubleValue;
    }];
    return @(sum);
}

- (void)setHours:(NSNumber *)hours
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You can't set hours on a statistics group!"];
}

- (void)willChangeHours
{
    [self willChangeValueForKey:@"hours"];
    [self.parent willChangeHours];
}

- (void)didChangeHours
{
    [self didChangeValueForKey:@"hours"];
    [self.parent didChangeHours];
    [self.subentriesController rearrangeObjects];
}

- (void)setParent:(SMStatisticsObject *)parent
{
    if (![_parent isEqual:parent]) {
        [_parent removeSubentry:self];
        _parent = parent;
        [_parent addSubentry:self];
    }
}

- (void)addSubentry:(SMStatisticsObject *)subentry
{
    if (![self.subentriesController.content containsObject:subentry]) {
        [self.subentriesController addObject:subentry];
    }
    if (subentry.parent != self) {
        subentry.parent = self;
    }
}

- (void)removeSubentry:(SMStatisticsObject *)subentry
{
    if ([self.subentriesController.content containsObject:subentry]) {
        [self.subentriesController removeObject:subentry];
    }
    if (subentry.parent == self) {
        subentry.parent = nil;
    }
}

@end

@implementation SMStatisticsTimeEntry

+ (instancetype)objectWithManagedObject:(SMManagedObject *)object title:(NSString *)title hours:(double)hours
{
    SMStatisticsTimeEntry *entry = [self objectWithManagedObject:object title:title];
    entry->_hours = @(hours);
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

- (NSNumber *)hours
{
    return _hours;
}

- (void)setHours:(NSNumber *)hours
{
    if (![self.statisticsManagedObject isKindOfClass:[SMTimeEntry class]]) [super setHours:hours];
    SMTimeEntry *timeEntry = (SMTimeEntry *)self.statisticsManagedObject;
    if (!hours) hours = @(0.0);
    if (![_hours isEqualToNumber:hours]) {
        [self willChangeHours];
        _hours = hours;
        timeEntry.n_hours = hours;
        timeEntry.changed = @YES;
        SAVE_APP_CONTEXT;
        [self didChangeHours];
    }
}

@end
