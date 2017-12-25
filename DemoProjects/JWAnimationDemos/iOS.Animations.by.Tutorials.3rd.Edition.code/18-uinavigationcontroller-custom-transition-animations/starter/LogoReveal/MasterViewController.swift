/*
* Copyright (c) 2014-2016 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit
import QuartzCore

func delay(seconds: Double, completion: @escaping ()-> Void) {
  DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
}

class MasterViewController: UIViewController {
  
  let logo = RWLogoLayer.logoLayer()
    let transition = JWRevealAnimation()
    let interactiveTransition = JWInteractiveRevealAnimator()
    
    
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Start"
    self.navigationController?.delegate = self
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    // add the tap gesture recognizer
    let pan = UIPanGestureRecognizer(target: self, action: #selector(didPan))
    view.addGestureRecognizer(pan)
    
    
    // add the logo to the view
    logo.position = CGPoint(x: view.layer.bounds.size.width/2,
      y: view.layer.bounds.size.height/2 - 30)
    logo.fillColor = UIColor.white.cgColor
    view.layer.addSublayer(logo)
  }
  
    //
    // MARK: Gesture recognizer handler
    //
    func didPan(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            self.interactiveTransition.interactive = true
            performSegue(withIdentifier: "details", sender: nil)
        default:
            self.interactiveTransition.handlePanGesture(panGesture: recognizer)
        }
    }
}

extension MasterViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.interactiveTransition.operation = operation
        return self.interactiveTransition
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if !interactiveTransition.interactive {
            return nil
        }
        
        return interactiveTransition
    }
}
