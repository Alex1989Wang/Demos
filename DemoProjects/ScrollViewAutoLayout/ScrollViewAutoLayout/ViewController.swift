//
//  ViewController.swift
//  ScrollViewAutoLayout
//
//  Created by JiangWang on 2020/2/10.
//  Copyright © 2020 JiangWang. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    /// 滑动的视图
    private let scrollContainer = UIScrollView()
    
    /// 所有内容视图
    private let contentContainer = UIView()
    
    private let subscribeBtn = UIButton()
    
    private var contentsView: UIView!

    /// text view
    let bottomTextView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
}

//MARK: - UI
extension ViewController {
    
    private func setupSubviews() {
        
        // 滚动的容器
        scrollContainer.frame = view.bounds
        scrollContainer.showsHorizontalScrollIndicator = false
        if #available(iOS 11.0, *) {
            scrollContainer.contentInsetAdjustmentBehavior = .never
        }
        view.addSubview(scrollContainer)
        scrollContainer.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        scrollContainer.addSubview(contentContainer)
        contentContainer.snp.makeConstraints { (maker) in
            maker.left.right.equalToSuperview()
            maker.top.equalToSuperview().offset(64)
            maker.width.equalTo(view.snp.width)
            maker.bottom.equalToSuperview() //content size
        }
        
        // 标题部分
        let title = UIView().then { (titleView) in
            contentContainer.addSubview(titleView)
            titleView.snp.makeConstraints { maker in
                maker.left.equalToSuperview().offset(34.5)
                maker.right.equalToSuperview().offset(-34.5)
                maker.top.equalToSuperview()
            }
            
            // 主标题
            let mainLabel = UILabel().then {
                $0.textColor = .black
                $0.textAlignment = .left
                $0.font = UIFont(name: "PingFangSC-Semibold", size: 27)
                $0.minimumScaleFactor = 0.5
                $0.adjustsFontSizeToFitWidth = true
                $0.text = "CAMERA360 VIP"
                
                titleView.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.left.equalToSuperview()
                    make.top.equalToSuperview().offset(18)
                }
            }
            
            // 气泡图片的内容支撑整个title部分
            let _ = UIImageView().then {
                $0.image = UIImage(named: "qiu")
                
                titleView.addSubview($0)
                $0.snp.makeConstraints { maker in
                    maker.top.bottom.equalToSuperview()
                    maker.left.equalTo(mainLabel.snp.right).offset(-35)
                    maker.right.lessThanOrEqualToSuperview()
                }
            }
            
            // 副标题
            let _ = UILabel().then {
                $0.textColor = .black
                $0.textAlignment = .left
                $0.font = UIFont(name: "PingFangSC-Regular", size: 15)
                $0.minimumScaleFactor = 0.5
                $0.adjustsFontSizeToFitWidth = true
                $0.numberOfLines = 0 //不同的多语言可能多行
                $0.text = "i18n_952_VIP权益副标题内容"
                
                titleView.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.left.equalTo(mainLabel)
                    make.right.lessThanOrEqualToSuperview()
                    make.top.equalTo(mainLabel.snp.bottom).offset(8)
                }
            }
        }
        
        // 50%减价部分
        let offContainer = UIView().then { (container) in
            contentContainer.addSubview(container)
            container.snp.makeConstraints({ (maker) in
                maker.top.equalTo(title.snp.bottom).offset(8)
                maker.left.right.equalToSuperview()
            })
            
            let imageView = UIImageView().then { (view) in
                view.image = UIImage(named: "vip-50-percent-off")
                
                view.sizeToFit()
                container.addSubview(view)
                view.snp.makeConstraints({ (maker) in
                    maker.top.centerX.equalToSuperview()
                })
            }
            
            // 50% label
            let _ = UILabel().then {
                $0.textColor = .white
                $0.backgroundColor = .black
                $0.textAlignment = .center
                $0.font = UIFont(name: "PingFangSC-Regular", size: 12)
                $0.minimumScaleFactor = 0.5
                $0.adjustsFontSizeToFitWidth = true
                $0.numberOfLines = 0
                $0.text = "续费专享  优惠仅限3天"
                $0.layer.cornerRadius = 4.5
                $0.layer.masksToBounds = true
                
                container.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.left.equalTo(imageView.snp.left).offset(-14)
                    make.right.equalTo(imageView.snp.right).offset(14)
                    make.top.equalTo(imageView.snp.bottom)
                    make.height.equalTo(24)
                    make.bottom.equalToSuperview()
                }
            }
        }
        
        // 倒计时
        let countdownView = UIView().then { [weak self] (container) in
            contentContainer.addSubview(container)
            container.snp.makeConstraints({ (maker) in
                maker.top.equalTo(offContainer.snp.bottom).offset(9)
                maker.centerX.equalToSuperview()
                maker.height.equalTo(24)
            })
            
            let remainDaysLabel = UILabel().then {
                $0.font = UIFont(name: "PingFangSC-Regular", size: 12)
                $0.textColor = .black
                $0.textAlignment = .center
                $0.text = "Ends in 10days"
                
                container.addSubview($0)
                $0.snp.makeConstraints { (maker) in
                    maker.bottom.top.left.equalToSuperview()
                    maker.right.equalToSuperview()
                }
            }
            
        }
        
        // 滚动vip权益
        let width = view.bounds.width - 50 * 2
        contentsView = UIView().then {
            contentContainer.addSubview($0)
            $0.backgroundColor = .red
            $0.snp.makeConstraints { maker in
                maker.top.equalTo(countdownView.snp.bottom).offset(13)
                maker.width.equalTo(width)
                maker.height.equalTo(130)
                maker.centerX.equalToSuperview()
            }
        }
    }
}

