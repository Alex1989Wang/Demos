//
//  FocusView.swift
//  Camera360Units
//
//  Created by JiangWang on 2019/6/4.
//  Copyright © 2019 JiangWang. All rights reserved.
//

import UIKit

protocol FocusViewDelegate: NSObjectProtocol {
    
    /// 聚焦视图是否支持在lock的时候展示lens
    ///
    /// - Parameter focusView: focus view
    /// - Returns: 代理返回是否支持
    func canShowLens(in focusView: FocusView) -> Bool
    
    /// 聚焦视图是否支持展示blur
    ///
    /// - Parameter focusView: focus view
    /// - Returns: 代理返回是否支持
    func canShowBlur(in focusView: FocusView) -> Bool
}

class FocusView: UIView {
    
    enum FocusAnimationType: Int {
        case autoFocus = 1
        case manualFocus = 2
        case lockFocus = 3
    }

    /// UI元素缩放比例
    static let ratio = UIScreen.main.bounds.width/CGFloat(320) //iphone4
    static let focusRadius = FocusView.ratio * 40
    static let squareWidth = FocusView.ratio * 90
    
    /// 长按聚焦圈的完成动画
    static let longPressAnimationDuration: CFTimeInterval = 1.0
    
    /// 是否是锁定的状态
    public var isLocked: Bool
    
    /// 代理
    public weak var delegate: FocusViewDelegate?
    
    /// lens position的值
    private var _lensPosition: CGFloat

    
    /// <#Description#>
    private var blurMagnitude: CGFloat {
        didSet {
            guard blurMagnitude != oldValue else { return }
            guard let _ = blurLayer.superlayer else { return }
            blurLayer.path = renewedBlurPath().cgPath
        }
    }

    /// 聚焦圈
    private let focusCircleLayer = CAShapeLayer()
    
    /// 聚焦圈外围的（上、左、下、右）的横线
    private let fourDotsLayer = CAShapeLayer()
    
    /// 聚焦圈中间的 [ ] 图形
    private let focusCenterLayer = CAShapeLayer()
    
    /// 镜头position值的滑竿layer
    private let lensLayer = CAShapeLayer()

    /// blur圈
    private let blurLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        isLocked = false
        lensPosition = 0.5
        blurMagnitude = 2
        super.init(frame: frame)
        self.frame = frame
        backgroundColor = UIColor.clear
        isUserInteractionEnabled = false
        clipsToBounds = false
        setupLayers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        isLocked = false
        lensPosition = 0.5
        blurMagnitude = 2
        super.init(coder: aDecoder)
        fatalError("not implemented")
    }
}


// MARK: - Pubblic
extension FocusView {
    
    public var lensPosition: CGFloat {
        set {
            guard lensPosition != oldValue else { return }
            guard let _ = lensLayer.superlayer else { return }
            lensLayer.path = renewedLensPath().cgPath
        }
    }
    
    public func show(type: FocusAnimationType, animated: Bool = true) {
        switch type {
        case .autoFocus:
            showAutoFocus(animated: animated)
        case .manualFocus:
            showManualFocus(animated: animated)
        case .lockFocus:
            showLockFocus(animated: animated)
        }
    }
    
    public func showLongPressAnimation() {
        animateLongPress()
    }
    
    public func updateLens(position: CGFloat) {
        lensPosition = max(min(position, 1), 0)
    }
    
    public func updateBlur(magnitude: CGFloat) {
        blurMagnitude = max(2, min(5.5, magnitude))
    }
    
    public func reset() {
        layer.sublayers?.forEach({ sublayer in sublayer.removeFromSuperlayer() })
        focusCircleLayer.path = focusCirclePath().cgPath
        [focusCircleLayer, fourDotsLayer, focusCenterLayer].forEach { (sublayer) in
            sublayer.frame = bounds
            layer.addSublayer(sublayer)
        }
    }
}


