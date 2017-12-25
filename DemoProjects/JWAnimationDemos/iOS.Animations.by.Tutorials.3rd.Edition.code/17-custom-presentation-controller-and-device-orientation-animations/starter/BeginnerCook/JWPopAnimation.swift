//
//  JWPopAnimation.swift
//  BeginnerCook
//
//  Created by JiangWang on 20/12/2017.
//  Copyright © 2017 awesomejiang.com. All rights reserved.
//

import UIKit

class JWPopAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    //MARK: Properties 
    let duration = 0.3
    var originalFrame = CGRect.zero
    var presenting = true;
    var dismissalCompletion : (()->Void)?
    
    //MARK: Required Methods
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        NSLog("called counter: \(JWAutoIncrementCounter.currentCounter()) -- function: \(#function))")
        return self.duration;
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        let herbView = self.presenting ? toView : transitionContext.view(forKey: .from)!
        let herbController = (self.presenting ?
            transitionContext.viewController(forKey: .to) :
            transitionContext.viewController(forKey: .from)) as! HerbDetailsViewController
        
        let initialFrame = self.presenting ? self.originalFrame : herbView.frame;
        let finalFrame = self.presenting ? herbView.frame : self.originalFrame;
        let xScaleFactor = self.presenting ?
            (initialFrame.width/finalFrame.width) :
            (finalFrame.width/initialFrame.width)
        let yScaleFactor = self.presenting ?
            (initialFrame.height/finalFrame.height) :
            (finalFrame.height/initialFrame.height)
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
        if presenting {
            herbView.transform = scaleTransform;
            herbView.center = CGPoint(x: initialFrame.midX, y: initialFrame.midY)
            herbView.clipsToBounds = true
            herbView.layer.cornerRadius = 20/xScaleFactor;
            herbController.containerView.alpha = 0
        }
        
        containerView.addSubview(toView)
        containerView.bringSubview(toFront: herbView)
        UIView.animate(withDuration: self.duration,
                       delay: 0,
                       usingSpringWithDamping: 0.4,
                       initialSpringVelocity: 0,
                       animations: { 
                        herbView.transform = (self.presenting) ?
                            CGAffineTransform.identity : scaleTransform;
                        herbView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
                        herbController.containerView.alpha = (self.presenting) ? 1.0 : 0
                        herbView.layer.cornerRadius = (self.presenting) ? 0 : 20/xScaleFactor;
        },
                       completion: {
                        _ in
                        if !self.presenting {
                            self.dismissalCompletion?()
                        }
                        transitionContext.completeTransition(true)
        }
        )
        NSLog("called counter: \(JWAutoIncrementCounter.currentCounter()) -- function: \(#function))")
    }
}
