//
//  EmployeeMO+CoreDataProperties.swift
//  CoreDataDemo
//
//  Created by JiangWang on 2020/4/7.
//  Copyright © 2020 JiangWang. All rights reserved.
//
//

import Foundation
import CoreData


extension EmployeeMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EmployeeMO> {
        return NSFetchRequest<EmployeeMO>(entityName: "Employee")
    }

    @NSManaged public var department: Department?

}
