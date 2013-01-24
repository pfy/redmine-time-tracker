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
-(void)update:(NSString*)entityName withArray:(NSArray*)objects;

-(void)scheduleUpdateOperationWithBlock:(ContextBlock) block;
-(void)scheduleUpdateOperationOnMainWithBlock:(VoidBlock) block;


@property (nonatomic,retain) AFHTTPRequestOperation *requestOperation;
@property (nonatomic,retain) NSMutableArray *updateOperations;
@end