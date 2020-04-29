//
//  ManualShapeCircle.swift
//  Circle
//
//  Created by JiangWang on 2020/4/20.
//  Copyright © 2020 JiangWang. All rights reserved.
//

import UIKit

class ManualShapeCircle: UIView {

    /// 描述圈圈类型的视图
    struct Style: OptionSet {
        let rawValue: Int32
        
        /// 具有外框圈
        static let circle = Style(rawValue: 1 << 0)
        
        /// 具有中间聚焦
        static let focus = Style(rawValue: 1 << 1)
        
        /// 具有右侧的大小调节模块
        static let resize = Style(rawValue: 1 << 2)
        
        static let all: Style = [.circle, .focus, .resize]
    }
    
    /// pan手势的操作
    private enum PanOperation {
        case move
        case resize
    }
    
    struct LayoutParams {
        
        /// 圈圈的宽度
        let circleWidth: CGFloat = 2
        
        /// 最小宽高
        let minDimension: CGFloat = 20
        
        /// 中间focus的大小
        let focusDimension: CGFloat = 12
        
        /// 缩放视图的大小
        let resizeIndicatorDimension: CGFloat = 12
    }
    
    /// 布局参数
    let layoutParams = LayoutParams()
    
    /// 样式
    var style = Style.circle {
        didSet {
            guard oldValue != style else { return }
            updateUI()
        }
    }
   
    /// 默认的pan操作
    private var panOperation: PanOperation = .move
    
    /// 聚焦十字
    private lazy var focusLayer: CAShapeLayer = {
        let shape = CAShapeLayer()
        return shape
    }()
    
    /// 圈圈的层
    private let circleLayer = CAShapeLayer()
    
    /// 可以resize的指示图片
    private lazy var resizeImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "edit_circle_resize"))
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        updateUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        CATransaction.setDisableActions(true)
        updateCircle()
        layoutFocus()
        layoutResizeImageView()
        CATransaction.setDisableActions(false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - UI
private extension ManualShapeCircle {
    
    /// 根据style跟新ui的状态
    func updateUI() {
        
        /// 更新外圈
        updateCircle()
        
        /// 中间focus
        updateFoucs()
        
        /// 放大缩小的indicator
        updateResizeImageView()
    }
    
    func updateCircle() {
        guard style.contains(.circle) else {
            circleLayer.isHidden = true
            return
        }
        // 更新一下
        circleLayer.isHidden = false
        if circleLayer.superlayer == nil {
            layer.insertSublayer(circleLayer, at: 0)
        }
        let dimension = min(bounds.width, bounds.height) - layoutParams.circleWidth
        circleLayer.bounds = CGRect(x: 0, y: 0, width: dimension, height: dimension)
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        circleLayer.path = UIBezierPath(arcCenter: center, radius: dimension/2, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true).cgPath
        circleLayer.strokeColor = UIColor.white.cgColor
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineWidth = layoutParams.circleWidth
        circleLayer.frame = CGRect(x: (bounds.width - dimension)/2, y: (bounds.height - dimension)/2, width: dimension, height: dimension)
    }
    
    func updateFoucs() {
        guard style.contains(.focus) else {
            focusLayer.isHidden = true
            return
        }
        focusLayer.isHidden = false
        layoutFocus()
        layer.insertSublayer(focusLayer, above: circleLayer)
        let cross = UIBezierPath()
        //竖
        cross.move(to: CGPoint(x: focusLayer.bounds.midX, y: focusLayer.bounds.minY))
        cross.addLine(to: CGPoint(x: focusLayer.bounds.midX, y: focusLayer.bounds.maxY))
        //横
        cross.move(to: CGPoint(x: focusLayer.bounds.minX, y: focusLayer.bounds.midY))
        cross.addLine(to: CGPoint(x: focusLayer.bounds.maxX, y: focusLayer.bounds.midY))
        focusLayer.path = cross.cgPath
        focusLayer.strokeColor = UIColor.white.cgColor
        focusLayer.lineWidth = layoutParams.circleWidth
    }
    
    func layoutFocus() {
        CATransaction.setDisableActions(true)
        focusLayer.frame = CGRect(x: (bounds.width - layoutParams.focusDimension)/2, y: (bounds.height - layoutParams.focusDimension)/2, width: layoutParams.focusDimension, height: layoutParams.focusDimension)
        CATransaction.setDisableActions(false)
    }

    func updateResizeImageView() {
        guard style.contains(.resize) else {
            resizeImageView.removeFromSuperview()
            return
        }
        addSubview(resizeImageView)
        layoutResizeImageView()
    }
    
    func layoutResizeImageView() {
        resizeImageView.frame = CGRect(x: bounds.width - layoutParams.circleWidth/2 - layoutParams.resizeIndicatorDimension/2, y: (bounds.height - layoutParams.resizeIndicatorDimension)/2, width: layoutParams.resizeIndicatorDimension, height: layoutParams.resizeIndicatorDimension)
    }
}

//MARK: - UI
extension ManualShapeCircle {
    
    @objc func didLongPress(_ gesture: UILongPressGestureRecognizer) {
        print("变大变大变大")
    }
    
    @objc func didPan(_ gesture: UIPanGestureRecognizer) {
        
        // 处理拖拽的手势
        switch gesture.state {
        case .began:
            gesture.setTranslation(.zero, in: self)
            panOperation = panOperation(by: gesture)
        case .changed:
            operate(by: gesture)
        case .ended: fallthrough
        case .failed: fallthrough
        case .cancelled:
            operate(by: gesture)
        default:
            break
        }
    }
}


private extension ManualShapeCircle {
    
    private func panOperation(by pan: UIPanGestureRecognizer) -> PanOperation {
        let location = pan.location(in: self)
        let resizeRect = resizeImageView.frame.insetBy(dx: -20, dy: -20)
        return resizeRect.contains(location) ? .resize : .move
    }
    
    func operate(by gesture: UIPanGestureRecognizer) {
        switch panOperation {
        case .move:
            move(by: gesture)
        case .resize:
            resize(by: gesture)
        }
    }
    
    func move(by gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        let newFrame = CGRect(origin: CGPoint(x: frame.origin.x + translation.x, y: frame.origin.y + translation.y), size: frame.size)
        frame = newFrame
        gesture.setTranslation(.zero, in: self)
        setNeedsLayout()
    }
    
    func resize(by gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        let newFrame = frame.insetBy(dx: -translation.x, dy: -translation.x)
        guard newFrame.size.width >= layoutParams.minDimension &&
            newFrame.size.height >= layoutParams.minDimension else {
                gesture.setTranslation(.zero, in: self)
                return
        }
        frame = newFrame
        gesture.setTranslation(.zero, in: self)
        setNeedsLayout()
    }
}
