//
//  SMManagedObject+networkExtension.h
//  RedmineTimeTracker
//
//  Created by David Gunzinger Smooh GmbH on 24.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import "SMManagedObject.h"
#import "AFHTTPClient.h"
#import "SMUpdateOperation.h"
#import "SMHttpClient.h"

typedef void (^VoidBlock)(SMManagedObject *newSelf);
typedef void (^noneBlock)();

@interface SMManagedObject (NetworkExtension)
-(void)createRequest:(SMHttpClient*)client;
-(void)updateWithDict:(NSDictionary*)dict andSet:(NSMutableSet*)set;
+(void)update:(NSString*)entityName withArray:(NSArray*)objects delete:(bool)delete;
+(void)scheduleOperationOnMainWithBlock:(noneBlock)block;
+(void)scheduleUpdateOperationWithBlock:(ContextBlock) block;
-(void)scheduleOperationWithBlock:(VoidBlock)block;
@end
