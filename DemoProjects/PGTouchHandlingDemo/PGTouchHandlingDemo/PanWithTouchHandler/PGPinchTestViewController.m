//
//  PGPinchTestViewController.m
//  PGTouchHandlingDemo
//
//  Created by JiangWang on 2018/8/21.
//  Copyright © 2018 JiangWang. All rights reserved.
//

#import "PGPinchTestViewController.h"
#import "PGTouchHandlingView.h"

@interface PGPinchTestViewController ()
@property (nonatomic, strong) PGTouchHandlingView *touchHandlingView;
@property (nonatomic, assign) CGAffineTransform startTransform;
@end

@implementation PGPinchTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.touchHandlingView = [[PGTouchHandlingView alloc] initWithFrame:(CGRect){50, 200, 150, 150}];
    self.touchHandlingView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.touchHandlingView];

    //pinch gesture
    UIPinchGestureRecognizer *pinchGest = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(didPinchView:)];
    [self.view addGestureRecognizer:pinchGest];
}

- (void)didPinchView:(UIPinchGestureRecognizer *)pinchGest {
    switch (pinchGest.state) {
        case UIGestureRecognizerStateBegan: {
            CGFloat scale = [pinchGest scale];
            self.startTransform = [self.touchHandlingView transform];
            NSLog(@"pinch began -- scale: %f", scale);
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGFloat scale = [pinchGest scale];
            NSLog(@"pinch changed -- scale: %f", scale);
            self.touchHandlingView.transform = CGAffineTransformScale(self.startTransform, scale, scale);
            break;
        }
        case UIGestureRecognizerStateCancelled: {
            CGFloat scale = [pinchGest scale];
            NSLog(@"pinch cancelled -- scale: %f", scale);
            break;
        }
        case UIGestureRecognizerStateEnded: {
            break;
        }
        default:
            break;
    }
}

@end
