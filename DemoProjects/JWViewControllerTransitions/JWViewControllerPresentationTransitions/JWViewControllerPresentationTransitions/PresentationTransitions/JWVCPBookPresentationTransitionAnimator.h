//
//  JWVCPBookPresentationTransitionAnimator.h
//  JWViewControllerPresentationTransitions
//
//  Created by JiangWang on 23/12/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JWVCPBookPresentationTransitionAnimator : NSObject
<UIViewControllerAnimatedTransitioning>

//wether the animator is used to animate presentation or dismissal
@property (nonatomic, assign, getter=isPresenting) BOOL presenting;
@property (nonatomic, assign) CGRect originRect;
@end
