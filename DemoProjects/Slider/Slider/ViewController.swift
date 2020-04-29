//
//  ViewController.swift
//  Slider
//
//  Created by JiangWang on 2020/4/9.
//  Copyright © 2020 JiangWang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let slider = SliderView(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(slider)
        slider.backgroundColor = UIColor.red
       
        /*
         配置
         */
        slider.minimumValue = -100
        slider.maximumValue = 100
        slider.step = 1
        slider.showCenter = true
        slider.showDefaultValueIndicator = true
        slider.enableDefaultValueFeedback = true
        slider.defaultValue = 30
//        slider.showDefaultValueIndicator = false
        slider.valueChanged = { (value) in
            print("value changed: \(value)")
        }

        slider.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [slider.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50),
                           slider.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50),
                           slider.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
                           slider.heightAnchor.constraint(equalToConstant: 80)]
        view.addConstraints(constraints)
    }

}

