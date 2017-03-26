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

class StoryViewController: UIViewController, ThemeAdopting {
  
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var storyView: StoryView!
  @IBOutlet weak var optionsContainerView: UIView!
  @IBOutlet weak var optionsContainerViewBottomConstraint: NSLayoutConstraint!
  var showingOptions = false
  
  var story: Story?
  
  required init(coder aDecoder: NSCoder)  {
    super.init(coder: aDecoder)!
    NotificationCenter.default.addObserver(self, selector: Selector("themeDidChange:"),
                                           name: NSNotification.Name(rawValue: ThemeDidChangeNotification), object: nil)
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let image = UIImage(named: "Bull")
    let imageView = UIImageView(image: image)
    navigationItem.titleView = imageView
    reloadTheme()
    if story != nil {
      storyView.story = story
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setOptionsHidden(hidden: true, animated: false)
  }
  
  @IBAction func optionsButtonTapped(_: AnyObject) {
    setOptionsHidden(hidden: showingOptions, animated: true)
  }
  
  private func setOptionsHidden(hidden: Bool, animated: Bool) {
    showingOptions = !hidden;
    let height = optionsContainerView.bounds.height
    var constant = optionsContainerViewBottomConstraint.constant
    constant = hidden ? (constant - height) : (constant + height)
    view.layoutIfNeeded()
    
    let options : UIViewAnimationOptions =
      [UIViewAnimationOptions.allowUserInteraction,
       UIViewAnimationOptions.beginFromCurrentState]
    if animated {
      UIView.animate(withDuration: 0.2,
                     delay: 0,
                     options: options,
                     animations:
        {
          self.optionsContainerViewBottomConstraint.constant = constant
          self.view.layoutIfNeeded()
      },
                     completion: nil)
    }
    else
    {
      optionsContainerViewBottomConstraint.constant = constant
    }
  }
  
  
  func themeDidChange(notification: NSNotification!) {
    reloadTheme()
    storyView.reloadTheme()
  }
  
  func reloadTheme() {
    let theme = Theme.sharedInstance
    scrollView.backgroundColor = theme.textBackgroundColor
    for viewController in childViewControllers {
      if let controller = viewController as? UIViewController {
        controller.view.tintColor = theme.tintColor
      }
    }
  }
  
}
