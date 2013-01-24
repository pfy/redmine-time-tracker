//
//  SMUpdateOperation.h
//  entertrainment
//
//  Created by pfy on 22.10.12.
//  Copyright (c) 2012 pfy. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^ContextBlock)( NSManagedObjectContext *context);

@interface SMUpdateOperation : NSOperation
@property (nonatomic,copy) ContextBlock block;

+(SMUpdateOperation*)operationWithBlock:(ContextBlock) block;
@end
