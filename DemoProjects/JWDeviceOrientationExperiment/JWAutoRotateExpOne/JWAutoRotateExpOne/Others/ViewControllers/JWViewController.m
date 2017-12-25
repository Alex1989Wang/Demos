//
//  JWViewController.m
//  JWAutoRotateExpOne
//
//  Created by JiangWang on 15/11/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "JWViewController.h"
#import "JWTabPushedViewController.h"
#import "JWNavigationController.h"

@interface JWViewController ()
@property (nonatomic, weak) UIButton *pushButton;
@end

@implementation JWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self pushButton];
}

- (void)didClickToTestPush:(UIButton *)pushButton {
    JWTabPushedViewController *pushedController = [[JWTabPushedViewController alloc] init];
    [self.navigationController pushViewController:pushedController animated:YES];
}

- (UIButton *)pushButton {
    if (!_pushButton) {
        UIButton *pushButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pushButton.translatesAutoresizingMaskIntoConstraints = NO;
        [pushButton setTitle:@"Child Click To Push" forState:UIControlStateNormal];
        [pushButton addTarget:self
                       action:@selector(didClickToTestPush:)
             forControlEvents:UIControlEventTouchUpInside];
        _pushButton = pushButton;
        
        [self.view addSubview:pushButton];
        NSLayoutConstraint *centerXCons =
        [pushButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor];
        NSLayoutConstraint *centerYCons =
        [pushButton.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor];
        [self.view addConstraints:@[centerXCons, centerYCons]];
    }
    return _pushButton;
}

@end
