//
//  ViewController.m
//  GCDDemo
//
//  Created by JiangWang on 20/04/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "ViewController.h"
#import "GCDTester.h"
#import "NSOperationTester.h"

@interface ViewController ()
@property (nonatomic, strong) GCDTester *gcdTester;
@property (nonatomic, weak) UIButton *resetButton;
@property (nonatomic, strong) NSOperationTester *operationTester;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self resetButton];
    
    GCDTester *gcdTester = [[GCDTester alloc] init];
    self.gcdTester = gcdTester;
    
    NSOperationTester *operationTester = [[NSOperationTester alloc] init];
    self.operationTester = operationTester;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.operationTester concurrentTest];
}

- (void)clickToResetTest:(UIButton *)button {
    [self.operationTester concurrentTest];
}

#pragma mark - Lazy Loading 
- (UIButton *)resetButton {
    if (nil == _resetButton) {
        UIButton *resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _resetButton = resetButton;
        [resetButton setTitle:@"reset" forState:UIControlStateNormal];
        [resetButton addTarget:self
                        action:@selector(clickToResetTest:)
              forControlEvents:UIControlEventTouchUpInside];
        resetButton.frame = (CGRect){0, 0, 40, 40};
        resetButton.backgroundColor = [UIColor brownColor];
        [self.view addSubview:resetButton];
    }
    return _resetButton;
}

@end
