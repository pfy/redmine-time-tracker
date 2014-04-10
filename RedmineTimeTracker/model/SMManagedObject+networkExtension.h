//
//  SMManagedObject+networkExtension.h
//  RedmineTimeTracker
//
//  Created by David Gunzinger Smooh GmbH on 24.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import "SMManagedObject.h"
#import "SMUpdateOperation.h"
#import "AFNetworking.h"
typedef void (^VoidBlock)(SMManagedObject *newSelf);
typedef void (^noneBlock)();

@interface SMManagedObject (NetworkExtension)
-(void)createRequest:(AFHTTPRequestOperationManager*)client;
-(void)updateWithDict:(NSDictionary*)dict;
+(void)update:(NSString*)entityName withArray:(NSArray*)objects delete:(bool)delete completion:(noneBlock)completion;
-(void)scheduleOperationWithBlock:(VoidBlock)block;
+(void)scheduleUpdateOperationWithBlock:(ContextBlock) block completion:(noneBlock)completion;
@end
