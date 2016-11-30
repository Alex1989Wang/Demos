//
//  DemoSearchBar.m
//  UISearchControllerDemo
//
//  Created by JiangWang on 15/11/2016.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "DemoSearchBar.h"

@implementation DemoSearchBar

#pragma mark - Initialization
- (instancetype)initWithFrame:(CGRect)frame
                preferredFont:(UIFont *)font
           preferredTextColor:(UIColor *)textColor
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _preferredFont = font;
        _preferredTextColor = textColor;
        self.searchBarStyle = UISearchBarStyleProminent;
        self.translucent = NO;
    }
    return self;
}


- (NSUInteger)indexOfTextFieldInSearchBar
{
    __block NSUInteger index = 0;
    UIView *searchBarView = self.subviews[0];
    [searchBarView.subviews enumerateObjectsUsingBlock:
     ^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         if ([obj isKindOfClass:[UITextField class]])
         {
             index = idx;
             *stop = YES;
         }
     }];
    return index;
}


- (NSUInteger)indexOfCancelButton
{
    __block NSUInteger index = 0;
    UIView *searchBarView = self.subviews[0];
    [searchBarView.subviews enumerateObjectsUsingBlock:
     ^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         if ([obj isKindOfClass:[UIButton class]])
         {
             index = idx;
             *stop = YES;
         }
     }];
    return index;
}



- (void)drawRect:(CGRect)rect
{
    NSUInteger indexOfSearchField = [self indexOfTextFieldInSearchBar];
    
    UIView *searchBarView = self.subviews[0];
    UITextField *searchField = nil;
    if (searchBarView.subviews.count >= indexOfSearchField)
    {
        searchField = searchBarView.subviews[indexOfSearchField];
        if ([searchField isKindOfClass:[UITextField class]])
        {
            searchField.frame =
            CGRectMake(5, 5, self.bounds.size.width - 10, self.bounds.size.height - 10);
            searchField.font = self.preferredFont;
            searchField.textColor = self.preferredTextColor;
            searchField.backgroundColor = [UIColor grayColor];
            searchField.leftViewMode = UITextFieldViewModeNever;
            CGSize searchFieldSize = searchField.bounds.size;
            [searchField drawPlaceholderInRect:
             CGRectMake(0, 0, searchFieldSize.width - 100, searchFieldSize.height)];
        }
    }
    
    if (searchBarView.subviews.count >= [self indexOfCancelButton])
    {
        UIButton *cancelBtn = searchBarView.subviews[[self indexOfCancelButton]];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    }
    
    
    //底部自定义线条
    CGPoint startPoint = CGPointMake(0, self.bounds.size.height);
    CGPoint endPoint = CGPointMake(self.bounds.size.width, self.bounds.size.height);
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:startPoint];
    [path addLineToPoint:endPoint];
    
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = self.preferredTextColor.CGColor;
    shapeLayer.lineWidth = 2.5f;
    
    [self.layer addSublayer:shapeLayer];
    
    [super drawRect:rect];
}

@end
