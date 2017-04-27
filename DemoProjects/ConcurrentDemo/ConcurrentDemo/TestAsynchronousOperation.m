//
//  TestAsynchronousOperation.m
//  ConcurrentDemo
//
//  Created by JiangWang on 27/04/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "TestAsynchronousOperation.h"
@interface TestAsynchronousOperation()
@property (nonatomic, assign) NSUInteger operationSeqNum;
@end

static NSUInteger operationID;

@implementation TestAsynchronousOperation
@synthesize executing = _executing;
@synthesize finished = _finished;

#pragma mark - Public Methods
- (instancetype)init {
    self = [super init];
    if (self) {
        self.name = NSStringFromClass([TestAsynchronousOperation class]);
        self.operationSeqNum = operationID++;
        _finished = NO;
        _executing = NO;
    }
    return self;
}

- (void)start {
    //取消就结束
    if (self.isCancelled) {
        [self finish];
        return;
    }
    
    //已经开始或者结束就返回
    if (self.isFinished ||
        self.isExecuting) {
        return;
    }
    
    //更改状态
    self.executing = YES;
}

- (void)finish {
    self.executing = YES;
    self.finished = YES;
}

#pragma mark - Setters
- (void)setExecuting:(BOOL)executing {
    if (_executing != executing) {
        [self willChangeValueForKey:@"isExecuting"];
        _executing = executing;
        [self didChangeValueForKey:@"isExecuting"];
    }
}

- (void)setFinished:(BOOL)finished {
    if (_finished != finished) {
        [self willChangeValueForKey:@"isFinished"];
        _finished = finished;
        [self didChangeValueForKey:@"isFinished"];
    }
}

@end
