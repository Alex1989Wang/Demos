//
//  drawRectTestView.h
//  drawRect
//
//  Created by JiangWang on 8/7/16.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDNumberAnimationView : UIView

/* 需要绘制和显示的总数 */
@property (nonatomic, assign) NSUInteger numberTotal;


- (instancetype)initWithPosition:(CGPoint)position;

@end
