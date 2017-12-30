//
//  JWNTNavigationSlideTransition.m
//  JWNavigationTransitionDemo
//
//  Created by JiangWang on 30/12/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "JWNTNavigationSlideTransition.h"

#define kNavigatioinSlideDuration (0.3)
#define kNavigationPopThreshhold (0.5)

@interface JWNTNavigationSlideTransition()
@property (nonatomic, assign) CGFloat panHorizontalTreshhold;
@property (nonatomic, strong) id<UIViewControllerContextTransitioning>transitionContext;
@property (nonatomic, assign, getter=isInteractive) BOOL interactive;
@end

@implementation JWNTNavigationSlideTransition
#pragma mark - Initialization 
- (instancetype)init {
    self = [super init];
    if (self) {
        _interactive = NO;
    }
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return kNavigatioinSlideDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    if (self.naviOperation == UINavigationControllerOperationNone) {
        return;
    }
    
    BOOL isPushOperation = (self.naviOperation == UINavigationControllerOperationPush);
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *containerView = [transitionContext containerView];
    
    CGRect containerViewBounds = containerView.bounds;
    CGRect leftRect = (CGRect){-CGRectGetWidth(containerViewBounds), 0,
        CGRectGetWidth(containerViewBounds),
        CGRectGetHeight(containerViewBounds)};
    CGRect rightRect = (CGRect){CGRectGetWidth(containerViewBounds), 0,
        CGRectGetWidth(containerViewBounds),
        CGRectGetHeight(containerViewBounds)};
    fromView.frame = containerView.bounds;
    toView.frame = (isPushOperation) ? rightRect : leftRect;
    
    [containerView addSubview:fromView];
    [containerView addSubview:toView];
    if (isPushOperation) {
        self.transitionContext = transitionContext;
        UIScreenEdgePanGestureRecognizer *edgePanGest =
        [[UIScreenEdgePanGestureRecognizer alloc]
         initWithTarget:self
         action:@selector(didPanContainerViewEdge:)];
        edgePanGest.maximumNumberOfTouches = 1;
        edgePanGest.edges = UIRectEdgeLeft;
        [toView addGestureRecognizer:edgePanGest];
        CGFloat containerHalfWidth = 0.5 * CGRectGetWidth(containerViewBounds);
        self.panHorizontalTreshhold = (fpclassify(containerHalfWidth) == FP_ZERO) ?
        0.5 * [UIScreen mainScreen].bounds.size.width : containerHalfWidth;
    }
    
    //animation
    [UIView animateWithDuration:kNavigatioinSlideDuration
                     animations:
     ^{
         fromView.frame = (isPushOperation) ? leftRect : rightRect;
         toView.frame = containerViewBounds;
     }
                     completion:
     ^(BOOL finished) {
         BOOL transitionCancelled = transitionContext.transitionWasCancelled;
         [transitionContext completeTransition:!(transitionCancelled)];
     }];
}

#pragma mark - Interactive Transitioning
- (void)didPanContainerViewEdge:(UIScreenEdgePanGestureRecognizer *)contaierEdgePan {
    CGPoint transition = [contaierEdgePan translationInView:contaierEdgePan.view];
    CGFloat horizontalCompletionPercent =
    MIN(1.0, MAX(0, fabs(transition.x)/ self.panHorizontalTreshhold));
    switch (contaierEdgePan.state) {
        case UIGestureRecognizerStateBegan: {
            self.interactive = YES;
            [contaierEdgePan setTranslation:CGPointZero
                                     inView:contaierEdgePan.view];
            UIViewController *toVC =
            [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
            [toVC.navigationController popViewControllerAnimated:YES];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            [self updateInteractiveTransition:horizontalCompletionPercent];
            break;
        }
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
        default: {
            self.interactive = NO;
            if (horizontalCompletionPercent >= kNavigationPopThreshhold) {
                [self finishInteractiveTransition];
            } else {
                [self cancelInteractiveTransition];
            }
            break;
        }
    }
}

@end
