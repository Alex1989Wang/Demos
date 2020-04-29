//
//  RemoveViewTestViewController.swift
//  AutoLayout
//
//  Created by JiangWang on 2020/3/4.
//  Copyright © 2020 JiangWang. All rights reserved.
//

import UIKit

class RemoveViewTestViewController: UIViewController {
    
    var testButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        /// 按钮
        let button = UIButton(type: .custom)
        button.setTitle("5000", for: .normal)
        button.addTarget(self, action: #selector(testAutoLayout), for: .touchUpInside)
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        view.addConstraints(constraints)
        button.backgroundColor = .red
        testButton = button
    }
}

extension RemoveViewTestViewController {
    @objc func testAutoLayout() {
        for index in 0..<5000 {
            let view = UIView(frame: .zero)
            self.view.addSubview(view)
            let constraints = [
                view.bottomAnchor.constraint(equalTo: testButton.topAnchor, constant: -30),
                view.centerXAnchor.constraint(equalTo: testButton.centerXAnchor)
            ]
            let selfConstraints = [
                view.widthAnchor.constraint(equalToConstant: 200),
                view.heightAnchor.constraint(equalToConstant: 80)
            ]
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = .blue
            self.view.addConstraints(constraints)
            view.addConstraints(selfConstraints)
            view.tag = index + 10000
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) { [weak self] in
            for index in 0..<5000 {
                let view = self?.view.viewWithTag(index + 10000)
                view?.removeFromSuperview()
            }
        }
    }
}
