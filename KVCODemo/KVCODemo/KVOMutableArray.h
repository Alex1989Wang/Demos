//
//  KVOMutableArray.h
//  KVCODemo
//
//  Created by JiangWang on 08/11/2016.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KVOMutableArray : NSObject

@property (nonatomic, strong) NSMutableArray *array;

#pragma mark - KVO Methods
- (NSUInteger)countOfArray;
- (id)objectInArrayAtIndex:(NSUInteger)index;
- (void)removeObjectFromArrayAtIndex:(NSUInteger)index;
- (void)insertObject:(id)object inArrayAtIndex:(NSUInteger)index;
- (void)replaceObjectInArrayAtIndex:(NSUInteger)index withObject:(id)object;


@end
