//
//  SMManagedObject+networkExtension.h
//  RedmineTimeTracker
//
//  Created by pfy on 24.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import "SMManagedObject.h"
#import "AFHTTPClient.h"
#import "SMUpdateOperation.h"
#import "SMHttpClient.h"

typedef void (^VoidBlock)(NSManagedObject *newSelf);

@interface SMManagedObject (NetworkExtension)
-(void)createRequest:(SMHttpClient*)client;
-(int)language;
-(void)updateWithDict:(NSDictionary*)dict;
-(void)update:(NSString*)entityName withArray:(NSArray*)objects andId:(NSString*)ID parent:(NSManagedObject*)parent withChildKey:(NSString*)childKey andParentKey:(NSString*)parentKey cleanup:(BOOL)cleanup;

-(void)scheduleUpdateOperationWithBlock:(ContextBlock) block;
-(void)scheduleUpdateOperationOnMainWithBlock:(VoidBlock) block;

+(SMManagedObject*)managedObjectWithId:(NSManagedObjectID*)objectId;

@property (nonatomic,retain) AFHTTPRequestOperation *requestOperation;
@property (nonatomic,retain) NSMutableArray *updateOperations;
@end
