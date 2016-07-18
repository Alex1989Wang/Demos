//
//  QQMessageModel.m
//  QQUI
//
//  Created by JiangWang on 16/4/29.
//  Copyright © 2016年 JiangWang. All rights reserved.
//

#import "QQMessageModel.h"

@implementation QQMessageModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)qqMessageModelWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

@end
