/*
* Copyright (c) 2014 Razeware LLC
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

let StoryListToStoryViewSegueIdentifier = "StoryListToStoryView";

class StoryListController: UITableViewController, ThemeAdopting {
  
  private var stories = [Story]()
  
  required init(coder aDecoder: NSCoder)  {
    super.init(coder: aDecoder)!
    registerForNotifications()
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == StoryListToStoryViewSegueIdentifier {
      let storyViewController = segue.destination as! StoryViewController
      storyViewController.story = sender as? Story;
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let image = UIImage(named: "Bull")
    let imageView = UIImageView(image: image)
    navigationItem.titleView = imageView
    reloadTheme()
    
    let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    activityView.hidesWhenStopped = true
    let containerItem = UIBarButtonItem(customView: activityView)
    navigationItem.rightBarButtonItem = containerItem
    
    tableView.register(StoryCell.self, forCellReuseIdentifier: "StoryCell")
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 78
    tableView.tableFooterView = UIView()
    
    activityView.startAnimating()
    Story.loadStories() { loadedStories, error in
      if let stories = loadedStories {
        self.stories = stories
        var indexPaths = [NSIndexPath]()
        
        for row in 0 ..< stories.count {
          let indexPath = NSIndexPath(row: row, section: 0)
          indexPaths.append(indexPath)
        }
        
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: indexPaths as [IndexPath], with: .automatic)
        self.tableView.endUpdates()
      }
      activityView.stopAnimating()
    }
  }
  
  func preferredContentSizeCategoryDidChange(notification: NSNotification!) {
    tableView.reloadData()
  }
  
  private func registerForNotifications() {
    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(self, selector: Selector("preferredContentSizeCategoryDidChange:"),
      name: NSNotification.Name.UIContentSizeCategoryDidChange, object: nil)
    notificationCenter.addObserver(self, selector: Selector("themeDidChange:"),
      name: NSNotification.Name(rawValue: ThemeDidChangeNotification), object: nil)
  }
  
  func themeDidChange(notification: NSNotification!) {
    reloadTheme()
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.stories.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let storyCell = tableView.dequeueReusableCell(withIdentifier: "StoryCell") as! StoryCell
    storyCell.story = stories[indexPath.row]
    return storyCell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let story = stories[indexPath.row]
    performSegue(withIdentifier: StoryListToStoryViewSegueIdentifier, sender: story)
  }
  
  func reloadTheme() {
    let theme = Theme.sharedInstance
    tableView.separatorColor = theme.separatorColor
    
    if let indexPaths = tableView.indexPathsForVisibleRows {
      tableView.reloadRows(at: indexPaths, with: .none)
    }
  }
  
}
