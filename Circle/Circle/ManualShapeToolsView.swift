//
//  ManualShapeToolsView.swift
//  Circle
//
//  Created by JiangWang on 2020/4/21.
//  Copyright © 2020 JiangWang. All rights reserved.
//

import UIKit

class ManualShapeToolsView: UIView {

    private let circle = ManualShapeCircle(frame: CGRect(x: 50, y: 150, width: 50, height: 50))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        circle.isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        return (view == self) ? nil : view
    }

}

extension ManualShapeToolsView: UnityEditGestureViewDelegate {
    func unityTouchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if circle.superview == nil {
            addSubview(circle)
            circle.style = .all
            circle.clipsToBounds = false
            let dimension: CGFloat = 80
            let ct = touches.first?.location(in: self) ?? center
            let frame = CGRect(x: ct.x - dimension/2, y: ct.y - dimension/2, width: dimension, height: dimension)
            circle.frame = frame
        }
    }
    
    func unityTouchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    func unityTouchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) { [weak self] in
//            self?.circle.removeFromSuperview()
//        }
    }
    
    func unityTouchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) { [weak self] in
//            self?.circle.removeFromSuperview()
//        }
    }
    
    func unityDidTap(_ sender: UITapGestureRecognizer) {
        
    }
    
    func unityDidDoubleTap(_ sender: UITapGestureRecognizer) {
       
    }
   
    func unityDidPan(_ gesture: UIPanGestureRecognizer) {
        circle.didPan(gesture)
    }
    
    func unityDidLongPress(_ gesture: UILongPressGestureRecognizer) {
        circle.didLongPress(gesture)
    }
    
}
