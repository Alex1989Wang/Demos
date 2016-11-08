//
//  Children.h
//  KVCODemo
//
//  Created by JiangWang on 06/11/2016.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KVOMutableArray.h"

@interface Children : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSUInteger age;

@property (nonatomic, strong) Children *child;

/* array in KVO */
@property (nonatomic, strong) NSMutableArray *siblings;
@property (nonatomic, strong) KVOMutableArray *cousins;

#pragma mark - KVO methods for mutable array
- (NSUInteger)countOfSiblings;
- (id)objectInSiblingsAtIndex:(NSUInteger)index;
- (void)insertObject:(NSString *)object inSiblingsAtIndex:(NSUInteger)index;
- (void)removeObjectFromSiblingsAtIndex:(NSUInteger)index;

@end
