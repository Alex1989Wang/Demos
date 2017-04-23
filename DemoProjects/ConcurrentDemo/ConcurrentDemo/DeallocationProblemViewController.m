//
//  DeallocationProblemViewController.m
//  ConcurrentDemo
//
//  Created by JiangWang on 23/04/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "DeallocationProblemViewController.h"

@interface DeallocationProblemViewController ()
@property (nonatomic, assign, getter=isViewVisible) BOOL viewVisible;
@end

@implementation DeallocationProblemViewController

#pragma mark - Initialization
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.viewVisible = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self performSelectorInBackground:@selector(deallocationProblem)
                           withObject:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.viewVisible = NO;
//    [NSThread sleepForTimeInterval:0.5f];
    NSLog(@"main thread: %@ disappear awake", [NSThread currentThread]);
}

- (void)dealloc {
    NSLog(@"dellocation %@", self);
}

#pragma mark - Private
- (void)deallocationProblem {
    NSThread *currentThread = [NSThread currentThread];
    NSLog(@"thread: %@", currentThread);
    while (self.viewVisible) {
        NSLog(@"thread will sleep: %@", currentThread);
        [NSThread sleepForTimeInterval:3.f];
        NSLog(@"thread will wake: %@", currentThread);
    }
    [NSThread sleepForTimeInterval:0.5f];
}
     
#pragma mark - Lazy Loading
@end
