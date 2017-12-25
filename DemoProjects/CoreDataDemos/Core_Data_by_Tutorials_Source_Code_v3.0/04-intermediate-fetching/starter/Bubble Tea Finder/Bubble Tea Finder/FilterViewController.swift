/**
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

enum JWVenuePriceType: Int {
  case JWVenuePriceTypeCheap = 1;
  case JWVenuePriceTypeModerate;
  case JWVenuePriceTypeExpensive;
}

protocol FilterViewControllerDelegte: class {
  func filterViewController(filterController: FilterViewController,
                            didSelectPredicate: NSPredicate?,
                            sortDescriptor: NSSortDescriptor?)
}

class FilterViewController: UITableViewController {

  @IBOutlet weak var firstPriceCategoryLabel: UILabel!
  @IBOutlet weak var secondPriceCategoryLabel: UILabel!
  @IBOutlet weak var thirdPriceCategoryLabel: UILabel!
  @IBOutlet weak var numDealsLabel: UILabel!

  // MARK: - Price section
  @IBOutlet weak var cheapVenueCell: UITableViewCell!
  @IBOutlet weak var moderateVenueCell: UITableViewCell!
  @IBOutlet weak var expensiveVenueCell: UITableViewCell!

  // MARK: - Most popular section
  @IBOutlet weak var offeringDealCell: UITableViewCell!
  @IBOutlet weak var walkingDistanceCell: UITableViewCell!
  @IBOutlet weak var userTipsCell: UITableViewCell!
  
  // MARK: - Sort section
  @IBOutlet weak var nameAZSortCell: UITableViewCell!
  @IBOutlet weak var nameZASortCell: UITableViewCell!
  @IBOutlet weak var distanceSortCell: UITableViewCell!
  @IBOutlet weak var priceSortCell: UITableViewCell!
  
  //MARK: properties
  var coreDataStack: CoreDataStack!
  weak var delegate: FilterViewControllerDelegte?
  var selectedPredicate: NSPredicate?
  var selectedSortDescriptor: NSSortDescriptor?
  
  //MARK: Lazy Variables
  lazy var cheapVenuePredicate: NSPredicate = {
    return NSPredicate(format: "%K = %@",
                       #keyPath(Venue.priceInfo.priceCategory), "$")
  }()
  lazy var moderateVenuePredicate: NSPredicate = {
    return NSPredicate(format: "%K = %@",
                       #keyPath(Venue.priceInfo.priceCategory), "$$")
  }()
  lazy var expensiveVenuePredicate: NSPredicate = {
    return NSPredicate(format: "%K = %@",
                       #keyPath(Venue.priceInfo.priceCategory), "$$$")
  }()
  lazy var nameSortDescriptor: NSSortDescriptor = {
    let compareSelector = #selector(NSString.localizedStandardCompare(_:))
    return NSSortDescriptor(key: #keyPath(Venue.name), ascending: true, selector: compareSelector)
  }()
  lazy var distanceSortDescriptor: NSSortDescriptor = {
    return NSSortDescriptor(key: #keyPath(Venue.location.distance), ascending: true)
  }()
  lazy var priceSortDescriptor: NSSortDescriptor = {
    return NSSortDescriptor(key: #keyPath(Venue.priceInfo.priceCategory), ascending: true)
  }()
  
		
  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.populateCheapVenueCountLabel()
    self.populateModerateVenueCountLabel()
    self.populateVenueCountLabel(priceType: JWVenuePriceType.JWVenuePriceTypeExpensive)
    self.populateDealsCountLabel()
  }
}

//MARK: Helper Methods
extension FilterViewController {
  func populateCheapVenueCountLabel() {
    let countFetch = NSFetchRequest<NSNumber>(entityName: "Venue")
    countFetch.resultType = .countResultType
    countFetch.predicate = self.cheapVenuePredicate
    
    do {
      let countArray = try self.coreDataStack.managedContext.fetch(countFetch)
      let count = countArray.first?.intValue
      self.cheapVenueCell.detailTextLabel?.text = String(describing: count)
    } catch let error as NSError {
      print("error: \(error) \(error.userInfo)")
    }
  }
  
  func populateModerateVenueCountLabel() {
    let countFetch = NSFetchRequest<NSNumber>(entityName: "Venue")
    countFetch.predicate = self.moderateVenuePredicate
    countFetch.resultType = .countResultType
    
    do {
      let countArray = try self.coreDataStack.managedContext.fetch(countFetch)
      let count = countArray.first?.intValue
      self.moderateVenueCell.detailTextLabel?.text = String(describing: count)
    } catch let error as NSError {
      print("error: \(error) \(error.userInfo)")
    }
  }
  
  func populateVenueCountLabel(priceType: JWVenuePriceType) {
    let countFetch = NSFetchRequest<NSNumber>(entityName: "Venue")
    countFetch.resultType = .countResultType
    
    var displayLabel: UILabel? = nil;
    
    switch priceType {
    case .JWVenuePriceTypeCheap:
      countFetch.predicate = self.cheapVenuePredicate
      displayLabel = self.cheapVenueCell.detailTextLabel;
      break
    case .JWVenuePriceTypeModerate:
      countFetch.predicate = self.moderateVenuePredicate
      displayLabel = self.moderateVenueCell.detailTextLabel;
      break
    case .JWVenuePriceTypeExpensive:
      countFetch.predicate = self.expensiveVenuePredicate
      displayLabel = self.expensiveVenueCell.detailTextLabel;
      break
    default:
      assert(false, "no such type.")
      break
    }
    
    guard let cellLabel = displayLabel else {
      return
    }
    
    do {
      let countArray = try self.coreDataStack.managedContext.fetch(countFetch)
      let count = countArray.first?.intValue
      cellLabel.text = String(describing: count)
    } catch let error as NSError {
      print("\(error)")
    }
  }
  
  func populateDealsCountLabel() {
    let constSumsDeal = "deals.sum"
    let fetechRequest = NSFetchRequest<NSDictionary>(entityName: "Venue")
    fetechRequest.resultType = .dictionaryResultType
    
    let sumExpDescription = NSExpressionDescription()
    sumExpDescription.name = constSumsDeal
    
    let specialCountExpression = NSExpression(forKeyPath: #keyPath(Venue.specialCount))
    sumExpDescription.expression = NSExpression(forFunction: "sum:", arguments: [specialCountExpression])
    sumExpDescription.expressionResultType = .integer32AttributeType
   
    fetechRequest.propertiesToFetch = [sumExpDescription]
    do {
      let results = try self.coreDataStack.managedContext.fetch(fetechRequest)
      let resultDict = results.first!
      let numDeals = resultDict[constSumsDeal] as! NSNumber
      self.numDealsLabel?.text = "\(numDeals) number of deals"
    } catch let error as NSError {
      print("\(error)")
    }
  }
}

// MARK: - IBActions
extension FilterViewController {
  @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
    delegate?.filterViewController(filterController: self,
                                   didSelectPredicate: self.selectedPredicate,
                                   sortDescriptor: self.selectedSortDescriptor)
    self.dismiss(animated: true, completion: nil)
  }
}

// MARK - UITableViewDelegate
extension FilterViewController {
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let cell = tableView.cellForRow(at: indexPath) else {
      return
    }
    
    switch cell {
    case self.cheapVenueCell:
      self.selectedPredicate = self.cheapVenuePredicate
    case self.moderateVenueCell:
      self.selectedPredicate = self.moderateVenuePredicate
    case self.expensiveVenueCell:
      self.selectedPredicate = self.expensiveVenuePredicate
      
    //sort cells
    case self.distanceSortCell:
      self.selectedSortDescriptor = self.distanceSortDescriptor
    case self.nameAZSortCell:
      self.selectedSortDescriptor = self.nameSortDescriptor
    case self.nameZASortCell:
      self.selectedSortDescriptor = self.nameSortDescriptor.reversedSortDescriptor as? NSSortDescriptor
    case self.priceSortCell:
      self.selectedSortDescriptor = self.priceSortDescriptor
    default:
      break
    }
    
    cell.accessoryType = .checkmark
  }
}

