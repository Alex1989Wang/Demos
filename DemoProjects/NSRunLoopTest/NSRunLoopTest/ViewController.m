//
//  ViewController.m
//  NSRunLoopTest
//
//  Created by JiangWang on 24/05/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, weak) UIButton *testButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViewHierachy];
    
    //every thread has an associated run loop object.
    [self everyThreadHasARunLoopObject];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //will global queue's associated run loop object change?
    [self willGlobalQueueRunLoopObjectChange];
}

- (void)setupViewHierachy {
    [self testButton];
}

- (void)everyThreadHasARunLoopObject {
    dispatch_queue_t globalQueue = dispatch_get_global_queue(QOS_CLASS_UTILITY, 0);
    dispatch_async(globalQueue, ^{
        NSLog(@"current runloop object: %@", [NSRunLoop currentRunLoop]);
    });
    
    const char *customizedQueueID = [@"jiangwang.customized.queue" cStringUsingEncoding:NSUTF8StringEncoding];
    dispatch_queue_t customizedQueue = dispatch_queue_create(customizedQueueID,
                                                             DISPATCH_QUEUE_SERIAL);
    dispatch_async(customizedQueue, ^{
        NSLog(@"current runloop object: %@", [NSRunLoop currentRunLoop]);
    });
}

- (void)willGlobalQueueRunLoopObjectChange {
    dispatch_queue_t globalQueue = dispatch_get_global_queue(QOS_CLASS_UTILITY, 0);
    dispatch_async(globalQueue, ^{
        NSLog(@"current runloop object: %@", [NSRunLoop currentRunLoop]);
    });
}

- (void)runTestCase:(UIButton *)testButton {
    [self willGlobalQueueRunLoopObjectChange];
}

- (void)test {
    NSInteger age = 20;
    UILabel *myLabel = [UILabel new];
    myLabel.text = age ? [NSString stringWithFormat:@"%@", age] : @"";
}

#pragma mark - Lazy Loading 
- (UIButton *)testButton {
    if (nil == _testButton) {
        UIButton *testButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _testButton = testButton;
        [self.view addSubview:testButton];
        
        testButton.frame = (CGRect){100, 100, 100, 40};
        [testButton setTitle:@"test button" forState:UIControlStateNormal];
        [testButton setBackgroundColor:[UIColor brownColor]];
        [testButton addTarget:self
                       action:@selector(runTestCase:)
             forControlEvents:UIControlEventTouchUpInside];
    }
    return _testButton;
}

@end
