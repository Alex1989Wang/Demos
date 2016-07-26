//
//  UIView+Frame.m
//  彩票
//
//  Created by apple on 16/3/4.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

-(CGFloat)x{
    return self.frame.origin.x;
}

-(void)setX:(CGFloat)x{
    
    CGRect rect = self.frame;
    
    rect.origin.x = x;
    
    self.frame = rect;
}

-(CGFloat)y{
    return self.frame.origin.y;
}

-(void)setY:(CGFloat)y{
    CGRect rect = self.frame;
    
    rect.origin.y = y;
    
    self.frame = rect;
}

-(CGFloat)centerY{
    
    return self.center.y;
}

-(void)setCenterY:(CGFloat)centerY{
    
    CGPoint rect = self.center;
    
    rect.y = centerY;
    
    self.center = rect;
}

-(CGFloat)centerX{
    
    return self.center.x;
}

-(void)setCenterX:(CGFloat)centerX{
    
    CGPoint rect = self.center;
    
    rect.x = centerX;
    
    self.center = rect;
}



-(CGFloat)width{
    
    return self.frame.size.width;
}

-(void)setWidth:(CGFloat)width{
    
    CGRect rect = self.frame;
    
    rect.size.width = width;
    
    self.frame = rect;
}

-(CGFloat)height{
    
    return self.frame.size.height;
}

-(void)setHeight:(CGFloat)height{
    
    CGRect rect = self.frame;
    
    rect.size.height = height;
    
    self.frame = rect;
}
@end
