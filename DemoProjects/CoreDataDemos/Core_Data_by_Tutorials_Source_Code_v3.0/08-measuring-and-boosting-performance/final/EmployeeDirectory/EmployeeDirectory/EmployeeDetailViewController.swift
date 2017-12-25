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

class EmployeeDetailViewController: UIViewController {

  // MARK: - Properties
  fileprivate lazy var dateFormatter: DateFormatter = {
    let fmt = DateFormatter()
    fmt.dateFormat = "MM/dd/yyyy"
    return fmt
  }()

  var employee: Employee?

  // MARK: IBOutlets
  @IBOutlet var headShotImageView: UIImageView!
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var departmentLabel: UILabel!
  @IBOutlet var emailLabel: UILabel!
  @IBOutlet var phoneNumberLabel: UILabel!
  @IBOutlet var startDateLabel: UILabel!
  @IBOutlet var vacationDaysLabel: UILabel!
  @IBOutlet var salesCountLabel: UILabel!
  @IBOutlet var bioTextView: UITextView!

  // MARK: View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()

    configureView()
  }

  // MARK: Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    guard segue.identifier == "SegueEmployeeDetailToEmployeePicture",
      let controller = segue.destination
        as? EmployeePictureViewController else {
          return
    }

    controller.employee = employee
  }
}

// MARK: Private
private extension EmployeeDetailViewController {

  func configureView() {
    guard let employee = employee else { return }

    title = employee.name

    let image = UIImage(data: employee.pictureThumbnail)
    headShotImageView.image = image

    nameLabel.text = employee.name
    departmentLabel.text = employee.department
    emailLabel.text = employee.email
    phoneNumberLabel.text = employee.phone

    startDateLabel.text = dateFormatter.string(from: employee.startDate)

    vacationDaysLabel.text = String(employee.vacationDays.intValue)

    bioTextView.text = employee.about

    salesCountLabel.text = salesCountForEmployeeFast(employee)
  }
}

// MARK: Internal
extension EmployeeDetailViewController {

  func salesCountForEmployee(_ employee: Employee) -> String {

    let fetchRequest: NSFetchRequest<Sale> = NSFetchRequest(entityName: "Sale")
    let predicate = NSPredicate(format: "employee == %@", employee)
    fetchRequest.predicate = predicate

    let context = employee.managedObjectContext!
    do {
      let results = try context.fetch(fetchRequest)
      return "\(results.count)"
    } catch let error as NSError {
      print("Error: \(error.localizedDescription)")
      return "0"
    }
  }
  
  func salesCountForEmployeeFast(_ employee: Employee) -> String {

    let fetchRequest: NSFetchRequest<Sale> = NSFetchRequest(entityName: "Sale")
    let predicate = NSPredicate(format: "employee == %@", employee)
    fetchRequest.predicate = predicate

    let context = employee.managedObjectContext!
    do {
      let results = try context.count(for: fetchRequest)
      return "\(results)"
    } catch let error as NSError {
      print("Error: \(error.localizedDescription)")
      return "0"
    }
  }

  func salesCountForEmployeeSimple(_ employee: Employee) -> String {
    return "\(employee.sales.count)"
  }
}
