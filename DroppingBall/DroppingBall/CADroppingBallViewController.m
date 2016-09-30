//
//  CADroppingBallViewController.m
//  DroppingBall
//
//  Created by JiangWang on 30/09/2016.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "CADroppingBallViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface CADroppingBallViewController ()

@end

@implementation CADroppingBallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImage *ball = [UIImage imageNamed:@"ball"];
    UIImageView *ballView = [[UIImageView alloc] initWithImage:ball];
    
    [self.view addSubview:ballView];
    
    [self addBallFallingAnimation:ballView.layer];
}

- (void)addBallFallingAnimation:(CALayer *)layer {
    NSString *keyPath = @"transform.translation.y";
    CAKeyframeAnimation *translationInY = [CAKeyframeAnimation animationWithKeyPath:keyPath];
   
    //values are used to interpolate the translation
    NSMutableArray *values = [NSMutableArray array];
    CGFloat startingValue = 0.f;
    CGFloat endValue = [UIScreen mainScreen].bounds.size.height - layer.bounds.size.height;
    [values addObject:@(startingValue)];
    [values addObject:@(endValue)];
    
    //timing functions
    NSMutableArray *timingFuctions = [NSMutableArray array];
    [timingFuctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    translationInY.timingFunctions = timingFuctions;
    
    //add an animation duration and repeat count
    translationInY.duration = 0.5f;
    translationInY.repeatCount = HUGE_VAL;
    translationInY.values = values;
    translationInY.autoreverses = YES;
    
    //submit the animation
    [layer addAnimation:translationInY forKey:keyPath];
}


@end
