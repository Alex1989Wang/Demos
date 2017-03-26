//
//  Salary.m
//  KeyValueObserving
//
//  Created by JiangWang on 16/7/26.
//  Copyright © 2016年 JiangWang. All rights reserved.
//

#import "Salary.h"

@implementation Salary

- (instancetype)initWithNewValue:(CGFloat)newValue oldValue:(CGFloat)old {
    self = [super init];
    
    if (self) {
        _theNewValueToBeObserved = newValue;
        _oldValueToBeObserved = old;
        
        _array = @[@"string 01", @"String 02", @"String 03"];
    }
    
    return self;
}

@end
