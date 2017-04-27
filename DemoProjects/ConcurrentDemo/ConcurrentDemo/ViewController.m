//
//  ViewController.m
//  ConcurrentDemo
//
//  Created by JiangWang on 23/04/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "ViewController.h"
#import "DeallocationProblemViewController.h"
#import "NSOperationTester.h"

#import "TestAnswersAPIManager.h"
#import "TestOperationQueueManager.h"
#import "TestSynchronusOperation.h"

@interface ViewController ()
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, weak) UIButton *pushDeallocButton;
@property (nonatomic, strong) NSOperationTester *operationTester;
@end

@implementation ViewController

#pragma mark - Initialization 
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self pushDeallocButton]; //add button
    
//    NSOperationTester *operationTester = [[NSOperationTester alloc] init];
//    self.operationTester = operationTester;
//    [self.operationTester serialTest];
}

- (void)pushDeallocationProblemController:(UIButton *)deButton {
    DeallocationProblemViewController *deCon =
    [[DeallocationProblemViewController alloc] init];
    [self.navigationController pushViewController:deCon
                                         animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    TestSynchronusOperation *syncOperationTest = [[TestSynchronusOperation alloc] init];
    [[TestOperationQueueManager sharedManager] addOperation:syncOperationTest];
}

#pragma mark - Check Floating Point Number Zero;
- (void)checkFloatingPointZero {
    CGFloat zeroFP = 0.0;
    while (fpclassify(zeroFP) == FP_ZERO) {
        NSLog(@"found zero : %f", zeroFP);
        zeroFP += 1.0 / MAXFLOAT;
    }
}

- (void)answerAPIManagerTest {
    [TestAnswersAPIManager retrieveAnswersWithCompletion:^(NSArray *answers) {
        for (NSDictionary *answer in answers) {
            if ([answer isKindOfClass:[NSDictionary class]]) {
                NSString *keys = [[answer allKeys] componentsJoinedByString:@","];
                NSLog(@"answer keys: %@", keys);
            }
        }
    }];
}

#pragma mark - Lazy Loading 
- (NSOperationQueue *)operationQueue {
    if (nil == _operationQueue) {
        _operationQueue = [[NSOperationQueue alloc] init];
    }
    return _operationQueue;
}

- (UIButton *)pushDeallocButton {
    if (nil == _pushDeallocButton) {
        UIButton *deallocButton = [[UIButton alloc] init];
        _pushDeallocButton = deallocButton;
        deallocButton.frame = (CGRect){100, 100, 80, 60};
        [self.view addSubview:deallocButton];
        
        deallocButton.backgroundColor = [UIColor brownColor];
        [deallocButton addTarget:self
                          action:@selector(pushDeallocationProblemController:)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _pushDeallocButton;
}

@end
