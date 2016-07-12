//
//  EdgeInsetsLabel.m
//  LabelWithEdgeInsets
//
//  Created by JiangWang on 7/11/16.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "EdgeInsetsLabel.h"

@implementation EdgeInsetsLabel


//rewrite the bounding rect method
- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    NSLog(@"label frame: %@", NSStringFromCGRect(self.frame));
    NSLog(@"label center: %@ --- screen center: %f", NSStringFromCGPoint(self.center), [UIScreen mainScreen].bounds.size.width * 0.5);
    
    //use the user-defined labelEdgeInsets;
    UIEdgeInsets insets = self.labelEdgeInsets;
    
    CGRect originalRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    
    originalRect.size.height += (insets.top + insets.bottom);
    originalRect.size.width += (insets.left + insets.right);
    
    NSLog(@"original rect: %@", NSStringFromCGRect(originalRect));
    
    return originalRect;
}


- (void)drawTextInRect:(CGRect)rect {
    NSLog(@"rect before ajustment: %@", NSStringFromCGRect(rect));
    
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.labelEdgeInsets)];
    NSLog(@"rect after ajustment: %@", NSStringFromCGRect(UIEdgeInsetsInsetRect(rect, self.labelEdgeInsets)));
//    [super drawTextInRect:rect];
}

@end
