//
//  XDThumbnailMessage.m
//  ChatDemo
//
//  Created by JiangWang on 7/5/16.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "XDThumbnailMessage.h"

@implementation XDThumbnailMessage

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)thumbnailMessageWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

@end
