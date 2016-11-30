//
//  ViewController.m
//  UIViewProgrammingGuide
//
//  Created by JiangWang on 17/11/2016.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "ViewController.h"
#import <Masonry.h>
#import "DrawingTestView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //crate a view for experimenting
    [self animateBackgroundColor];
    
    //view rotating expertiment
//    [self rotateViewBy45Degrees];
}

- (void)animateBackgroundColor
{
    UIView *brownToOrangeView = [[UIView alloc] init];
    brownToOrangeView.backgroundColor = [UIColor brownColor];
    [self.view addSubview:brownToOrangeView];
    [brownToOrangeView mas_makeConstraints:
    ^(MASConstraintMaker *make)
    {
        make.size.mas_equalTo(CGSizeMake(100, 100));
        make.center.mas_equalTo(self.view);
    }];
    
    [UIView animateWithDuration:1 animations:^{
        brownToOrangeView.backgroundColor = [UIColor orangeColor];
    }];
}

- (void)rotateViewBy45Degrees
{
    DrawingTestView *testView = [[DrawingTestView alloc] init];
    [self.view addSubview:testView];
    testView.backgroundColor = [UIColor blueColor];
    [testView mas_makeConstraints:
    ^(MASConstraintMaker *make)
    {
        make.size.mas_equalTo(CGSizeMake(200, 200));
        make.centerX.mas_equalTo(self.view);
        make.centerY.mas_equalTo(200);
    }];
    
    testView.transform = CGAffineTransformMakeRotation(M_PI / 4);
}

@end
