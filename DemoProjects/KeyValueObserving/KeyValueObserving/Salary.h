//
//  Salary.h
//  KeyValueObserving
//
//  Created by JiangWang on 16/7/26.
//  Copyright © 2016年 JiangWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Salary : NSObject

@property (nonatomic, assign) CGFloat theNewValueToBeObserved;

@property (nonatomic, assign) CGFloat oldValueToBeObserved;

/* an array to be oberseved*/
@property (nonatomic, strong) NSArray *array;

#pragma mark - initialization
- (instancetype)initWithNewValue:(CGFloat)newValue oldValue:(CGFloat)old;

@end
