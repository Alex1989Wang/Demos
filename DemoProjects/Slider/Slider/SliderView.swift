//
//  SliderView.swift
//  Slider
//
//  Created by JiangWang on 2020/4/9.
//  Copyright © 2020 JiangWang. All rights reserved.
//

import UIKit

/// 用在美妆||滤镜||编辑内部的slider
class SliderView: UIControl {
    
    /// 当前滑竿的value值，默认为0.0；会被最大最小值截断
    var value: CGFloat
    private var innerValue: CGFloat //不会因为damping而被截断

    /// 滑竿最小值：默认0
    var minimumValue: CGFloat
    
    /// 滑竿最大值：默认100
    var maximumValue: CGFloat
    
    /// 当前的默认值。默认为0。
    var defaultValue: CGFloat
    
    /// 是否在默认值附近展示小点
    var showDefaultValueIndicator: Bool = true {
        didSet {
            defaultPointLayer?.isHidden = !showDefaultValueIndicator
        }
    }
    
    /// 是否展示中点位置。主要应用于[-100, 100]的滑竿，既要展示中点，又有一个比如30的默认值点。
    var showCenter: Bool = false {
        didSet {
            centerPointLayer?.isHidden = !showCenter
        }
    }
    
    /// 滑竿触点颜色
    var thumbColor: UIColor?
    
    /// 事件回调的颗粒度。默认为零，和touch事件的调用一致。
    var step: CGFloat
    
    /// 滑竿上部的气泡提示
    var showBubbleTip: Bool = true
    
    /// 值改变的回调
    var valueChanged: ((CGFloat)->Void)? = nil
    
    /// tip的UI
    private let tipImageView = UIImageView()
    private let tipLabel = UILabel()
    
    /// 滑竿的杆子
    private var trackLayer: CALayer!
    
    /// 带色彩的杆子视图，随着thumbView的位置变化而变化
    /// 如果展示中点位置，会以中点向左向右布局
    private var valueLayer: CALayer!

    /// 滑竿滑动指示器视图
    private var thumbView: UIView!
    private var thumbXConstraint: NSLayoutConstraint? = nil
    
    /// 中间的展示
    private var centerPointLayer: CALayer?
    
    /// 默认值点的展示
    private var defaultPointLayer: CALayer?
    
    /// 需要在默认值附近震感反馈
    /// 同样在震感附近有值的阻尼行为
    var enableDefaultValueFeedback: Bool = true

    /// 震感
    private var feedbacked: Bool = false //用于damping过程过滤一次震感
    private var impactGenerator: UIImpactFeedbackGenerator?
    
    /// 大致的大小
    override var intrinsicContentSize: CGSize {
        get {
            return CGSize(width: UIView.noIntrinsicMetric, height: 44)
        }
    }
    
    override init(frame: CGRect) {
        value = 0
        innerValue = 0
        minimumValue = 0
        maximumValue = 100
        step = maximumValue/100
        defaultValue = 0
        super.init(frame: frame)
        setupUIs()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutTracks()
        layoutThumbX()
        layoutCheckpoints()
    }
}

//MARK: - Events
extension SliderView {
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        var possible = sliderValue(for: touch)
        // 重置tip的状态
        tipImageView.alpha = 1
        tipImageView.isHidden = !showBubbleTip
        // 判断是否只是触发了微调
        let (trigger, left) = triggerStep(for: touch)
        if trigger {
            possible = left ? value - step : value + step
            sliderValueChanged(to: possible)
            // 返回
            return super.beginTracking(touch, with: event)
        }
        // 是否产生阻尼
        let isDamping = shouldFeedbackDefaultValue(for: possible)
        if isDamping {
            // 重置值
            possible = defaultValue
            if !feedbacked {
                feedback()
                feedbacked = true
            }
        }
        else {
            feedbacked = false
        }
        // 触发正常滑动，按照步长过滤
        sliderValueChanged(to: possible.filter(by: step))
        return super.beginTracking(touch, with: event)
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        var possible = sliderValue(for: touch)
        // 是否产生阻尼
        let isDamping = shouldFeedbackDefaultValue(for: possible)
        if isDamping {
            // 重置值
            possible = defaultValue
            if !feedbacked {
                feedback()
                feedbacked = true
            }
        }
        else {
            feedbacked = false
        }
        // 触发正常滑动
        sliderValueChanged(to: possible.filter(by: step))
        return super.continueTracking(touch, with: event)
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        if let t = touch {
            let possible = sliderValue(for: t).filter(by: step)
            sliderValueChanged(to: possible)
        }
        // 隐藏tip
        hideTip()
        return super.endTracking(touch, with: event)
    }
}

