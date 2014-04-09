//
//  SMUpdateOperation.m
//  entertrainment
//
//  Created by David Gunzinger Smooh GmbH on 22.10.12.
//  Copyright (c) 2012 David Gunzinger Smooh GmbH. All rights reserved.
//

#import "SMUpdateOperation.h"
#import "AppDelegate.h"
#import "SMCoreDataSingleton.h"

@implementation SMUpdateOperation
-(void)main{
        NSManagedObjectContext *context = SMTemporaryBGContext();
        [context performBlockAndWait:^{
            self.block(context);
        }];
    SMSaveContext(context);
    
}
-(void)dealloc{
    self.block = nil;
}
+(SMUpdateOperation*)operationWithBlock:(ContextBlock) block{
    SMUpdateOperation *operation = [SMUpdateOperation new];
    operation.block = block;
    return operation ;
}


@end