//MARK: - Overrides
extension ViewController {
    
    func setupUI() {
        //自己的UI
        setupSubviews()
        //继承的super || 重写
        layoutSubscibeButton()
        layoutBottomTextView()
    }
    
    func layoutSubscibeButton() {
        //完全重写base-加到scrollview上去
        contentContainer.addSubview(subscribeBtn)
        subscribeBtn.backgroundColor = .yellow
        // 自动布局相关设置
        setSubscibeBtnConstraints()
    }
    
    //被layoutSubscibeButton调用
    func setSubscibeBtnConstraints() {
        subscribeBtn.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            let offset = 15
            maker.top.equalTo(contentsView.snp.bottom).offset(offset)
            maker.height.equalTo(60)
            maker.width.equalTo(250) //500像素
        }
    }
    
    func layoutBottomTextView() {
        bottomTextView.backgroundColor = UIColor.clear
        bottomTextView.showsVerticalScrollIndicator = false
        bottomTextView.isEditable = false
        bottomTextView.textAlignment = .center
        bottomTextView.isScrollEnabled = false //textView会自己计算高度
        contentContainer.addSubview(bottomTextView)
        
        bottomTextView.text = "即佛ad 覅道交法发放假大家发哦啊方打飞机of时代峰峻偶爱是对方奥覅是的覅圣诞节发斯蒂芬爱的方法我奥迪奇偶我阿发放水阀is打飞机偶爱发电房时附加时代峰峻爱福家水豆腐暗示法司法局塞打飞机爱士大夫奥时代峰峻大师傅暗色调附件发时代峻峰奥if就奥打飞机发电房加哦附件搜房沙发"
        let width: CGFloat = 325
        let maxSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let size = bottomTextView.sizeThatFits(maxSize)
        
        let offset = 10 + 19 //19为按钮底部添加标签高度
        bottomTextView.snp.makeConstraints { (maker) in
            maker.top.equalTo(subscribeBtn.snp.bottom).offset(offset)
            maker.centerX.equalToSuperview()
            maker.width.equalTo(ceil(width))
            maker.bottom.equalToSuperview()
        }
    }
    
    //super的配置是紫色->新方案采用新的外观
    func configureSubscibleBtn() -> Void {
        subscribeBtn.layer.cornerRadius = 0.5 * 60
        subscribeBtn.backgroundColor = .black
        subscribeBtn.titleLabel?.font = UIFont(name: "PingFangSC-Semibold", size: 15.0)
        subscribeBtn.titleLabel?.numberOfLines = 0
        subscribeBtn.titleLabel?.textAlignment = .center
        let title = "i18n_952_VIP继续按钮"
        subscribeBtn.setTitle(title, for: .normal) //初始默认文案
    }
    
}

