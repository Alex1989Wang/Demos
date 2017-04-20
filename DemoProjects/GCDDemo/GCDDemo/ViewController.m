//
//  ViewController.m
//  GCDDemo
//
//  Created by JiangWang on 20/04/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "ViewController.h"
#import "GCDTester.h"

@interface ViewController ()
@property (nonatomic, strong) GCDTester *gcdTester;
@property (nonatomic, weak) UIButton *resetButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self resetButton];
    
    GCDTester *gcdTester = [[GCDTester alloc] init];
    self.gcdTester = gcdTester;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.gcdTester serialTest];
}

- (void)clickToResetTest:(UIButton *)button {
    [self.gcdTester serialTest];
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
