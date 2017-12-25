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

class ViewController: UIViewController {

  // MARK: - Properties
  private let filterViewControllerSegueIdentifier = "toFilterViewController"
  fileprivate let venueCellIdentifier = "VenueCell"
  var fetchRequest: NSFetchRequest<Venue>!
  var venues: [Venue] = []

  var coreDataStack: CoreDataStack!
  var asynchronusFR: NSAsynchronousFetchRequest<Venue>!

  // MARK: - IBOutlets
  @IBOutlet weak var tableView: UITableView!

  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.fetchRequest = Venue.fetchRequest()
    self.asynchronusFR = NSAsynchronousFetchRequest<Venue>(fetchRequest: self.fetchRequest,
                                                           completionBlock:
      { [unowned self] (result: NSAsynchronousFetchResult) in
        guard let venues = result.finalResult else {
          return
        }
        
        self.venues = venues
        self.tableView.reloadData()
    })
    
    // 3
    do {
      try coreDataStack.managedContext.execute(self.asynchronusFR)
      // Returns immediately, cancel here if you want
    } catch let error as NSError {
      print("Could not fetch \(error), \(error.userInfo)")
    }
    
  }

  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == filterViewControllerSegueIdentifier {
      guard segue.identifier == filterViewControllerSegueIdentifier,
      let navigationCon = segue.destination as? UINavigationController,
      let filterViewCon = navigationCon.topViewController as? FilterViewController else {
        return
      }
      filterViewCon.coreDataStack = self.coreDataStack
      filterViewCon.delegate = self
    }
  }
  
  //MARK: Private
  func fetchAndReload() {
    do {
      let results = try self.coreDataStack.managedContext.fetch(self.fetchRequest)
      self.venues = results
      self.tableView.reloadData()
    } catch let error as NSError {
      print("fetch error: \(error) \(error.userInfo)")
    }
  }
}

// MARK: - IBActions
extension ViewController {

  @IBAction func unwindToVenueListViewController(_ segue: UIStoryboardSegue) {
  }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.venues.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: venueCellIdentifier, for: indexPath)
    return cell
  }
}

extension ViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    let venue = self.venues[indexPath.row]
    cell.textLabel?.text = venue.name
    cell.detailTextLabel?.text = venue.priceInfo?.priceCategory
  }
}

extension ViewController: FilterViewControllerDelegte {
  func filterViewController(filterController: FilterViewController,
                            didSelectPredicate: NSPredicate?,
                            sortDescriptor: NSSortDescriptor?) {
    self.fetchRequest.predicate = nil
    self.fetchRequest.sortDescriptors = nil
    
    self.fetchRequest.predicate = didSelectPredicate
    if let sortDes = sortDescriptor {
      self.fetchRequest.sortDescriptors = [sortDes]
    }
    
    self.fetchAndReload()
  }
}
