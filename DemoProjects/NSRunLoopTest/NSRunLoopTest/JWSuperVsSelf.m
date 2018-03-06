//
//  JWSuperVsSelf.m
//  NSRunLoopTest
//
//  Created by JiangWang on 28/02/2018.
//  Copyright © 2018 JiangWang. All rights reserved.
//

#import "JWSuperVsSelf.h"

@implementation JWSuper

@end

@implementation JWSelf

- (instancetype)init {
    self = [super init];
    if (self) {
        NSLog(@"super class: %@", [super class]);
        NSLog(@"self class: %@", [self class]);
        NSLog(@"super class: %@", [self superclass]);
    }
    return self;
}

@end