//MARK: - UIs
private extension SliderView {
    func setupUIs() {
        trackLayer = CALayer()
        trackLayer.cornerRadius = 1.3
//        trackLayer.backgroundColor = COLOR_WITH_HEXA(0xCCCCCC, 0.3)
        trackLayer.backgroundColor = UIColor.gray.cgColor
        layer.addSublayer(trackLayer)

        valueLayer = CALayer()
        valueLayer.cornerRadius = 1.3
        //        trackLayer.backgroundColor = COLOR_WITH_HEXA(0xCCCCCC, 0.3)
        valueLayer.backgroundColor = UIColor.yellow.cgColor
        layer.addSublayer(valueLayer)

        layoutTracks()
        
        // 添加中点||默认值点
        // 在设计上大小不一样：默认值点稍大
        layoutCheckpoints()

        // 触点
        thumbView = UIView(frame: .zero)
        thumbView.isUserInteractionEnabled = false
        thumbView.translatesAutoresizingMaskIntoConstraints = false
//        thumbView.backgroundColor = COLOR_WITH_HEX(0xFCCF2b)
        thumbView.backgroundColor = UIColor.yellow
        thumbView.isUserInteractionEnabled = false
        thumbView.clipsToBounds = true
        thumbView.layer.cornerRadius = 8
        addSubview(thumbView)
        var thumbConstraints = [thumbView.centerYAnchor.constraint(equalTo: centerYAnchor),
                                thumbView.widthAnchor.constraint(equalToConstant: 16),
                                thumbView.heightAnchor.constraint(equalToConstant: 16)]
        let xConstraint = thumbView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0)
        thumbXConstraint = xConstraint
        thumbConstraints.append(xConstraint)
        addConstraints(thumbConstraints)
        layoutThumbX()
       
        tipLabel.translatesAutoresizingMaskIntoConstraints = false
        tipImageView.translatesAutoresizingMaskIntoConstraints = false
        tipImageView.addSubview(tipLabel)
        tipImageView.backgroundColor = UIColor.yellow
        tipLabel.backgroundColor = .black
        addSubview(tipImageView)
        let tipLabelCons = [tipLabel.centerYAnchor.constraint(equalTo: tipImageView.centerYAnchor),
                            tipLabel.centerXAnchor.constraint(equalTo: tipImageView.centerXAnchor)]
        tipImageView.alpha = 0
        let tipImageViewCons = [tipImageView.centerXAnchor.constraint(equalTo: thumbView.centerXAnchor),
                                tipImageView.bottomAnchor.constraint(equalTo: thumbView.topAnchor, constant: -8),
                                tipImageView.widthAnchor.constraint(equalToConstant: 33),
                                tipImageView.heightAnchor.constraint(equalToConstant: 44)]
        tipImageView.addConstraints(tipLabelCons)
        addConstraints(tipImageViewCons)
    }
    
    func layoutTracks() {
        //背景track
        let trackH: CGFloat = 3
        let trackFrame = CGRect(x: 0, y: (bounds.height - trackH)/2, width: bounds.width, height: trackH)
        trackLayer.frame = trackFrame
        
        //带色的value
        assert(maximumValue > minimumValue)
        var valueFrame: CGRect = .zero
        if showCenter {
            let center = (minimumValue + maximumValue)/2
            let offsetRatio = (value - center)/(maximumValue - minimumValue)
            let offset = offsetRatio * bounds.width
            let xStart = trackFrame.midX + (offset <= 0 ? offset : 0)
            valueFrame = CGRect(x: xStart, y: trackFrame.minY, width: abs(offset), height: trackFrame.height)
        }
        else {
            let valueRatio = (value - minimumValue)/(maximumValue - minimumValue)
            let width = bounds.width * valueRatio
            valueFrame = CGRect(x: 0, y: trackFrame.minY, width: width, height: trackFrame.height)
        }
        valueLayer.frame = valueFrame
    }
    
    func layoutThumbX() {
        let center = (minimumValue + maximumValue)/2
        let offsetRatio = (value - center)/(maximumValue - minimumValue)
        let offset = offsetRatio * bounds.width
        thumbXConstraint?.constant = offset
    }
    
    func layoutCheckpoints() {
        // 中点
        layoutCenterPoint()

        // 默认值点
        layoutDefaultPoint()
    }
    
    func layoutCenterPoint() {
        centerPointLayer?.isHidden = true
        guard showCenter else { return }
        if centerPointLayer == nil {
            centerPointLayer = CALayer()
        }
        if let ly = centerPointLayer {
            layer.insertSublayer(ly, above: trackLayer)
            let dimension: CGFloat = 6
            let rect = CGRect(x: trackLayer.frame.midX - dimension/2, y: trackLayer.frame.midY - dimension/2, width: dimension, height: dimension)
            ly.cornerRadius = dimension/2
            ly.frame = rect
        }
        centerPointLayer?.isHidden = false
//        centerPointLayer?.backgroundColor = COLOR_WITH_HEX(0xF0BC00).CGColor
        centerPointLayer?.backgroundColor = UIColor.yellow.cgColor
    }
    
    func layoutDefaultPoint() {
        defaultPointLayer?.isHidden = true
        guard showDefaultValueIndicator else { return }
        if defaultPointLayer == nil {
            defaultPointLayer = CALayer()
        }
        if let ly = defaultPointLayer {
            layer.insertSublayer(ly, above: trackLayer)
            let dimension: CGFloat = 7
            assert(maximumValue > minimumValue)
            let xOffset = (defaultValue - minimumValue)/(maximumValue - minimumValue) * trackLayer.bounds.width
            let rect = CGRect(x: xOffset - dimension/2, y: trackLayer.frame.midY - dimension/2, width: dimension, height: dimension)
            ly.frame = rect
            ly.cornerRadius = dimension/2
        }
        defaultPointLayer?.isHidden = false
        //        centerPointLayer?.backgroundColor = COLOR_WITH_HEX(0xF0BC00).CGColor
        defaultPointLayer?.backgroundColor = UIColor.yellow.cgColor
    }
    
    func relayouts() {
        CATransaction.setDisableActions(true)
        layoutTracks()
        layoutThumbX()
        CATransaction.setDisableActions(false)
    }
    
    @objc func flashTip() {
        guard showBubbleTip else {
            tipImageView.alpha = 0
            tipImageView.isHidden = true
            return
        }
        // 反向隐藏
        tipImageView.isHidden = false
        tipImageView.alpha = 1
        UIView.animate(withDuration: 0.2, animations: {
            self.tipImageView.alpha = 0
        }, completion: { [weak self] (_) in
            self?.tipImageView.isHidden = true
        })
    }
    
    func hideTip() {
        UIView.animate(withDuration: 0.3, delay: 0.5, animations: {
            self.tipImageView.alpha = 0
        }, completion: { [weak self] (_) in
            self?.tipImageView.isHidden = true
        })
    }
}

