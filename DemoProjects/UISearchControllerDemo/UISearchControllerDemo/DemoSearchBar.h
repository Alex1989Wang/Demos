//
//  DemoSearchBar.h
//  UISearchControllerDemo
//
//  Created by JiangWang on 15/11/2016.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DemoSearchBar : UISearchBar

@property (nonatomic, strong) UIFont *preferredFont;
@property (nonatomic, strong) UIColor *preferredTextColor;

#pragma mark - Methods
- (instancetype)initWithFrame:(CGRect)frame
                preferredFont:(UIFont *)font
           preferredTextColor:(UIColor *)textColor;

@end