// MARK: - Animation
fileprivate extension FocusView {
    
    func showAutoFocus(animated: Bool = true) {
        reset()

        guard animated else { return }
        CATransaction.begin()
        let keyTimes = [0, (5.0/10), (8.0/10), 1] as [NSNumber]
        
        let centerOpacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        centerOpacityAnimation.values = [0, 1, 1, 0.4]
        centerOpacityAnimation.keyTimes = keyTimes
        centerOpacityAnimation.duration = 0.5;
        focusCenterLayer.add(centerOpacityAnimation, forKey: "centerOpacityAnimation")
        
        let circleScale = CAKeyframeAnimation(keyPath: "transform.scale")
        circleScale.values = [2, 0.9, 1.05, 1];
        circleScale.keyTimes = keyTimes
        
        let circleLineWidth = CAKeyframeAnimation(keyPath: "lineWidth")
        circleLineWidth.values = [0.5, 1.5, 1, 1.5];
        circleLineWidth.keyTimes = keyTimes
        
        let circleOpacity = CAKeyframeAnimation(keyPath: "opacity")
        circleOpacity.values = [0, 1, 1, 1];
        circleOpacity.keyTimes = keyTimes
        
        let circleGroup = CAAnimationGroup()
        circleGroup.animations = [circleScale, circleLineWidth, circleOpacity]
        circleGroup.duration = 0.5;
        focusCircleLayer.add(circleGroup, forKey: "autoFocusCircleAnimation")
        
        let fourDotAinmation = centerOpacityAnimation.mutableCopy() as! CAAnimation
        fourDotsLayer.add(fourDotAinmation, forKey: "fourDotsOpacityAnimation")
        
        CATransaction.commit()
    }
    
    func showManualFocus(animated: Bool = true) {

        reset()

        guard animated else { return }
        CATransaction.begin()
        let keyTimes = [0, (2.0/7), (3.0/7), 1] as [NSNumber]
        
        let centerOpacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        centerOpacityAnimation.values = [1, 1, 1, 0.4];
        centerOpacityAnimation.keyTimes = keyTimes
        centerOpacityAnimation.duration = 7.0/20;
        focusCenterLayer.add(centerOpacityAnimation, forKey: "centerOpacityAnimation")
        
        let circleScale = CAKeyframeAnimation(keyPath: "transform.scale")
        circleScale.values = [1.5, 1]
        circleScale.keyTimes = [0, 1] as [NSNumber]
        
        let circleOpacity = CAKeyframeAnimation(keyPath: "opacity")
        circleOpacity.values = [0.3, 1]
        circleOpacity.keyTimes = [0, 1] as [NSNumber]
        
        let circleGroup = CAAnimationGroup()
        circleGroup.animations = [circleScale, circleOpacity]
        circleGroup.duration = 2.0/20
        focusCircleLayer.add(circleGroup, forKey: "manualFocusCircleAnimation")
        
        let fourDotAinmation = centerOpacityAnimation.mutableCopy() as! CAKeyframeAnimation
        fourDotAinmation.values = [0, 0, 0.1, 1]
        fourDotsLayer.add(fourDotAinmation, forKey: "fourDotsOpacityAnimation")
        
        CATransaction.commit()
    }
    
    func showLockFocus(animated: Bool) {
        
        layer.sublayers?.forEach({ sublayer in sublayer.removeFromSuperlayer() })
        focusCircleLayer.frame = bounds
        layer.addSublayer(focusCircleLayer)

        //由圈->正方形
        focusCircleLayer.path = focusCirclePath().cgPath //最初形态
        
        CATransaction.begin()
        CATransaction.setCompletionBlock { [weak self] in
            
            guard let _self = self else { return }
            let center = CGPoint(x: _self.bounds.midX, y: _self.bounds.midY)
            let squareRect = CGRect(x: center.x - FocusView.squareWidth/2,
                                    y: center.y - FocusView.squareWidth/2,
                                    width: FocusView.squareWidth,
                                    height: FocusView.squareWidth)
            let squarePath = UIBezierPath(roundedRect: squareRect, cornerRadius: 1) //需要给一个很小的圆角不然，pathChange动画会错乱
            let roundPath = UIBezierPath(roundedRect: squareRect, cornerRadius: FocusView.squareWidth/2)
            
            _self.focusCircleLayer.path = squarePath.cgPath
            
            //第二组动画
            let pathChangeAnim = CABasicAnimation(keyPath: "path")
            pathChangeAnim.fromValue = roundPath.cgPath
            pathChangeAnim.toValue = squarePath.cgPath
            pathChangeAnim.duration = 0.15
            pathChangeAnim.fillMode = .forwards
            _self.focusCircleLayer.add(pathChangeAnim, forKey: "pathChangeAnim")
            
            if let showLens = _self.delegate?.canShowLens(in: _self),
                showLens {
                _self.layer.addSublayer(_self.lensLayer)
                _self.lensLayer.path = _self.renewedLensPath().cgPath
                let lensScaleAnim = CABasicAnimation(keyPath: "transform.scale")
                lensScaleAnim.duration = 0.15
                lensScaleAnim.fromValue = 0
                lensScaleAnim.toValue = 1
                
                let lensOpacityAnim = CABasicAnimation(keyPath: "opacity")
                lensOpacityAnim.duration = 0.15
                lensOpacityAnim.fromValue = 0
                lensOpacityAnim.toValue = 1
                
                let lensGroupAnim = CAAnimationGroup()
                lensGroupAnim.animations = [lensScaleAnim, lensOpacityAnim]
                lensGroupAnim.duration = 0.15
                _self.lensLayer.add(lensGroupAnim, forKey: "lensGroupAnim")
            }
            
            if let showBlur = _self.delegate?.canShowBlur(in: _self),
                showBlur {
                _self.blurLayer.path = _self.renewedBlurPath().cgPath
                _self.layer.addSublayer(_self.blurLayer)
            }
        }
        
        //第一组动画
        let circleWidthAnim = CAKeyframeAnimation(keyPath: "lineWidth")
        circleWidthAnim.values = [1.5, 2]
        circleWidthAnim.keyTimes = [0, 1]
        circleWidthAnim.duration = 0.15
        focusCircleLayer.add(circleWidthAnim, forKey: "circleWidthAnim")
        CATransaction.commit()
        
    }
    
    func animateLongPress() {
        
        layer.sublayers?.forEach({ sublayer in sublayer.removeFromSuperlayer() })
        focusCircleLayer.path = focusCirclePath().cgPath
        focusCircleLayer.frame = bounds
        layer.addSublayer(focusCircleLayer)

        CATransaction.begin()

        let circleAnimation = CABasicAnimation(keyPath: "strokeEnd") //完成一圈的动画
        circleAnimation.fromValue = 0
        circleAnimation.toValue = 1
        circleAnimation.duration = FocusView.longPressAnimationDuration
        focusCircleLayer.add(circleAnimation, forKey: "circleAnimation")

        CATransaction.commit()
    }
}