//MARK: - Calculate
private extension SliderView {
    
    /// 根据手指滑动计算当前的slider的值
    /// - Parameter touch: touch事件
    func sliderValue(for touch: UITouch) -> CGFloat {
        let thisLocation = touch.location(in: self)
        let preLocation = touch.previousLocation(in: self)
        let xMovement = thisLocation.x - preLocation.x
        innerValue = xMovement/trackLayer.bounds.width * (maximumValue - minimumValue) + innerValue
        return innerValue
    }
    
    /// 点击滑竿的左边||或者右边位置可以微调
    /// - Parameter touch: touch事件
    func triggerStep(for touch: UITouch) -> (trigger: Bool, left: Bool) {
        let location = touch.location(in: self)
        let thumbRect = thumbView.frame.insetBy(dx: -15, dy: -15)
        guard !thumbRect.contains(location) else { return (false, false) }
        // 动画一下
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(flashTip), object: nil)
        perform(#selector(flashTip), with: nil, afterDelay: 0.2)
        return (true, thumbRect.minX >= location.x)
    }
    
    func sliderValueChanged(to newValue: CGFloat) {
        let trim = max(min(maximumValue, newValue), minimumValue)
        guard trim != value else { return }
        value = trim
        tipLabel.text = "\(Int(value))"
        valueChanged?(value)
        relayouts()
    }
    
    func shouldFeedbackDefaultValue(for value: CGFloat) -> Bool {
        // 默认值反馈: 必须要展示默认值小点&&开启震感
        guard enableDefaultValueFeedback, showDefaultValueIndicator else { return false }
        guard maximumValue > minimumValue else { return false }
        // 认为在归一化之后默认值附近+-1%的范围
        let range = abs((value - defaultValue)/(maximumValue - minimumValue))
        return range <= 0.01
    }
    
    func feedback() {
        if #available(iOS 10.0, *) {
            if let generator = impactGenerator {
                generator.impactOccurred()
                return
            }
            let impactor = UIImpactFeedbackGenerator(style: .light)
            impactGenerator = impactor
            impactor.impactOccurred()
        }
    }
}

extension CGFloat {
    /// 使用步长过滤
    /// - Parameter step: 步长
    func filter(by step: CGFloat) -> CGFloat {
        guard step > 0 else { return self }
        return (self/step).rounded(.towardZero) * step
    }
}
