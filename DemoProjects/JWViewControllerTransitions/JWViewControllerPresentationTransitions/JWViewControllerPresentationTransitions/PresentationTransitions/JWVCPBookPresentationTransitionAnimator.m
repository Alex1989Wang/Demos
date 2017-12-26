//
//  JWVCPBookPresentationTransitionAnimator.m
//  JWViewControllerPresentationTransitions
//
//  Created by JiangWang on 23/12/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "JWVCPBookPresentationTransitionAnimator.h"
#import "JWVCPBookDetailViewController.h"
#import "JWVCPViewController.h"

static CGFloat kAnimationDuration = 0.5;

@implementation JWVCPBookPresentationTransitionAnimator

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return kAnimationDuration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *bookDetailView = (self.isPresenting) ?
    [transitionContext viewForKey:UITransitionContextToViewKey] :
    [transitionContext viewForKey:UITransitionContextFromViewKey];
    CGRect smallOriginViewRect = self.originRect;
    UIView *containerView = transitionContext.containerView;
    CGRect toViewFrame = [transitionContext viewForKey:UITransitionContextToViewKey].frame;
    
    CGFloat xScale = fabs(smallOriginViewRect.size.width /
                         bookDetailView.bounds.size.width);
    CGFloat yScale = fabs(smallOriginViewRect.size.height/
                         bookDetailView.bounds.size.height);
    CGAffineTransform scaleTrans = CGAffineTransformMakeScale(xScale, yScale);
    if (self.presenting) {
        bookDetailView.center = (CGPoint){CGRectGetMidX(smallOriginViewRect),
            CGRectGetMidY(smallOriginViewRect)};
        bookDetailView.transform = scaleTrans;
        bookDetailView.layer.cornerRadius = self.originCornerRadius/xScale;
        bookDetailView.layer.masksToBounds = YES;
    }
    
    [containerView addSubview:bookDetailView];
    [containerView insertSubview:[transitionContext viewForKey:UITransitionContextToViewKey]
                    belowSubview:bookDetailView];
    [UIView animateWithDuration:kAnimationDuration
                          delay:0
         usingSpringWithDamping:0.5
          initialSpringVelocity:0
                        options:0
                     animations:
     ^{
         bookDetailView.center = (self.presenting) ?
         (CGPoint){CGRectGetMidX(toViewFrame), CGRectGetMidY(toViewFrame)} :
         (CGPoint){CGRectGetMidX(self.originRect), CGRectGetMidY(self.originRect)};
         bookDetailView.transform = (self.presenting) ?
         CGAffineTransformIdentity : scaleTrans;
         bookDetailView.layer.cornerRadius = (self.presenting) ? 0 :
         self.originCornerRadius/xScale;
     }
                     completion:
     ^(BOOL finished) {
         if (self.aniCompletion) {
             self.aniCompletion();
         }
         [transitionContext completeTransition:YES];
     }];
}
@end
