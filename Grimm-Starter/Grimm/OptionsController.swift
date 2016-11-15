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

class OptionsController: UIViewController, UIScrollViewDelegate {
  
  var currentPage = 0
  @IBOutlet weak var readingModeSegmentedControl: UISegmentedControl!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var titleAlignmentSegmentedControl: UISegmentedControl!
  @IBOutlet weak var pageControl: UIPageControl!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let optionsView = UINib(nibName: "OptionsView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! UIView
    scrollView.scrollsToTop = false
    view.addSubview(optionsView)
    
    // blur here, you will
    
    var constraints = [NSLayoutConstraint]()
    
    constraints.append(NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal,
      toItem: optionsView, attribute: .centerX, multiplier: 1, constant: 0))
    
    constraints.append(NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal,
      toItem: optionsView, attribute: .centerY, multiplier: 1, constant: 0))
    
    view.addConstraints(constraints)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    scrollView.contentSize = CGSize(width: 1272, height: 44)
    
    let theme = Theme.sharedInstance
    readingModeSegmentedControl.selectedSegmentIndex = theme.readingMode.rawValue
    titleAlignmentSegmentedControl.selectedSegmentIndex = theme.titleAlignment.rawValue
    currentPage = theme.font.rawValue
    pageControl.currentPage = currentPage
    synchronizeViews(scrolled: false)
  }
  
  @IBAction func pageControlPageDidChange(_: AnyObject) {
    synchronizeViews(scrolled: false)
  }
  
  @IBAction func readingModeDidChange(segmentedControl: UISegmentedControl!) {
    Theme.sharedInstance.readingMode = ReadingMode(rawValue: segmentedControl.selectedSegmentIndex)!
  }
  
  @IBAction func titleAlignmentDidChange(segmentedControl: UISegmentedControl!) {
    Theme.sharedInstance.titleAlignment = TitleAlignment(rawValue: segmentedControl.selectedSegmentIndex)!
  }
  
  private func synchronizeViews(scrolled: Bool) {
    let pageWidth = scrollView.bounds.width
    var page: Int = 0
    var offset: CGFloat = 0
    
    if scrolled {
      offset = self.scrollView.contentOffset.x
      page = Int(offset / pageWidth)
      pageControl.currentPage = page
    } else {
      page = pageControl.currentPage
      offset = CGFloat(page) * pageWidth
      scrollView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
    }
    
    if page != currentPage {
      currentPage = page
      Theme.sharedInstance.font = Font(rawValue: currentPage)!
    }
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView.isDragging || scrollView.isDecelerating {
      synchronizeViews(scrolled: true)
    }
  }
  
}
