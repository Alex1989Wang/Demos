//
//  File.swift
//  CoreData
//
//  Created by JiangWang on 2020/4/2.
//  Copyright © 2020 JiangWang. All rights reserved.
//

import Foundation
import CoreData
import CloudKit

class DataController {
    
    enum Entity: String {
        case employee = "Employee"
        case department = "Department"
    }
    
    /// 单例
    static let shared = DataController()
    
    // MARK: - Core Data stack
    private lazy var mom: NSManagedObjectModel = {
        guard let modelUrl = Bundle.main.url(forResource: "CoreData", withExtension: "momd") else {
            fatalError("Failed to find core data model")
        }
        guard let mom = NSManagedObjectModel(contentsOf: modelUrl) else {
            fatalError("Failed to create model from file: \(modelUrl)")
        }
        return mom
    }()
    
    private lazy var psc: NSPersistentStoreCoordinator = {
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        let dirURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).last!
        let dataDir = URL(fileURLWithPath: dirURL.path + "/Data", isDirectory: true)
        do {
            if !FileManager.default.fileExists(atPath: dataDir.path) {
                try FileManager.default.createDirectory(at: dataDir, withIntermediateDirectories: true, attributes: nil)
            }
            let fileURL = URL(fileURLWithPath: dataDir.path + "/DataModel.sqlite")
            let options = [NSMigratePersistentStoresAutomaticallyOption : true,
                           NSInferMappingModelAutomaticallyOption: true]
            try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: fileURL, options: options)
        } catch {
            fatalError("Error configuring persistent store: \(error)")
        }
        return psc
    }()
    
    private lazy var moc: NSManagedObjectContext = {
        let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        moc.persistentStoreCoordinator = psc
        return moc
    }()

    // MARK: - Core Data Saving support
    func saveContext () {
        let context = moc
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

//MARK: - Public
extension DataController {
    func createEmployeeEntity() -> EmployeeMO? {
        let employee = NSEntityDescription.insertNewObject(forEntityName: Entity.employee.rawValue, into: moc)
        guard let emo = employee as? EmployeeMO else { return nil }
        return emo
    }
    
    func createDepartmentEntity() -> Department? {
        let depart = NSEntityDescription.insertNewObject(forEntityName: Entity.department.rawValue, into: moc)
        guard let dmo = depart as? Department else { return nil }
        return dmo
    }
    
    func fetchEmployeeEntity(predicate: NSPredicate?) -> [EmployeeMO] {
        let employeesFetch: NSFetchRequest<EmployeeMO> = EmployeeMO.fetchRequest()
        employeesFetch.predicate = predicate
        do {
            let employees = try moc.fetch(employeesFetch as! NSFetchRequest<NSFetchRequestResult>) as! [EmployeeMO]
            return employees
        } catch {
            print("Failed to fetch employees: \(error)")
        }
        return []
    }
}
