//
//  LayoutCycleViewController.swift
//  AutoLayout
//
//  Created by JiangWang on 2020/3/8.
//  Copyright © 2020 JiangWang. All rights reserved.
//

import UIKit

class LayoutCycleView: UIView {
    
    /// 名称
    var name = "NOT SET" {
        didSet {
            label.text = name
        }
    }
    
    let label = UILabel()
    var labelConstraints: [NSLayoutConstraint] = []
    
    // churn
    let text1 = UILabel()
    let text2 = UILabel()
    var myConstraints: [NSLayoutConstraint] = []
    
    override var bounds: CGRect {
        didSet {
            print("LayoutCycleView: \(name) \(#function) called")
        }
    }
    
    override var center: CGPoint {
        didSet {
            print("LayoutCycleView: \(name) \(#function) called")
        }
    }
    
    override var frame: CGRect {
        didSet {
            print("LayoutCycleView: \(name) \(#function) called")
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        NSLayoutConstraint.deactivate(labelConstraints)
        label.translatesAutoresizingMaskIntoConstraints = false
        labelConstraints = [label.leadingAnchor.constraint(equalTo: leadingAnchor),
                            label.trailingAnchor.constraint(equalTo: trailingAnchor),
                            label.topAnchor.constraint(equalTo: topAnchor),
                            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30)]
        NSLayoutConstraint.activate(labelConstraints)
       
        text1.translatesAutoresizingMaskIntoConstraints = false
        text2.translatesAutoresizingMaskIntoConstraints = false
        addSubview(text1)
        addSubview(text2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Contraints
    override func updateConstraints() {
        print("LayoutCycleView: \(name) \(#function) called")
        
        // churning
        NSLayoutConstraint.deactivate(myConstraints)
        myConstraints.removeAll()
        let views = ["text1":text1, "text2":text2]
        myConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-[text1]-[text2]",
                                                        options: [.alignAllFirstBaseline],
                                                        metrics: nil, views: views)
        myConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-[text1]-|",
                                                        options: [],
                                                        metrics: nil, views: views)
        NSLayoutConstraint.activate(myConstraints)
        super.updateConstraints()
    }
    
    override func setNeedsUpdateConstraints() {
        super.setNeedsUpdateConstraints()
        print("LayoutCycleView: \(name) \(#function) called")
    }
    
    override func updateConstraintsIfNeeded() {
        super.updateConstraintsIfNeeded()
        print("LayoutCycleView: \(name) \(#function) called")
    }
    
    //MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        print("LayoutCycleView: \(name) \(#function) called")
    }

    override func setNeedsLayout() {
        super.setNeedsLayout()
        print("LayoutCycleView: \(name) \(#function) called")
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        print("LayoutCycleView: \(name) \(#function) called")
    }
    
    //MARK: - Render
//    override func setNeedsDisplay() {
//        super.setNeedsDisplay()
//        print("LayoutCycleView: \(name) \(#function) called")
//    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        print("LayoutCycleView: \(name) \(#function) called")
    }
}

class LayoutCycleViewController: UIViewController {
    
    let testView = LayoutCycleView()
    
    var subview: LayoutCycleView?
    
    var constraintToUpdate: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(testView)
        testView.name = "Container"
        testView.backgroundColor = .brown
        testView.translatesAutoresizingMaskIntoConstraints = false
        let selfConstraints = [testView.widthAnchor.constraint(equalToConstant: 200),
                               testView.heightAnchor.constraint(equalToConstant: 400)]
        testView.addConstraints(selfConstraints)
        let otherConstraints = [testView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                                testView.centerXAnchor.constraint(equalTo: view.centerXAnchor)]
        view.addConstraints(otherConstraints)

        // subview
        let subview = LayoutCycleView()
        self.subview = subview
        subview.name = "subview"
        subview.backgroundColor = .red
        testView.addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint = subview.widthAnchor.constraint(equalToConstant: 100)
//        constraintToUpdate = widthConstraint
        let selfConstraintsSubview = [widthConstraint,
                               subview.heightAnchor.constraint(equalToConstant: 200)]
        subview.addConstraints(selfConstraintsSubview)
        let centerYAnchor = subview.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        constraintToUpdate = centerYAnchor
        let otherConstraintsSubview = [centerYAnchor,
                                subview.centerXAnchor.constraint(equalTo: view.centerXAnchor)]
        view.addConstraints(otherConstraintsSubview)

        //
//        scheduleContraintUpdate()
    }

    func scheduleContraintUpdate() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) { [weak self] in
            self?.constraintToUpdate?.constant = 30
//            self?.subview?.setNeedsDisplay()
            self?.subview?.setNeedsLayout()
        }
    }
    
    override func viewDidLayoutSubviews() {
        /*
         code ....
         */
        print("Controller \(#function) called")
        super.viewDidLayoutSubviews()
//        let constraints = testView.constraints
//        NSLayoutConstraint.deactivate(constraints)
//        testView.removeConstraints(constraints)
//        testView.addConstraints(constraints)
//        NSLayoutConstraint.activate(constraints)
//        view.layoutIfNeeded()
    }
}
