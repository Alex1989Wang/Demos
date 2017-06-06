//
//  Gift.h
//  OCRuntimeDemo
//
//  Created by JiangWang on 05/06/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DemoObject.h"
@class Money;

@interface Gift : DemoObject
@property (nonatomic, strong) NSNumber *giftID;
@property (nonatomic, copy) NSString *giftName;
@property (nonatomic, assign) NSUInteger count;
@property (nonatomic, strong) Money *price;
@end
