//
//  DemoSearchViewController.h
//  XCTestDemo
//
//  Created by JiangWang on 28/05/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DemoSearchViewController : UIViewController
@property (nonatomic, weak, readonly) UISearchBar *searchBar;
@property (nonatomic, weak, readonly) UITableView *resultsTable;
@end
