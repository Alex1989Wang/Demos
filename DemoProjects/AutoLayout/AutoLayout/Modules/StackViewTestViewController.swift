//
//  StackViewTestViewController.swift
//  AutoLayout
//
//  Created by JiangWang on 2020/3/8.
//  Copyright © 2020 JiangWang. All rights reserved.
//

import UIKit

class StackViewTestViewController: UIViewController {
    
    @IBOutlet weak var button: UIButton!
    
    /// layout guide 测试
    @IBOutlet weak var container: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let total = 2
        var preButton: UIButton? = nil
        var preGuide: UILayoutGuide? = nil
        for index in 0...total {
            let button = UIButton(frame: .zero)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle("Button \(index)", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .red
            container.addSubview(button)
            
            var leftConstraint: NSLayoutConstraint? = nil
            if index == 0 {
                leftConstraint = button.leftAnchor.constraint(equalTo: container.leftAnchor)
            } else {
                if let guide = preGuide {
                    leftConstraint = button.leftAnchor.constraint(equalTo: guide.rightAnchor)
                }
            }
            var buttonConstraints: [NSLayoutConstraint] = []
            if let left = leftConstraint {
                buttonConstraints.append(left)
            }
            buttonConstraints.append(button.topAnchor.constraint(equalTo: container.topAnchor))
            buttonConstraints.append(button.bottomAnchor.constraint(equalTo: container.bottomAnchor))
            if let pButton = preButton {
                buttonConstraints.append(button.widthAnchor.constraint(equalTo: pButton.widthAnchor))
            }
            if index == total {
                buttonConstraints.append(button.rightAnchor.constraint(equalTo: container.rightAnchor))
            }
            
            if index != total {
                let layoutGuide = UILayoutGuide()
                button.addLayoutGuide(layoutGuide)
                buttonConstraints.append(layoutGuide.leftAnchor.constraint(equalTo: button.rightAnchor))
                if let pGuide = preGuide {
                    buttonConstraints.append(layoutGuide.widthAnchor.constraint(equalTo: pGuide.widthAnchor))
                }
                preGuide = layoutGuide
            }
            preButton = button
            container.addConstraints(buttonConstraints)
        }
    }

    @IBAction func tapToHide(_ sender: UIButton) {
        UIView.animate(withDuration: 0.35) {
            self.button.isHidden = !self.button.isHidden
            self.view.layoutIfNeeded()
        }
    }
}
