//
//  ViewController.m
//  UIAnimationFrameObservation
//
//  Created by JiangWang on 18/04/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, weak) UIView *animatingView;
@property (nonatomic, weak) UIButton *animateChangeButton;
@property (nonatomic, weak) UIView *accompanyView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self animatingView];
    [self accompanyView];
    [self animateChangeButton];
    
    //动画
    [self startLinearAnimation];
}

#pragma mark - Animation
- (void)startLinearAnimation {
    UIViewAnimationOptions options =
    UIViewAnimationOptionCurveLinear;
    
    CADisplayLink *updatedFrameLink =
    [CADisplayLink displayLinkWithTarget:self
                                selector:@selector(updateAnimatingViewFrame:)];
    [updatedFrameLink addToRunLoop:[NSRunLoop mainRunLoop]
                           forMode:NSRunLoopCommonModes];
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:1
                          delay:0
                        options:options
                     animations:
     ^{
         __strong typeof(weakSelf) strSelf = weakSelf;
         if (!strSelf) {
             return;
         }
         
         strSelf.animatingView.frame = CGRectMake(0, 400, 50, 50);
     }
                     completion:
     ^(BOOL finished) {
         [updatedFrameLink invalidate];
     }];
    
}

- (void)animateFromCurrentState {
    UIViewAnimationOptions options =
    UIViewAnimationOptionCurveLinear |
    UIViewAnimationOptionBeginFromCurrentState;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:4
                          delay:0
                        options:options
                     animations:
     ^{
         __strong typeof(weakSelf) strSelf = weakSelf;
         if (!strSelf) {
             return;
         }
         CGFloat currentY = strSelf.animatingView.frame.origin.y;
         strSelf.animatingView.frame = CGRectMake(200, currentY, 50, 50);
     }
                     completion:nil];
}

- (void)changeAnimationStyle:(UIButton *)button {
    [self animateFromCurrentState];
}

- (void)updateAnimatingViewFrame:(CADisplayLink *)frameLink {
    NSLog(@"presentation layer frame: %@",
          NSStringFromCGRect(self.animatingView.layer.presentationLayer.frame));
    
    NSLog(@"time stamp: %f --- duration: %f",
          frameLink.timestamp, frameLink.duration);
    
    CGRect oldFrame = self.accompanyView.frame;
    oldFrame.origin.y = self.animatingView.layer.presentationLayer.frame.origin.y;
    self.accompanyView.frame = oldFrame;
}

#pragma mark - Lazy Loading
- (UIView *)animatingView {
    if (nil == _animatingView) {
        UIView *animatingView = [[UIView alloc] init];
        _animatingView = animatingView;
        animatingView.backgroundColor = [UIColor blueColor];
        animatingView.frame = CGRectMake(0, 100, 50, 50);
        [self.view addSubview:animatingView];
    }
    return _animatingView;
}

- (UIButton *)animateChangeButton {
    if (nil == _animateChangeButton) {
        UIButton *animateChangeButton = [[UIButton alloc] init];
        _animateChangeButton = animateChangeButton;
        animateChangeButton.backgroundColor = [UIColor brownColor];
        animateChangeButton.frame = CGRectMake(250, 60, 60, 40);
        [animateChangeButton setTitle:@"Change Animation"
                             forState:UIControlStateNormal];
        [animateChangeButton addTarget:self
                                action:@selector(changeAnimationStyle:)
                      forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:animateChangeButton];
    }
    return _animateChangeButton;
}

- (UIView *)accompanyView {
    if (nil == _accompanyView) {
        UIView *accompanyView = [[UIView alloc] init];
        _accompanyView = accompanyView;
        accompanyView.frame = CGRectMake(250, 200, 20, 20);
        accompanyView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:accompanyView];
    }
    return _accompanyView;
}

@end
