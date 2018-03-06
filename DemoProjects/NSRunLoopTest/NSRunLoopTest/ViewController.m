//
//  ViewController.m
//  NSRunLoopTest
//
//  Created by JiangWang on 24/05/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "ViewController.h"
#import "JWSuperVsSelf.h"

@interface ViewController ()
@property (nonatomic, weak) UIButton *testButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViewHierachy];
    
    //every thread has an associated run loop object.
//    [self everyThreadHasARunLoopObject];
    [self timerTest];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //will global queue's associated run loop object change?
//    [self willGlobalQueueRunLoopObjectChange];
}

- (void)setupViewHierachy {
    [self testButton];
    
    JWSelf *selfOjbect = [[JWSelf alloc] init];
}

#pragma mark - Test Methods
- (void)timerTest {
    static NSInteger count = 0;
    NSTimer *timer =
    [NSTimer timerWithTimeInterval:1.0
                           repeats:YES
                             block:
     ^(NSTimer * _Nonnull timer) {
         NSLog(@"run loop: %@ -- fire count: %ld",
               [NSRunLoop currentRunLoop], count++);
     }];
    [[NSRunLoop currentRunLoop] addTimer:timer
                                 forMode:UITrackingRunLoopMode];
}

- (void)everyThreadHasARunLoopObject {
    dispatch_queue_t globalQueue = dispatch_get_global_queue(QOS_CLASS_UTILITY, 0);
    dispatch_async(globalQueue, ^{
        NSLog(@"utility global queue's thread: runloop object: %@", [NSRunLoop currentRunLoop]);
    });
    
    
    const char *customizedQueueID = [@"jiangwang.customized.queue" cStringUsingEncoding:NSUTF8StringEncoding];
    dispatch_queue_t customizedQueue = dispatch_queue_create(customizedQueueID,
                                                             DISPATCH_QUEUE_SERIAL);
    dispatch_async(customizedQueue, ^{
        NSLog(@"customized queue's thread: runloop object: %@", [NSRunLoop currentRunLoop]);
    });
}

- (void)willGlobalQueueRunLoopObjectChange {
    dispatch_queue_t globalQueue = dispatch_get_global_queue(QOS_CLASS_UTILITY, 0);
    dispatch_async(globalQueue, ^{
        NSLog(@"utility global queue's thread: runloop object: %@", [NSRunLoop currentRunLoop]);
    });
}

- (void)runTestCase:(UIButton *)testButton {
    [self willGlobalQueueRunLoopObjectChange];
}

- (void)gotoTestOCWrapper {
    gotoTest();
}

void gotoTest() {
    NSLog(@"gotoTest entry.");
    
    NSLog(@"gotoTest goto label begin");
    if (arc4random()%2) {
        goto gotoLabel;
    }
    NSLog(@"gotoTest goto label may skipe");
    
gotoLabel: {
    NSLog(@"gotoTest goto label");
}
    
    NSLog(@"gotoTest goto label end");
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
                       action:@selector(gotoTestOCWrapper)
             forControlEvents:UIControlEventTouchUpInside];
    }
    return _testButton;
}

@end
