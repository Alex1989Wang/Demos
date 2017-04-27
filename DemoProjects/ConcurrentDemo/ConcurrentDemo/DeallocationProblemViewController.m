//
//  DeallocationProblemViewController.m
//  ConcurrentDemo
//
//  Created by JiangWang on 23/04/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "DeallocationProblemViewController.h"

@interface DeallocationProblemViewController ()
@property (nonatomic, strong) NSThread *subThread;
@end

@implementation DeallocationProblemViewController

#pragma mark - Initialization
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self performSelector:@selector(deallocationProblem)
                 onThread:self.subThread
               withObject:nil
            waitUntilDone:NO];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    [NSThread sleepForTimeInterval:0.5f];
    [self.subThread cancel];
    NSLog(@"main thread: %@ disappear awake", [NSThread currentThread]);
}

- (void)dealloc {
    NSLog(@"dellocation %@", self);
    NSLog(@"current thread: %@", [NSThread currentThread]);
}

#pragma mark - Private
- (void)deallocationProblem {
    NSThread *currentThread = [NSThread currentThread];
    NSLog(@"thread: %@", currentThread);
    while (!self.subThread.isCancelled) {
        NSLog(@"thread will sleep: %@", currentThread);
        [NSThread sleepForTimeInterval:3.f];
        NSLog(@"thread will wake: %@", currentThread);
    }
    [NSThread sleepForTimeInterval:0.5f];
}
     
#pragma mark - Lazy Loading
- (NSThread *)subThread {
    if (nil == _subThread) {
        _subThread = [[NSThread alloc] init];
        [_subThread start];
    }
    return _subThread;
}
@end
