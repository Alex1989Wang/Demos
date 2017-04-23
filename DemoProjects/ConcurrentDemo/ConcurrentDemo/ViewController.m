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
    
    NSOperationTester *operationTester = [[NSOperationTester alloc] init];
    self.operationTester = operationTester;
    [self.operationTester serialTest];
}

- (void)pushDeallocationProblemController:(UIButton *)deButton {
    DeallocationProblemViewController *deCon =
    [[DeallocationProblemViewController alloc] init];
    [self.navigationController pushViewController:deCon
                                         animated:YES];
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
