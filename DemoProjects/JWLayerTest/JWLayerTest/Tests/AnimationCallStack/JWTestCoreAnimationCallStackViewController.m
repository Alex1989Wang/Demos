//
//  JWTestCoreAnimationCallStackViewController.m
//  LayerTest
//
//  Created by JiangWang on 05/03/2018.
//  Copyright © 2018 JiangWang. All rights reserved.
//

#import "JWTestCoreAnimationCallStackViewController.h"
#import "JWAnimationTestView.h"

@interface JWTestCoreAnimationCallStackViewController ()
@property (nonatomic, strong) NSTimer *repeatTimer;
@end

@implementation JWTestCoreAnimationCallStackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSTimer *repeatTimer =
    [NSTimer scheduledTimerWithTimeInterval:5.0
                                     target:self
                                   selector:@selector(startTestAnimation)
                                   userInfo:nil
                                    repeats:YES];
    self.repeatTimer = repeatTimer;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.repeatTimer) {
        [self.repeatTimer invalidate];
        self.repeatTimer = nil;
    }
}

- (void)startTestAnimation {
    //used to test core animation profile call stack.
    NSBundle *mainBundle = [NSBundle mainBundle];
    UINib *viewNib = [UINib nibWithNibName:@"JWAnimationTestView" bundle:mainBundle];
    NSArray *views = [viewNib instantiateWithOwner:nil options:nil];
    JWAnimationTestView *animationView = [views firstObject];
    animationView.frame = CGRectMake(0, 0, 300, 500);
    animationView.backgroundColor = [UIColor brownColor];
    animationView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:3
                     animations:
     ^{
         [self.view addSubview:animationView];
         animationView.transform = CGAffineTransformIdentity;
     }
                     completion:
     ^(BOOL finished) {
         [animationView removeFromSuperview];
     }];
}


@end
