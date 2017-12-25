//
//  JWMainTabViewController.m
//  JWAutoRotateExpOne
//
//  Created by JiangWang on 15/11/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "JWMainTabViewController.h"
#import "JWViewController.h"
#import "JWTabPushedViewController.h"
#import "JWNavigationController.h"

@interface JWMainTabViewController ()
@property (nonatomic, weak) UIButton *pushButton;
@end

@implementation JWMainTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTabControllers];
    [self pushButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didClickToTestPush:(UIButton *)pushButton {
    JWTabPushedViewController *pushedController = [[JWTabPushedViewController alloc] init];
    [self.navigationController pushViewController:pushedController animated:YES];
}

- (BOOL)shouldAutorotate {
    return [self.selectedViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self.selectedViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (void)setupTabControllers {
    JWViewController *redController = [[JWViewController alloc] init];
    redController.view.backgroundColor = [UIColor redColor];
    redController.tabBarItem.title = @"Red";
    JWNavigationController *redNaviCon =
    [[JWNavigationController alloc] initWithRootViewController:redController];
    
    JWViewController *blueController = [[JWViewController alloc] init];
    blueController.view.backgroundColor = [UIColor blueColor];
    blueController.tabBarItem.title = @"Blue";
    JWNavigationController *blueNaviCon =
    [[JWNavigationController alloc] initWithRootViewController:blueController];
    
    JWViewController *brownnController = [[JWViewController alloc] init];
    brownnController.view.backgroundColor = [UIColor brownColor];
    brownnController.tabBarItem.title = @"Brown";
    JWNavigationController *brownNaviCon =
    [[JWNavigationController alloc] initWithRootViewController:brownnController];
    
    [self addChildViewController:redNaviCon];
    [self addChildViewController:blueNaviCon];
    [self addChildViewController:brownNaviCon];
}

- (UIButton *)pushButton {
    if (!_pushButton) {
        UIButton *pushButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pushButton.translatesAutoresizingMaskIntoConstraints = NO;
        [pushButton setTitle:@"Tab Click To Push" forState:UIControlStateNormal];
        [pushButton addTarget:self
                       action:@selector(didClickToTestPush:)
             forControlEvents:UIControlEventTouchUpInside];
        _pushButton = pushButton;
        
        [self.view addSubview:pushButton];
        NSLayoutConstraint *trailingCons =
        [pushButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-30];
        NSLayoutConstraint *bottomCons =
        [pushButton.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-100];
        [self.view addConstraints:@[trailingCons, bottomCons]];
    }
    return _pushButton;
}

@end