// MARK: - UI Setup
fileprivate extension FocusView {
    func setupLayers() {
        
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let focusRadius = FocusView.focusRadius

        //聚焦圈
        focusCircleLayer.path = focusCirclePath().cgPath
        focusCircleLayer.frame = bounds
        focusCircleLayer.strokeColor = UIColor.yellow.cgColor
        focusCircleLayer.fillColor = UIColor.clear.cgColor
        focusCircleLayer.lineWidth = 1.5

        //左、下、右、上的点||需要和聚焦圈分开绘制
        let fourDashPath = UIBezierPath()
        let dashLength = 5.0 * FocusView.ratio
        fourDashPath.move(to: CGPoint(x: center.x, y: center.y - focusRadius)) //顶
        fourDashPath.addLine(to: CGPoint(x: center.x, y: center.y - focusRadius + dashLength))
        fourDashPath.move(to: CGPoint(x: center.x - focusRadius, y: center.y)) //左
        fourDashPath.addLine(to: CGPoint(x: center.x - focusRadius + dashLength, y: center.y))
        fourDashPath.move(to: CGPoint(x: center.x, y: center.y + focusRadius)) //底
        fourDashPath.addLine(to: CGPoint(x: center.x, y: center.y + focusRadius - dashLength))
        fourDashPath.move(to: CGPoint(x: center.x + focusRadius - dashLength, y: center.y)) //右
        fourDashPath.addLine(to: CGPoint(x: center.x + focusRadius, y: center.y))
        fourDotsLayer.path = fourDashPath.cgPath
        fourDotsLayer.frame = bounds
        fourDotsLayer.strokeColor = UIColor.yellow.cgColor
        fourDotsLayer.fillColor = UIColor.clear.cgColor
        fourDotsLayer.lineWidth = 1

        //聚焦圈中间的 [ ] 图形
        let centerWidth = 14 * FocusView.ratio
        let centerHalfWidth = 4 * FocusView.ratio
        let centerHeight = 10 * FocusView.ratio

        let focusCenterPath = UIBezierPath()
        //左半边 [
        focusCenterPath.move(to: CGPoint(x: center.x - (centerWidth - centerHalfWidth)/2, y: center.y - centerHeight/2))
        focusCenterPath.addLine(to: CGPoint(x: center.x - centerWidth/2, y: center.y - centerHeight/2))
        focusCenterPath.addLine(to: CGPoint(x: center.x - centerWidth/2, y: center.y + centerHeight/2))
        focusCenterPath.addLine(to: CGPoint(x: center.x - (centerWidth - centerHalfWidth)/2, y: center.y + centerHeight/2))
        //右半边 ]
        focusCenterPath.move(to: CGPoint(x: center.x + (centerWidth - centerHalfWidth)/2, y: center.y - centerHeight/2))
        focusCenterPath.addLine(to: CGPoint(x: center.x + centerWidth/2, y: center.y - centerHeight/2))
        focusCenterPath.addLine(to: CGPoint(x: center.x + centerWidth/2, y: center.y + centerHeight/2))
        focusCenterPath.addLine(to: CGPoint(x: center.x + (centerWidth - centerHalfWidth)/2, y: center.y + centerHeight/2))
        focusCenterLayer.path = focusCenterPath.cgPath
        focusCenterLayer.frame = bounds
        focusCenterLayer.strokeColor = UIColor.yellow.cgColor
        focusCenterLayer.fillColor = UIColor.clear.cgColor
        focusCenterLayer.lineWidth = 1
        focusCenterLayer.opacity = 0.8
        
        //矩形聚焦中间的lens视图：-----||-----
        lensLayer.path = renewedLensPath().cgPath
        lensLayer.strokeColor = UIColor.yellow.cgColor
        lensLayer.fillColor = UIColor.yellow.cgColor
        lensLayer.fillRule = .evenOdd
        lensLayer.lineWidth = 0.5
        lensLayer.frame = self.bounds;
        
        //blur圈
        blurLayer.path = renewedBlurPath().cgPath
        blurLayer.strokeColor = UIColor.yellow.cgColor
        blurLayer.fillColor = UIColor.clear.cgColor
        blurLayer.lineWidth = 0.8;
        blurLayer.lineDashPattern = [10, 10]
        blurLayer.frame = self.bounds
    }
    
    func renewedLensPath() -> UIBezierPath {
        
        //矩形聚焦中间的lens视图：-----||-----
        let squareWidth = FocusView.ratio * 90
        let lensBarWidth = squareWidth * 0.9
        let vertBarHeight = FocusView.ratio * 12
        let vertBarWidth = FocusView.ratio * 4
        
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let lensPath = UIBezierPath()
        //横线
        lensPath.move(to: CGPoint(x: center.x - squareWidth/2, y: center.y + squareWidth/4))
        lensPath.addLine(to: CGPoint(x: center.x + squareWidth/2, y: center.y + squareWidth/4))
        //竖线
        lensPath.move(to: CGPoint(x: center.x - lensBarWidth/2 + lensBarWidth * lensPosition, y: center.y + squareWidth/4 - vertBarHeight/2))
        lensPath.addLine(to: CGPoint(x: center.x - lensBarWidth/2 + lensBarWidth * lensPosition, y: center.y + squareWidth/4 + vertBarHeight/2))
        let vertRect = CGRect(x: center.x - lensBarWidth/2 + lensBarWidth * lensPosition,
                              y: center.y + squareWidth/4 - vertBarHeight/2,
                              width: vertBarWidth,
                              height: vertBarHeight)
        let vertPath = UIBezierPath(rect: vertRect)
        lensPath.append(vertPath)
        
        return lensPath
    }
    
    func renewedBlurPath() -> UIBezierPath {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        return UIBezierPath.init(arcCenter: center,
                                 radius: FocusView.focusRadius * blurMagnitude,
                                 startAngle: 0,
                                 endAngle: CGFloat(Double.pi * 2),
                                 clockwise: true)
    }
    
    func focusCirclePath() -> UIBezierPath {
        let focusRadius = FocusView.focusRadius
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        //从顶部开始画-长按动画strokeEnd依赖这个StartAngle
        return UIBezierPath(arcCenter: center,
                            radius: focusRadius,
                            startAngle: CGFloat(Double.pi * 1.5),
                            endAngle: CGFloat(Double.pi * 3.5),
                            clockwise: true)
    }
}


// MARK: - overrides
extension FocusView {
    
    /// clipsToBounds应该为flase
    override var clipsToBounds: Bool {
        set {
            super.clipsToBounds = false
        }
        get {
            return super.clipsToBounds
        }
    }
    
    /// 只需要squareRect大小
    override var frame: CGRect {
        set {
            let center = CGPoint(x: newValue.midX, y: newValue.midY)
            let minRect = CGRect(x: center.x - FocusView.squareWidth/2,
                                 y: center.y - FocusView.squareWidth/2,
                                 width: FocusView.squareWidth,
                                 height: FocusView.squareWidth)
            super.frame = minRect
        }
        get {
            return super.frame
        }
    }
    
    /// 只需要squareRect大小
    override var bounds: CGRect {
        set {
            let center = CGPoint(x: newValue.midX, y: newValue.midY)
            let minRect = CGRect(x: center.x - FocusView.squareWidth/2,
                                 y: center.y - FocusView.squareWidth/2,
                                 width: FocusView.squareWidth,
                                 height: FocusView.squareWidth)
            super.bounds = minRect
        }
        get {
            return super.bounds
        }
    }
}
