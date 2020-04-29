//
//  UnityEditGestureView.swift
//  Camera360
//
//  Created by luhai on 2020/4/2.
//  Copyright © 2020 Pinguo. All rights reserved.
//

import UIKit

protocol UnityEditGestureViewDelegate: AnyObject {
    
    func unityTouchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    
    func unityTouchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    
    func unityTouchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    
    func unityTouchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?)
    
    func unityDidTap(_ sender: UITapGestureRecognizer)
    
    func unityDidDoubleTap(_ sender: UITapGestureRecognizer)
    
    func unityDidPan(_ gesture: UIPanGestureRecognizer)
    
    func unityDidLongPress(_ gesture: UILongPressGestureRecognizer)
}

class UnityEditGestureView: UIView {
    var currentScale: CGFloat = 1.0

    weak var gestureDelegate: UnityEditGestureViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSystemGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        gestureDelegate?.unityTouchesBegan(touches, with: event)
//        UnitySugoiEdit.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        gestureDelegate?.unityTouchesMoved(touches, with: event)
//        UnitySugoiEdit.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        gestureDelegate?.unityTouchesEnded(touches, with: event)
//        UnitySugoiEdit.touchesEnded(touches, with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        gestureDelegate?.unityTouchesCancelled(touches, with: event)
//        UnitySugoiEdit.touchesCancelled(touches, with: event)
    }
}

// MARK: - 系统手势
extension UnityEditGestureView {
    func addSystemGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTap))
        
        doubleTapGesture.numberOfTapsRequired = 2
        addGestureRecognizer(tapGesture)
        addGestureRecognizer(doubleTapGesture)
        tapGesture.require(toFail: doubleTapGesture)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
        pan.maximumNumberOfTouches = 1
        pan.require(toFail: longPress)
        addGestureRecognizer(pan)
        addGestureRecognizer(longPress)
    }
    
    @objc func tap(sender: UITapGestureRecognizer) {
        gestureDelegate?.unityDidTap(sender)
    }
    
    @objc func doubleTap(sender: UITapGestureRecognizer) {
        gestureDelegate?.unityDidDoubleTap(sender)
    }
    
    @objc func didPan(_ gesture: UIPanGestureRecognizer) {
        gestureDelegate?.unityDidPan(gesture)
    }
    
    @objc func didLongPress(_ gesture: UILongPressGestureRecognizer) {
        gestureDelegate?.unityDidLongPress(gesture)
    }
}


