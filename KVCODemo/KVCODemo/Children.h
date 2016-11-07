//
//  Children.h
//  KVCODemo
//
//  Created by JiangWang on 06/11/2016.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Children : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSUInteger age;

@property (nonatomic, strong) Children *child;

@end
