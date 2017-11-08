//
//  UIView+JWHighlightBorder.h
//  
//
//  Created by JiangWang on 29/07/2017.
//  Copyright © 2017 com.jiangwang All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 给表视图添加边界线

 - JWTableCellborderLinePositionNone: 不添加分割线
 - JWTableCellborderLinePositionTop: 将分割线添加在上部
 - JWTableCellborderLinePositionBottom: 将分割线添加在下部
 */
typedef NS_ENUM(NSUInteger, JWHighligtBorderPosition) {
    JWHighligtBorderPositionNone = 0,
    JWHighligtBorderPositionTop = 1 << 0,
    JWHighligtBorderPositionLeft = 1 << 1,
    JWHighligtBorderPositionBottom = 1 << 2,
    JWHighligtBorderPositionRight = 1 << 3,
};

@interface UIView (JWHighlightBorder)
/**
 设置宽度为1px
 使用color_line默认颜色
 没有inset

 @param linePosition 需要设置的边际色的位置
 */
- (void)setBorderLineWithPosition:(JWHighligtBorderPosition)linePosition;

/**
 为UIview设置边界颜色
 设置宽度为1px的分割线
        
 @param linePosition 分割线设置的位置
 @param borderLineInsets 分割线的insets
 */
- (void)setBorderLineWithPosition:(JWHighligtBorderPosition)linePosition
                 borderLineInsets:(UIEdgeInsets)lineInsets;

/**
 为UIview设置边界颜色
 使用color_line默认颜色

 @param linePosition 分割线位置
 @param borderLineInsets 分割线的insets
 @param borderLineWidth 分割线宽度
 */
- (void)setborderLineWithPosition:(JWHighligtBorderPosition)linePosition
                 borderLineInsets:(UIEdgeInsets)lineInsets
                  borderLineHight:(CGFloat)lineWidth;

/**
 为UIview设置边界颜色

 @param linePosition 分割线位置
 @param borderLineInsets 分割线的insets
 @param borderLineWidth 分割线宽度
 @param borderLineColor 分割线颜色
 @note: borderLineInsets 只会有左右inset值(上下边界）
 borderLineInsets 只会有上下inset值(左右边界）
 */
- (void)setborderLineWithPosition:(JWHighligtBorderPosition)linePosition
                 borderLineInsets:(UIEdgeInsets)lineInsets
              borderLineHight:(CGFloat)borderLineWidth
              borderLineLineColor:(UIColor *)borderLineColor;
@end
