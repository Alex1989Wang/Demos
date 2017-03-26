//
//  TestViewController.h
//  containerViewCon
//
//  Created by JiangWang on 9/18/16.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestViewController : UIViewController

@property (nonatomic, strong, readonly) UITableView *chatTable;


#pragma mark - 
#pragma mark - Public Methods
- (void)beginChating;

@end
