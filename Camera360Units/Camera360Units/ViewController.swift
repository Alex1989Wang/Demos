//
//  ViewController.swift
//  Camera360Units
//
//  Created by JiangWang on 2019/6/4.
//  Copyright © 2019 JiangWang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.black
        view.addSubview(focusView)
        view.addSubview(oldFocusView)
    }
    
    private lazy var focusView: FocusView = {
        let focusView = FocusView(frame: view.bounds)
        focusView.isUserInteractionEnabled = false
        focusView.delegate = self
        return focusView
    }()
    
    private lazy var oldFocusView: PTFocusAndBlurView = {
        let old = PTFocusAndBlurView(frame: view.bounds)
        old.isUserInteractionEnabled = false
        return old
    }()

    @IBAction func showAutoFocus() {
//        focusView.show(type: .auto)
//        oldFocusView.autoFocusAnimation()
//        oldFocusView.longPressAnimation()
//        focusView.showLongPressAnimation()
        focusView.show(type: .lockFocus)
        
        let twoSecsLater = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: twoSecsLater, execute: { [weak self] in
            if let _self = self {
                _self.focusView.reset()
            }
        })
    }
    
    @IBAction func manualFocus() {
//        focusView.show(type: .manual)
        let lens = (arc4random().remainderReportingOverflow(dividingBy: 2).partialValue == 0)
        let blur = (arc4random().remainderReportingOverflow(dividingBy: 2).partialValue == 0)
        oldFocusView.lockFocusAnimation(withLens: lens, withBlur: blur) { [weak self] in
            print("lens: \(lens) -- blur: \(blur)")
            print("lock focus animation finished")
            let twoSecsLater = DispatchTime.now() + 10
            DispatchQueue.main.asyncAfter(deadline: twoSecsLater, execute: {
                if let _self = self {
                    _self.oldFocusView.resetViews()
                }
            })
        }
    }
}


extension ViewController: FocusViewDelegate {
    func canShowBlur(in focusView: FocusView) -> Bool {
        let lens = (arc4random().remainderReportingOverflow(dividingBy: 2).partialValue == 0)
        print("lens: \(lens)")
        return lens
    }
    func canShowLens(in focusView: FocusView) -> Bool {
        let blur = (arc4random().remainderReportingOverflow(dividingBy: 2).partialValue == 0)
        print("blur: \(blur)")
        return blur
    }
}
