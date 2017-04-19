//
//  RootViewController.m
//  UIAnimationFrameObservation
//
//  Created by JiangWang on 18/04/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "RootViewController.h"
#import "ViewController.h"

@interface RootViewController ()
@property (nonatomic, weak) UIButton *pushButton;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self pushButton];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)pushViewController:(UIButton *)pushButton {
    ViewController *aniViewCon = [[ViewController alloc] init];
    [self.navigationController pushViewController:aniViewCon animated:YES];
}

#pragma mark - Lazy Loading 
- (UIButton *)pushButton {
    if (nil == _pushButton) {
        UIButton *pushButton = [[UIButton alloc] init];
        _pushButton = pushButton;
        pushButton.frame = CGRectMake(150, 300, 40, 40);
        [pushButton setTitle:@"Push" forState:UIControlStateNormal];
        pushButton.backgroundColor = [UIColor brownColor];
        [pushButton addTarget:self
                       action:@selector(pushViewController:)
             forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:pushButton];
    }
    return _pushButton;
}

@end
