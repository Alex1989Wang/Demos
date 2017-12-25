/*
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import CoreData

class ViewController: UIViewController {
  
  //MARK: Properties
  var managedContext: NSManagedObjectContext!
  var currentBowtie: JWBowtie!
		
		
  // MARK: - IBOutlets
  @IBOutlet weak var segmentedControl: UISegmentedControl!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var ratingLabel: UILabel!
  @IBOutlet weak var timesWornLabel: UILabel!
  @IBOutlet weak var lastWornLabel: UILabel!
  @IBOutlet weak var favoriteLabel: UILabel!

  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.insertSampleData()
    
    //try fetch
    self.selectBowtie(atControlIndex: 0)
  }
  
  //MARK: Private
  func update(rating: String?) {
    guard let ratingStr = rating,
      let ratingDouble = Double(ratingStr) else {
      return
    }
    
    self.currentBowtie.rating = ratingDouble
    do {
      try self.managedContext.save()
      self.populateUI(bowtie: self.currentBowtie)
    } catch let error as NSError {
      if error.code == NSValidationNumberTooLargeError ||
        error.code == NSValidationNumberTooSmallError {
        print("Could not save rating: \(ratingStr), too large or too small")
      }
      else {
        print("Could not save rating: \(error), \(error.userInfo)")
      }
    }
  }
  
  func selectBowtie(atControlIndex: Int) {
    //try fetch
    let fetchRequest = NSFetchRequest<JWBowtie>(entityName: "JWBowtie")
    let bowtieSearchKey = self.segmentedControl.titleForSegment(at: atControlIndex)!
    let searchPredicate = NSPredicate(format: "searchKey == %@", bowtieSearchKey)
    fetchRequest.predicate = searchPredicate
    do {
      let results = try self.managedContext.fetch(fetchRequest)
      self.populateUI(bowtie: results.first!)
      self.currentBowtie = results.first
    } catch let error as NSError {
      print("could not fetch bowtie: \(error)")
    }
  }
  
  func populateUI(bowtie: JWBowtie) {
    guard let imageData = bowtie.bowtieImage as? Data,
      let tintColor = bowtie.tintColor as? UIColor,
      let lastWorn = bowtie.lastWorn as? Date else {
        return
    }
    
    imageView.image = UIImage(data: imageData)
    nameLabel.text = bowtie.name
    ratingLabel.text = "Rating: \(bowtie.rating)/5"
    timesWornLabel.text = "# times worn: \(bowtie.timesWorn)"
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .full
    dateFormatter.timeStyle = .none
    lastWornLabel.text = "Last Worn: " + dateFormatter.string(from: lastWorn)
    favoriteLabel.isHidden = !bowtie.isFavorite
    self.view.tintColor = tintColor
  }
  
  func insertSampleData() {
    //have inserted? 
    let fetchRequest = NSFetchRequest<JWBowtie>(entityName: "JWBowtie")
    let searchKeyPre = NSPredicate(format: "searchKey != nil")
    fetchRequest.predicate = searchKeyPre
    let count = try! self.managedContext.count(for: fetchRequest)
    if count > 0 {
      return
    }
    
    //insert
    let path = Bundle.main.path(forResource: "SampleData", ofType: "plist")
    let dataArray = NSArray(contentsOfFile: path!)!
    for dataDict in dataArray {
      let bowtieDict = dataDict as! [String : AnyObject]
      let bowtieEntity = NSEntityDescription.insertNewObject(forEntityName: "JWBowtie", into: self.managedContext)
      as! JWBowtie
      
      bowtieEntity.name = bowtieDict["name"] as? String
      bowtieEntity.searchKey = bowtieDict["searchKey"] as? String
      bowtieEntity.rating = bowtieDict["rating"] as! Double
      let colorDict = bowtieDict["tintColor"] as! [String : AnyObject]
      bowtieEntity.tintColor = UIColor.color(dict: colorDict)
      
      let imageName = bowtieDict["imageName"] as? String
      let bowtieImage = UIImage(named: imageName!)
      bowtieEntity.bowtieImage = UIImagePNGRepresentation(bowtieImage!)! as NSData
      
      bowtieEntity.lastWorn = bowtieDict["lastWorn"] as? NSDate
      bowtieEntity.timesWorn = bowtieDict["timesWorn"] as! Int32
      bowtieEntity.isFavorite = bowtieDict["isFavorite"] as! Bool
    }
    
    try! self.managedContext.save()
  }

  // MARK: - IBActions
  @IBAction func segmentedControl(_ sender: AnyObject) {
    guard let segControl = sender as? UISegmentedControl else {
      return
    }
    
    self.selectBowtie(atControlIndex: segControl.selectedSegmentIndex)
  }

  @IBAction func wear(_ sender: AnyObject) {
    let timesWorn = currentBowtie.timesWorn
    currentBowtie.timesWorn = timesWorn + 1
    currentBowtie.lastWorn = NSDate()
    
    do {
      try self.managedContext.save()
      self.populateUI(bowtie: currentBowtie)
    } catch let error as NSError {
      print("Could not save bowtie: \(error), \(error.userInfo)")
    }
  }
  
  @IBAction func rate(_ sender: AnyObject) {
    let alertCon = UIAlertController(title: "Rate this bowtie",
                                     message: nil,
                                     preferredStyle: .alert)
    alertCon.addTextField { (textField) in
      textField.keyboardType = .decimalPad
    }
    
    let rateAction = UIAlertAction(title: "Rate",
                                   style: .default)
    {
      [unowned self] rateAction in
      guard let textField = alertCon.textFields?.first else {
        return;
      }
      
      let ratingStr = textField.text
      self.update(rating: ratingStr)
    }
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
    alertCon.addAction(rateAction)
    alertCon.addAction(cancelAction)
    self.present(alertCon, animated: true, completion: nil)
  }
}

private extension UIColor {
  static func color(dict: [String : AnyObject]) -> UIColor? {
    guard let red = dict["red"] as? NSNumber,
      let green = dict["green"] as? NSNumber,
      let blue = dict["blue"] as? NSNumber else {
        return nil;
    }
    
    return UIColor(colorLiteralRed: red.floatValue/255.0,
                   green: green.floatValue/255.0,
                   blue: blue.floatValue/255.0,
                   alpha: 1.0)
  }
}
