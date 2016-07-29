//
//  UIView+Frame.h
//  彩票
//
//  Created by apple on 16/3/4.
//  Copyright © 2016年 apple. All rights reserved.


/*
 
 分类注意点：
        
        分类中@property不会自动生成带下划线的成员变量，只生成get set方法
 */

#import <UIKit/UIKit.h>

@interface UIView (Frame)

/*
 * 控件的X
 */
@property CGFloat x;
/*
 * 控件的Y
 */
@property CGFloat y;
/*
 * 控件的宽度
 */
@property CGFloat width;
/*
 * 控件的高度
 */
@property CGFloat height;

/*
 * 控件的中心X
 */
@property CGFloat centerX;
/*
 * 控件的中心Y
 */
@property CGFloat centerY;
@end
