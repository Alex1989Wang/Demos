//
//  Person+CoreDataProperties.swift
//  CoreDataDemo
//
//  Created by JiangWang on 2020/4/7.
//  Copyright © 2020 JiangWang. All rights reserved.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var dateOfBirth: Date?
    @NSManaged public var name: String?

}
