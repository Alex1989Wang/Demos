//
//  PGButtonTapMixViewController.m
//  PGTouchHandlingDemo
//
//  Created by JiangWang on 2018/8/8.
//  Copyright © 2018 JiangWang. All rights reserved.
//

#import "PGButtonTapMixViewController.h"

@interface PGButtonTapMixViewController ()
@property (weak, nonatomic) IBOutlet UIButton *tapButton;
@end

@implementation PGButtonTapMixViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tapGest =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapButton:)];
    tapGest.delaysTouchesBegan = YES;
    [self.tapButton addGestureRecognizer:tapGest];
}

#pragma mark - Actions
- (void)didTapButton:(UITapGestureRecognizer *)tapGest {
    NSLog(@"tap guesture gets called.");
}

- (IBAction)didTouchUpInsideButton:(UIButton *)sender {
    NSLog(@"Button touch up inside called.");
}

- (IBAction)didTouchDownButton:(UIButton *)sender {
    NSLog(@"Button touch down called.");
}

@end
