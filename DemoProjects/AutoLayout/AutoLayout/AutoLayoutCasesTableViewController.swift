//
//  AutoLayoutCasesTableViewController.swift
//  AutoLayout
//
//  Created by JiangWang on 2020/3/8.
//  Copyright © 2020 JiangWang. All rights reserved.
//

import UIKit

class TestCaseCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class AutoLayoutCasesTableViewController: UITableViewController {
    
    /// Test cases
    private enum TestCases: String, CaseIterable {
        typealias RawValue = String
        /// 布局cycle
        case layoutCycle = "Layout Cycle"
        /// 移除视图
        case removeViews = "Remove Views"
        /// stack view
        case stackView = "Stack View"
        /// atuo resizing table view cell
        case autoRizingTableCell = "Auto-resizing Table View Cell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "AutoLayout Cases"
        tableView.register(TestCaseCell.self, forCellReuseIdentifier: "TestCaseCell")
    }
    
}

//MARK: - Table view data source
extension AutoLayoutCasesTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TestCases.allCases.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TestCaseCell", for: indexPath)
        guard indexPath.item < TestCases.allCases.count else { return cell }
        let test = TestCases.allCases[indexPath.item]
        cell.textLabel?.text = test.rawValue
        return cell
    }
}

//MARK: - Table view delegate
extension AutoLayoutCasesTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.item < TestCases.allCases.count else { return }
        let test = TestCases.allCases[indexPath.item]
        var testVC: UIViewController? = nil
        switch test {
        case .removeViews:
            testVC = RemoveViewTestViewController()
        case .layoutCycle:
            testVC = LayoutCycleViewController()
        case .stackView:
            testVC = StackViewTestViewController(nibName: nil, bundle: nil)
        case .autoRizingTableCell:
            testVC = AutoResizingTableCellViewController()
        }
        if let vc = testVC {
            testVC?.title = test.rawValue
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
