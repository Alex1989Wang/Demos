//
//  UIView+JWHighlightBorder.m
//  
//
//  Created by JiangWang on 29/07/2017.
//  Copyright © 2017 com.jiangwang All rights reserved.
//

#import "UIView+JWHighlightBorder.h"
@interface JWBorderLine : UIView
@end

@implementation JWBorderLine
@end

@implementation UIView (JWHighlightBorder)

- (void)setBorderLineWithPosition:(JWHighligtBorderPosition)linePosition {
    [self setBorderLineWithPosition:linePosition
                   borderLineInsets:UIEdgeInsetsZero];
}

- (void)setBorderLineWithPosition:(JWHighligtBorderPosition)linePosition
                 borderLineInsets:(UIEdgeInsets)lineInsets {
    [self setborderLineWithPosition:linePosition
                   borderLineInsets:lineInsets
                    borderLineHight:0.5f];
}

- (void)setborderLineWithPosition:(JWHighligtBorderPosition)linePosition
                 borderLineInsets:(UIEdgeInsets)lineInsets
                  borderLineHight:(CGFloat)lineWidth {
    [self setborderLineWithPosition:linePosition
                   borderLineInsets:lineInsets
                    borderLineHight:lineWidth
                borderLineLineColor:[UIColor grayColor]];
}

- (void)setborderLineWithPosition:(JWHighligtBorderPosition)linePosition
                 borderLineInsets:(UIEdgeInsets)lineInsets
                  borderLineHight:(CGFloat)borderLineWidth
              borderLineLineColor:(UIColor *)borderLineColor {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    //移除旧的sepearator
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[JWBorderLine class]]) {
            [subView removeFromSuperview];
        }
    }
    
    //顶部有separator
    if ((linePosition & JWHighligtBorderPositionTop)) {
        JWBorderLine *seperator = [[JWBorderLine alloc] init];
        seperator.backgroundColor = borderLineColor;
        [self addSubview:seperator];
        [seperator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(borderLineWidth);
            make.left.equalTo(self).with.mas_offset(lineInsets.left);
            make.right.equalTo(self).with.mas_offset(-lineInsets.right);
            make.top.equalTo(self);
        }];
    }
    
    //左边
    if ((linePosition & JWHighligtBorderPositionLeft)) {
        JWBorderLine *seperator = [[JWBorderLine alloc] init];
        seperator.backgroundColor = borderLineColor;
        [self addSubview:seperator];
        [seperator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(borderLineWidth);
            make.left.equalTo(self);
            make.top.equalTo(self).with.mas_offset(lineInsets.top);
            make.bottom.equalTo(self).with.mas_offset(-lineInsets.bottom);
        }];
    }
    
    //底部添加separator
    if ((linePosition & JWHighligtBorderPositionBottom)) {
        JWBorderLine *seperator = [[JWBorderLine alloc] init];
        seperator.backgroundColor = borderLineColor;
        [self addSubview:seperator];
        [seperator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(borderLineWidth);
            make.left.equalTo(self).with.mas_offset(lineInsets.left);
            make.right.equalTo(self).with.mas_offset(-lineInsets.right);
            make.bottom.equalTo(self);
        }];
    }
    
    //右边
    if ((linePosition & JWHighligtBorderPositionRight)) {
        JWBorderLine *seperator = [[JWBorderLine alloc] init];
        seperator.backgroundColor = borderLineColor;
        [self addSubview:seperator];
        [seperator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(borderLineWidth);
            make.right.equalTo(self);
            make.top.equalTo(self).with.mas_offset(lineInsets.top);
            make.bottom.equalTo(self).with.mas_offset(-lineInsets.bottom);
        }];
    }
    [CATransaction commit];
}
@end
