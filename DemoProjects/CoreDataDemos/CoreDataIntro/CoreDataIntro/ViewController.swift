//
//  ViewController.swift
//  CoreDataIntro
//
//  Created by JiangWang on 13/11/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

import UIKit
import CoreData


class ViewController: UIViewController {
    
    // Mark: Properties
    static var kCellIdentifier: String! = "kCellIdentifier"
    @IBOutlet weak var peopleTableView: UITableView!
    var people: [NSManagedObject] = []

    // Mark: Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "The List"
        peopleTableView.register(UITableViewCell.self, forCellReuseIdentifier: ViewController.kCellIdentifier)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.restoreData()
    }


    // Mark: Action Methods
    @IBAction func didClickAddButton(_ sender: UIBarButtonItem) {
        let alertCon = UIAlertController(title: "Add A Person",
                                         message: "Input the person's name:",
                                         preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default)
        {
            [unowned self] action in
            guard let inputTextField = alertCon.textFields?.first,
                let inputName = inputTextField.text else {
                    return
            }
            
            self.savePerson(name: inputName)
            self.peopleTableView.reloadData();
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default,
                                         handler: nil)
        alertCon.addTextField()
        alertCon.addAction(saveAction)
        alertCon.addAction(cancelAction)
        self.present(alertCon, animated: true, completion: nil)
    }
    
    //MARK: Private 
    func savePerson(name: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return;
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext;
        let entityDes = NSEntityDescription.entity(forEntityName: "People", in: managedContext)
        let person = NSManagedObject(entity: entityDes!, insertInto: managedContext)
        person.setValue(name, forKey: "name")
        do {
            try managedContext.save()
            people.append(person)
        } catch let error as NSError {
            print("Could not save, \(error), \(error.userInfo)")
        }
    }
    
    func restoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext;
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "People")
        do {
            people = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch, \(error), \(error.userInfo)")
        }
        
        guard (peopleTableView != nil) else {
            return
        }
        peopleTableView.reloadData()
    }
}

//MARK: UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ViewController.kCellIdentifier, for: indexPath)
        cell.textLabel?.text = people[indexPath.row].value(forKey: "name") as? String
        return cell
    }
}

