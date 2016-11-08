//
//  Children.m
//  KVCODemo
//
//  Created by JiangWang on 06/11/2016.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "Children.h"

@implementation Children

- (instancetype)init
{
    self = [super init];
    if (self) {
        _name = @"";
        _age = 0;
    }
    return self;
}


+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key
{
    if ([key isEqualToString:@"name"])
    {
        return NO;
    }
    else
    {
        return [super automaticallyNotifiesObserversForKey:key];
    }
}

- (void)setName:(NSString *)name
{
    if (![_name isEqualToString:name])
    {
        [self willChangeValueForKey:@"name"];
        _name = name;
        [self didChangeValueForKey:@"name"];
    }
}

@end
