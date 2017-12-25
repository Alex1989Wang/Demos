//
//  JWTabPushedViewController.m
//  JWAutoRotateExpOne
//
//  Created by JiangWang on 15/11/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "JWTabPushedViewController.h"
#import "JWNavigationController.h"

@interface JWTabPushedViewController ()
@property (nonatomic, weak) UILabel *contentLabel;
@property (nonatomic, weak) UIButton *presentButton;
@end

@implementation JWTabPushedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self contentLabel];
    [self presentButton];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (void)didClickToTestPresent:(UIButton *)presentButton {
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        JWTabPushedViewController *presentedCon = [[JWTabPushedViewController alloc] init];
        [self presentViewController:presentedCon animated:YES completion:nil];
    }
}

#pragma mark - Lazy Loading 
- (UILabel *)contentLabel {
    if (!_contentLabel) {
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
        contentLabel.textColor = [UIColor blackColor];
        contentLabel.text = @"This is pushed by main tab.";
        contentLabel.font = [UIFont systemFontOfSize:17.f];
        contentLabel.numberOfLines = 0;
        contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel = contentLabel;
        
        [self.view addSubview:contentLabel];
        NSLayoutConstraint *centerXCons =
        [contentLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor];
        NSLayoutConstraint *centerYCons =
        [contentLabel.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor];
        NSLayoutConstraint *leadingCons =
        [contentLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor];
        NSLayoutConstraint *trailingCons =
        [contentLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor];
        [self.view addConstraints:@[centerXCons, centerYCons, leadingCons, trailingCons]];
    }
    return _contentLabel;
}


- (UIButton *)presentButton {
    if (!_presentButton) {
        UIButton *presentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        presentButton.translatesAutoresizingMaskIntoConstraints = NO;
        [presentButton setTitle:@"Click To Present" forState:UIControlStateNormal];
        [presentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [presentButton addTarget:self
                       action:@selector(didClickToTestPresent:)
             forControlEvents:UIControlEventTouchUpInside];
        _presentButton = presentButton;
        
        [self.view addSubview:presentButton];
        NSLayoutConstraint *centerXCons =
        [presentButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor];
        NSLayoutConstraint *centerYCons =
        [presentButton.centerYAnchor constraintEqualToAnchor:self.contentLabel.centerYAnchor constant:100];
        [self.view addConstraint:centerXCons];
        [self.view addConstraint:centerYCons];
    }
    return _presentButton;
}


@end
