//
//  ViewController.swift
//  CoreData
//
//  Created by JiangWang on 2020/4/1.
//  Copyright © 2020 JiangWang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
        let dmo = DataController.shared.createDepartmentEntity()
        dmo?.address = "哈哈哈哈哈哈"
        dmo?.name = "你能看到内容么"
        dmo?.encrypted = "encrypted content 02"
        dmo?.rabit = "Rabit 02"

        let emo = DataController.shared.createEmployeeEntity()
        emo?.dateOfBirth = Date()
        emo?.name = "R01"
        emo?.department = dmo
        DataController.shared.saveContext()

        let predicate = NSPredicate(format: "name == %@", "R01")
        let emos = DataController.shared.fetchEmployeeEntity(predicate: predicate)
        for emo in emos {
            print("emo's department's rabit: \(emo.department?.rabit ?? "")\n")
            print("emo description: \(emo)")
        }
    }
}

