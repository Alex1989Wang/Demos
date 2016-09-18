//
//  ViewController.m
//  containerViewCon
//
//  Created by JiangWang on 9/18/16.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "ContainerViewController.h"
#import "TestViewController.h"

@interface ContainerViewController ()

@property (nonatomic, strong) TestViewController *testVC;

@end

@implementation ContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureVC];
    
    [self initTransitionButton];
    
    [self initTestVC];
}

- (void)configureVC {
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.5];
}


- (void)initTransitionButton {
    UIButton *transBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.5 * ([UIScreen mainScreen].bounds.size.width - 120), 0.5 * ([UIScreen mainScreen].bounds.size.height - 40), 120, 40)];
    [self.view addSubview:transBtn];
    
    [transBtn setTitle:@"Click To Transit" forState:UIControlStateNormal];
    [transBtn addTarget:self action:@selector(clickToTransit) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initTestVC {
    self.testVC = [[TestViewController alloc] init];
//    [self addChildViewController:_testVC];
//    [_testVC didMoveToParentViewController:self];
    
    [self.view addSubview:_testVC.chatTable];
}

#pragma mark -
#pragma mark -
- (void)clickToTransit {
    [self.view addSubview:_testVC.view];
    
    [_testVC beginChating];
    
}

@end
