//
//  Department+CoreDataProperties.swift
//  
//
//  Created by JiangWang on 2020/4/8.
//
//

import Foundation
import CoreData


extension Department {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Department> {
        return NSFetchRequest<Department>(entityName: "Department")
    }

    @NSManaged public var address: String?
    @NSManaged public var encrypted: String?
    @NSManaged public var name: String?
    @NSManaged public var rabit: String?
    @NSManaged public var employees: NSSet?

}

// MARK: Generated accessors for employees
extension Department {

    @objc(addEmployeesObject:)
    @NSManaged public func addToEmployees(_ value: EmployeeMO)

    @objc(removeEmployeesObject:)
    @NSManaged public func removeFromEmployees(_ value: EmployeeMO)

    @objc(addEmployees:)
    @NSManaged public func addToEmployees(_ values: NSSet)

    @objc(removeEmployees:)
    @NSManaged public func removeFromEmployees(_ values: NSSet)

}
