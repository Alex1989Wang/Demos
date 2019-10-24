//
//  ViewController.swift
//  Transform
//
//  Created by JiangWang on 2019/9/20.
//  Copyright © 2019 JiangWang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var testView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let testView = UIView(frame: CGRect(x: 100, y: 100, width: 80, height: 80))
        testView.backgroundColor = .red
        self.testView = testView
        view.addSubview(testView)
    }

    @IBAction func scaleThenTranslate() {
        testView.transform = .identity
        var transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        transform = transform.translatedBy(x: 0, y: 150)
        UIView.animate(withDuration: 0.5) {
            self.testView.transform = transform
        }
    }
    
    @IBAction func translateThenScale() {
        testView.transform = .identity
        var transform = CGAffineTransform(translationX: 0, y: 150)
        transform = transform.scaledBy(x: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.5) {
            self.testView.transform = transform
        }
    }
}

