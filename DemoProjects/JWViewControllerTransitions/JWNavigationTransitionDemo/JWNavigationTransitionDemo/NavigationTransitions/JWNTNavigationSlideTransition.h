//
//  JWNTNavigationSlideTransition.h
//  JWNavigationTransitionDemo
//
//  Created by JiangWang on 30/12/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JWNTNavigationSlideTransition : UIPercentDrivenInteractiveTransition
<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) UINavigationControllerOperation naviOperation;
@property (nonatomic, assign, getter=isInteractive, readonly) BOOL interactive;
@end
