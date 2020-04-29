//
//  AutoResizingTableCellViewController.swift
//  AutoLayout
//
//  Created by JiangWang on 2020/3/8.
//  Copyright © 2020 JiangWang. All rights reserved.
//

import UIKit

class AutoResizingTableViewCell: UITableViewCell {
    
    let iconView: UIImageView = UIImageView.init()
    
    let contentLabel: UILabel = UILabel.init()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        backgroundColor = UIColor.clear
        
        iconView.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(iconView)
        contentView.addSubview(contentLabel)

        contentLabel.textAlignment = .left
        contentLabel.font = UIFont.systemFont(ofSize: 19, weight: .semibold)
        contentLabel.numberOfLines = 0
        contentLabel.setContentHuggingPriority(.required, for: .horizontal)
        
        let iconConstraints = [iconView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
                               iconView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0),
                               iconView.widthAnchor.constraint(equalToConstant: 17.5),
                               iconView.heightAnchor.constraint(equalToConstant: 17.5)]
        contentView.addConstraints(iconConstraints)
        
        let labelConstraints = [contentLabel.leftAnchor.constraint(equalTo: iconView.rightAnchor, constant: 8),
                                contentLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
                                contentLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
                                contentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
                                contentLabel.heightAnchor.constraint(greaterThanOrEqualTo: iconView.heightAnchor)]
        contentView.addConstraints(labelConstraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class AutoResizingTableCellViewController: UIViewController {
    
    /// tables
    let table1 = UITableView(frame: .zero, style: .plain)
    let table2 = UITableView(frame: .zero, style: .plain)
    
    ///文案
    let tips = ["免广告打扰",
                "最新功能抢鲜体验",
                "100+ 专业人像精修工具",
                "200+定制美妆，风格可盐可甜",
                "600+ 风格滤镜&萌拍贴纸，每周更新",
                "皮肤焕新 五官重塑 瘦脸塑身 全功能解锁"]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // table 1
        table1.translatesAutoresizingMaskIntoConstraints = false
        table1.backgroundColor = UIColor.brown
        table1.showsVerticalScrollIndicator = false
        table1.showsHorizontalScrollIndicator = false
        table1.separatorStyle = .none
        table1.register(AutoResizingTableViewCell.self, forCellReuseIdentifier: "AutoResizingTableViewCell")
        table1.dataSource = self
        table1.delegate = self
        view.addSubview(table1)
        let table1Constraints = [table1.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                                 table1.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 50),
                                 table1.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
                                 table1.heightAnchor.constraint(equalToConstant: 120)]
        table1.estimatedRowHeight = 40
        view.addConstraints(table1Constraints)
        
        // table 2
        table2.translatesAutoresizingMaskIntoConstraints = false
        table2.backgroundColor = UIColor.lightGray
        table2.showsVerticalScrollIndicator = false
        table2.showsHorizontalScrollIndicator = false
        table2.separatorStyle = .none
        table2.register(AutoResizingTableViewCell.self, forCellReuseIdentifier: "AutoResizingTableViewCell")
        table2.dataSource = self
        table2.delegate = self
        table2.estimatedRowHeight = 40
        view.addSubview(table2)
        let table2Constraints = [table2.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 100),
                                 table2.topAnchor.constraint(equalTo: table1.bottomAnchor, constant: 80),
                                 table2.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -80),
                                 table2.heightAnchor.constraint(equalToConstant: 180)]
        view.addConstraints(table2Constraints)
    }
    
}

extension AutoResizingTableCellViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AutoResizingTableViewCell", for: indexPath) as! AutoResizingTableViewCell
        guard indexPath.row < tips.count else { return cell }
        if tableView == table1 {
            let tip = tips[indexPath.row]
            cell.contentLabel.attributedText = nil
            cell.contentLabel.text = tip
        } else {
            let tip = tips[indexPath.row]
            cell.contentLabel.text = nil
            let attributedText = NSAttributedString(string: tip, attributes: [.foregroundColor: UIColor.blue.cgColor as Any,
                                                                              .font: UIFont.systemFont(ofSize: 20, weight: .regular) as Any])
            cell.contentLabel.attributedText = attributedText
        }
        cell.iconView.image = UIImage(named: "vip_content_check")
        return cell
    }
}

extension AutoResizingTableCellViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

