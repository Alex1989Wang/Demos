//
//  TestOperation.m
//  ConcurrentDemo
//
//  Created by JiangWang on 26/04/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "TestOperation.h"
@interface TestOperation()
@end

@implementation TestOperation
@synthesize ready = _ready;
@synthesize executing = _executing;
@synthesize finished = _finished;

#pragma mark - Private
- (void)start {
    if (!self.isExecuting) {
        self.ready = NO;
        self.executing = YES;
        self.finished = NO;
        NSLog(@"Operation started: %@ -- thread: %@",
              self.name, [NSThread currentThread]);
    }
}

- (void)finish {
    if (self.isExecuting) {
        self.ready = NO;
        self.executing = NO;
        self.finished = YES;
        NSLog(@"Operation finished: %@ -- thread: %@",
              self.name, [NSThread currentThread]);
    }
}

#pragma mark - Initialization
- (instancetype)init {
    self = [super init];
    if (self) {
        _ready = YES;
    }
    return self;
}


#pragma mark - Accessors 
- (void)setReady:(BOOL)ready {
    if (_ready != ready) {
        [self willChangeValueForKey:NSStringFromSelector(@selector(isReady))];
        _ready = ready;
        [self didChangeValueForKey:NSStringFromSelector(@selector(isReady))];
    }
}

- (void)setFinished:(BOOL)finished {
    if (_finished != finished) {
        [self willChangeValueForKey:NSStringFromSelector(@selector(isFinished))];
        _finished = finished;
        [self didChangeValueForKey:NSStringFromSelector(@selector(isFinished))];
    }
}

- (void)setExecuting:(BOOL)executing {
    if (_executing != executing) {
        [self willChangeValueForKey:NSStringFromSelector(@selector(isExecuting))];
        _executing = executing;
        [self didChangeValueForKey:NSStringFromSelector(@selector(isExecuting))];
    }
}

- (BOOL)isAsynchronous {
    return YES;
}

@end
