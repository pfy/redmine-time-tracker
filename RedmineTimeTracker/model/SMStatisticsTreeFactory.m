//
//  SMStatisticsTreeFactory.m
//  RedmineTimeTracker
//
//  Created by Florian Friedrich on 19.05.14.
//  Copyright (c) 2014 Smooh AG. All rights reserved.
//

#import "SMStatisticsTreeFactory.h"
#import "SMStatisticsObjects.h"
#import "SMTimeEntry.h"
#import "SMIssue.h"
#import "SMProjects.h"

@interface SMStatisticsTreeFactory ()
@property (nonatomic, strong) NSMutableDictionary *rootObjects;
@property (nonatomic, strong) NSMutableDictionary *objects;
@end

@implementation SMStatisticsTreeFactory

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.rootObjects = [NSMutableDictionary dictionary];
        self.objects = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)logTree
{
    NSArray *roots = self.rootObjects.allValues;
    [roots enumerateObjectsUsingBlock:^(SMStatisticsObject *obj, NSUInteger idx, BOOL *stop) {
        LOG_INFO(@"Object: %@ with children", obj.title);
    }];
}

- (NSArray *)projectsForTimeEntries:(NSArray *)timeEntries
{
    [timeEntries enumerateObjectsUsingBlock:^(SMTimeEntry *timeEntry, NSUInteger idx, BOOL *stop) {
        self.objects[timeEntry.objectID] = [self objectForSMManagedObject:timeEntry];
    }];
//    [self logTree];
    return self.rootObjects.allValues;
}

- (SMStatisticsObject *)objectForSMManagedObject:(SMManagedObject *)object
{
    if (self.objects[object.objectID]) return self.objects[object.objectID];
    
    if ([object.entity.name isEqualToString:NSStringFromClass([SMTimeEntry class])]) { // If it's a time entry
        SMTimeEntry *timeEntry = (SMTimeEntry *)object;
        SMStatisticsTimeEntry *statsTimeEntry =
        [SMStatisticsTimeEntry objectWithManagedObject:object
                                                 title:timeEntry.n_comments
                                                 hours:timeEntry.n_hours.doubleValue];
        SMManagedObject *parentObject = (timeEntry.n_issue) ?: timeEntry.n_project;
        [[self objectForSMManagedObject:parentObject] addSubentry:statsTimeEntry];
        return statsTimeEntry;
        
    } else if ([object.entity.name isEqualToString:NSStringFromClass([SMIssue class])]) { // If it's an issue
        SMIssue *issue = (SMIssue *)object;
        SMStatisticsObject *statsIssue = [SMStatisticsObject objectWithManagedObject:object title:issue.n_subject];
        self.objects[object.objectID] = statsIssue;
        SMManagedObject *parentObject = (issue.n_parent) ?: issue.n_project;
        [[self objectForSMManagedObject:parentObject] addSubentry:statsIssue];
        return statsIssue;
        
    } else if ([object.entity.name isEqualToString:NSStringFromClass([SMProjects class])]) { // If it's a project
        
        if (self.rootObjects[object.objectID]) return self.rootObjects[object.objectID];
        SMProjects *project = (SMProjects *)object;
        SMStatisticsObject *rootObject = [SMStatisticsObject objectWithManagedObject:object title:project.n_name];
        self.rootObjects[object.objectID] = rootObject;
        return rootObject;
    }
    // Should never happen...
    return nil;
}


@end
