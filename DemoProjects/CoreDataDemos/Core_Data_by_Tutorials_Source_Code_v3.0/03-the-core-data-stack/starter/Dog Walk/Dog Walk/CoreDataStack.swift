//
//  CoreDataStack.swift
//  Dog Walk
//
//  Created by JiangWang on 15/11/2017.
//  Copyright © 2017 Razeware. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
  //MARK: Properties
  private let modelName: String
  
  //MARK: Public
  init(modelName: String) {
    self.modelName = modelName
  }
  
  func saveContext() {
    guard self.managedContext.hasChanges else {
      return
    }
    
    do {
      try self.managedContext.save()
    } catch let error as NSError {
      print("Could not save: \(error), \(error.userInfo)")
    }
  }
  
  //MARK: Lazy Loading 
  private lazy var storeContainer : NSPersistentContainer = {
    let container = NSPersistentContainer(name: self.modelName)
    container.loadPersistentStores {
      (storeDescription, error) in
      if let error = error as NSError? {
        print("unsolved error: \(error), \(error.userInfo)")
      }
    }
    return container
  }()
  
  lazy var managedContext : NSManagedObjectContext = {
    return self.storeContainer.viewContext
  }()
  
}
