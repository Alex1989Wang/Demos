//
//  JWRevealAnimation.swift
//  LogoReveal
//
//  Created by JiangWang on 21/12/2017.
//  Copyright © 2017 awsomejiang.com. All rights reserved.
//

import UIKit

class JWRevealAnimation: NSObject,
UIViewControllerAnimatedTransitioning,
CAAnimationDelegate {
    let animationDuration = 0.8
    var operation: UINavigationControllerOperation = .push
    weak var storedContext: UIViewControllerContextTransitioning?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        storedContext = transitionContext
        if operation == .push {
            let fromVC = transitionContext.viewController(forKey: .from) as! MasterViewController
            let toVC = transitionContext.viewController(forKey: .to) as! DetailViewController
            
            transitionContext.containerView.addSubview(toVC.view)
            toVC.view.frame = transitionContext.finalFrame(for: toVC)
            
            let animation = CABasicAnimation(keyPath: "transform")
            animation.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
            animation.toValue = NSValue(caTransform3D:
                CATransform3DConcat(CATransform3DMakeTranslation(0, -10, 0),
                                    CATransform3DMakeScale(150, 150, 1.0)))
            animation.duration = self.animationDuration
            animation.delegate = self
            animation.fillMode = kCAFillModeForwards
            animation.isRemovedOnCompletion = false
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
            
            let opacityAni = CABasicAnimation(keyPath: "opacity")
            opacityAni.fromValue = NSNumber(floatLiteral: 0)
            opacityAni.toValue = NSNumber(floatLiteral: 1)
            opacityAni.duration = self.animationDuration
            opacityAni.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
            
            let maskLayer: CAShapeLayer = RWLogoLayer.logoLayer()
            maskLayer.position = fromVC.logo.position
            toVC.view.layer.mask = maskLayer
            maskLayer.add(animation, forKey: "mask_transform")
            fromVC.logo.add(animation, forKey: "mask_transform")
            toVC.view.layer.add(opacityAni, forKey: "layer_opacity")
        }
        else {
            let fromView = transitionContext.view(forKey: .from)!
            let toView = transitionContext.view(forKey: .to)!
            
            transitionContext.containerView.addSubview(fromView)
            transitionContext.containerView.insertSubview(toView, belowSubview: fromView)
            
            let animation = CABasicAnimation(keyPath: "transform")
            animation.fromValue = NSValue(caTransform3D:
                CATransform3DConcat(CATransform3DMakeTranslation(0, -10, 0),
                                    CATransform3DMakeScale(150, 150, 1.0)))
            animation.toValue = NSValue(caTransform3D: CATransform3DIdentity)
            animation.duration = self.animationDuration
            animation.delegate = self
            animation.fillMode = kCAFillModeForwards
            animation.isRemovedOnCompletion = false
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
            
            let maskLayer: CAShapeLayer = RWLogoLayer.logoLayer()
            maskLayer.position = fromView.layer.position
            fromView.layer.mask = maskLayer
            maskLayer.add(animation, forKey: "mask_transform")
        }
    }
    
    //MARK: Animation Delegate
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let transitionContext = self.storedContext {
            if operation == .push {
                let fromVC = transitionContext.viewController(forKey: .from) as! MasterViewController
                let toVC = transitionContext.viewController(forKey: .to) as! DetailViewController
                fromVC.logo.removeAllAnimations()
                toVC.view.layer.mask = nil
            }
            else {
                let fromVC = transitionContext.viewController(forKey: .from) as! DetailViewController
                fromVC.view.layer.mask = nil
            }
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        self.storedContext = nil
    }
}
