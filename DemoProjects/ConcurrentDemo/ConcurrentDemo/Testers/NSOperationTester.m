//
//  NSOperationTester.m
//  GCDDemo
//
//  Created by JiangWang on 21/04/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "NSOperationTester.h"

#define kTaskNumIncrement 5

@interface NSOperationTester()
@property (nonatomic, strong) NSOperationQueue *testQueue;
@property (nonatomic, strong) NSOperationQueue *serialQueue;
@end

@implementation NSOperationTester

- (void)serialTest {
    NSBlockOperation *dependentTask = [[NSBlockOperation alloc] init];
    [dependentTask addExecutionBlock:^{
        sleep(0.5);
        NSLog(@"dependent task -- thread: %@",
              [NSThread currentThread]);
    }];
    
    for (NSInteger taskIndex = 0; taskIndex < kTaskNumIncrement; taskIndex++) {
        NSBlockOperation *blockTask = [[NSBlockOperation alloc] init];
        [blockTask addExecutionBlock:^{
            sleep(0.5);
            NSLog(@"concurrent task no.%ld -- thread: %@",
                  taskIndex, [NSThread currentThread]);
        }];
        
        [dependentTask addDependency:blockTask];
        [self.serialQueue addOperation:blockTask];
    }
    
    [self.serialQueue addOperation:dependentTask];
    
    //another 5 tasks
    for (NSInteger taskIndex = 5; taskIndex < kTaskNumIncrement * 2; taskIndex++) {
        NSBlockOperation *blockTask = [[NSBlockOperation alloc] init];
        [blockTask addExecutionBlock:^{
            sleep(0.5);
            NSLog(@"concurrent task no.%ld -- thread: %@",
                  taskIndex, [NSThread currentThread]);
        }];
        [self.serialQueue addOperation:blockTask];
    }
}

- (void)concurrentTest {
    NSBlockOperation *dependentTask = [[NSBlockOperation alloc] init];
    [dependentTask addExecutionBlock:^{
        sleep(0.5);
        NSLog(@"dependent task -- thread: %@",
              [NSThread currentThread]);
    }];
    
    for (NSInteger taskIndex = 0; taskIndex < kTaskNumIncrement; taskIndex++) {
        NSBlockOperation *blockTask = [[NSBlockOperation alloc] init];
        [blockTask addExecutionBlock:^{
            sleep(0.5);
            NSLog(@"concurrent task no.%ld -- thread: %@",
                  taskIndex, [NSThread currentThread]);
        }];
        
        [dependentTask addDependency:blockTask];
        [self.testQueue addOperation:blockTask];
    }
    
    [self.testQueue addOperation:dependentTask];
    
    //another 5 tasks
    for (NSInteger taskIndex = 5; taskIndex < kTaskNumIncrement * 2; taskIndex++) {
        NSBlockOperation *blockTask = [[NSBlockOperation alloc] init];
        [blockTask addExecutionBlock:^{
            sleep(0.5);
            NSLog(@"concurrent task no.%ld -- thread: %@",
                  taskIndex, [NSThread currentThread]);
        }];
        [self.testQueue addOperation:blockTask];
    }
}

#pragma mark - Lazy Loading 
- (NSOperationQueue *)testQueue {
    if (nil == _testQueue) {
        _testQueue = [[NSOperationQueue alloc] init];
    }
    return _testQueue;
}

- (NSOperationQueue *)serialQueue {
    if (nil == _serialQueue) {
        _serialQueue = [[NSOperationQueue alloc] init];
        _serialQueue.maxConcurrentOperationCount = 1;
    }
    return _serialQueue;
}

@end
