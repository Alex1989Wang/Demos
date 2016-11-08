//
//  KVOMutableArray.m
//  KVCODemo
//
//  Created by JiangWang on 08/11/2016.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "KVOMutableArray.h"

@implementation KVOMutableArray

- (instancetype)init
{
    self = [super init];
    if (self) {
        _array = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSUInteger)countOfArray
{
    return self.array.count;
}

- (id)objectInArrayAtIndex:(NSUInteger)index
{
    return [self.array objectAtIndex:index];
}

- (void)insertObject:(id)object
      inArrayAtIndex:(NSUInteger)index
{
    [self.array insertObject:object atIndex:index];
}

- (void)removeObjectFromArrayAtIndex:(NSUInteger)index
{
    [self.array removeObjectAtIndex:index];
}

- (void)replaceObjectInArrayAtIndex:(NSUInteger)index
                         withObject:(id)object
{
    [self.array replaceObjectAtIndex:index withObject:object];
}


@end
