//
//  SliderView.swift
//  SliderView
//
//  Created by JiangWang on 2019/11/20.
//  Copyright © 2019 JiangWang. All rights reserved.
//

import UIKit

class SliderConfig: NSObject {
    
    /// 单位：默认为100
    var units: Int = 100
    
}

class SliderView: UIControl {
    
    /// 配置参数
    var config: SliderConfig?
    
    /// 当前值：为归一化的值
    private(set) var value: CGFloat = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - UI
extension SliderView {
    func setupUI() {
        
    }
}
