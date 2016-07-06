//
//  ViewController.m
//  ParentViewAndChildView
//
//  Created by JiangWang on 16/7/6.
//  Copyright © 2016年 JiangWang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *parentView;
@property (weak, nonatomic) IBOutlet UIView *childView;

@property (weak, nonatomic) UIView *orangeView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *orangeView = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 200, 200)];
    [orangeView setBackgroundColor:[UIColor orangeColor]];
    [self.view addSubview:orangeView];
    
    UIView *brownView = [[UIView alloc] initWithFrame:orangeView.bounds];
    [brownView setBackgroundColor:[UIColor brownColor]];
    [orangeView addSubview:brownView];
    
    orangeView.layer.position = CGPointMake(0, [UIScreen mainScreen].bounds.size.height);
    orangeView.layer.anchorPoint = CGPointMake(0, 1.0);
    
    //add a gesture recognizer
    [orangeView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToChangeFrame)]];
    self.orangeView = orangeView;
}


- (void)tapToChangeFrame {
    if ([NSStringFromCGAffineTransform(self.orangeView.transform) isEqualToString:NSStringFromCGAffineTransform(CGAffineTransformIdentity)]) {
        [UIView animateWithDuration:0.5 animations:^{
            self.orangeView.transform = CGAffineTransformMakeScale(1.5, 1.5);
        }];
    }else {
        [UIView animateWithDuration:0.5 animations:^{
            self.orangeView.transform = CGAffineTransformIdentity;
        }];
    }
}

@end
