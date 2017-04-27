//
//  TestAsynchronousOperation.h
//  ConcurrentDemo
//
//  Created by JiangWang on 27/04/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 To define an asynchronous operation, you have to rewrite the finite state machine 
 provided by NSOperation and maintain their KVO compliance.
 
 - finished;
 - executing;
 */

@interface TestAsynchronousOperation : NSOperation
@property (nonatomic, readonly, getter=isExecuting) BOOL executing;
@property (nonatomic, readonly, getter=isFinished) BOOL finished;

/**
 @note SubClass必须调用
 */
- (void)start NS_REQUIRES_SUPER;

/**
 完成该operation
 @note 手动标记该operation结束
 */
- (void)finish;
@end
