//
//  XDNumberAnimationView.h
//  drawRect
//
//  Created by JiangWang on 8/7/16.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDNumberAnimationView : UIView

/* 需要绘制和显示的总数 */
@property (nonatomic, assign) NSUInteger numberTotal;

/**
 *  根据位置实例化一个数字动画view
 *
 *  @param position 需要放置数字动画view的位置
 *
 *  @return 数字动画view
 */
- (instancetype)initWithPosition:(CGPoint)position;


/**
 *  传入一个number，绘制和渲染出来 - 是否需要缩放动画
 *
 *  @param num    传入的number
 *  @param change 是否需要缩放
 */
- (void)drawNum:(NSUInteger)num withSizeChange:(BOOL)change;

@end
