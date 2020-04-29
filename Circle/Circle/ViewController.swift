//
//  ViewController.swift
//  Circle
//
//  Created by JiangWang on 2020/4/20.
//  Copyright © 2020 JiangWang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        // gesture视图
        let gestureView = UnityEditGestureView(frame: view.bounds)
        view.addSubview(gestureView)
        
        // container
        let container = ManualShapeToolsView(frame: view.bounds)
        view.addSubview(container)
        gestureView.gestureDelegate = container
    }
}

