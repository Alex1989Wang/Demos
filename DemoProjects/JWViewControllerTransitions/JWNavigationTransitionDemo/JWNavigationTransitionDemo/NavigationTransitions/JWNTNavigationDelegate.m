//
//  JWNTNavigationDelegate.m
//  JWNavigationTransitionDemo
//
//  Created by JiangWang on 30/12/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "JWNTNavigationDelegate.h"
#import "JWNTNavigationSlideTransition.h"

@interface JWNTNavigationDelegate()
@property (nonatomic, strong) JWNTNavigationSlideTransition *slideTransition;
@end

@implementation JWNTNavigationDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    //slide slideTransition animator
    JWNTNavigationSlideTransition *slideTransitionAnimator = self.slideTransition;
    slideTransitionAnimator.naviOperation = operation;
    return slideTransitionAnimator;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    if ([animationController isKindOfClass:[JWNTNavigationSlideTransition class]]) {
        return [(JWNTNavigationSlideTransition *)animationController isInteractive] ?
        (JWNTNavigationSlideTransition *)animationController : nil;
    }
    return nil;
}

#pragma mark - Lazy Loading 
- (JWNTNavigationSlideTransition *)slideTransition {
    if (!_slideTransition) {
        //slide slideTransition animator
        JWNTNavigationSlideTransition *slideTransitionAnimator =
        [[JWNTNavigationSlideTransition alloc] init];
        _slideTransition = slideTransitionAnimator;
    }
    return _slideTransition;
}
@end

