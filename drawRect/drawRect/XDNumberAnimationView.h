//
//  drawRectTestView.h
//  drawRect
//
//  Created by JiangWang on 8/7/16.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDNumberAnimationView : UIView

@property (nonatomic, assign) NSUInteger numberToDraw;

- (instancetype)initWithPosition:(CGPoint)position;

@end
