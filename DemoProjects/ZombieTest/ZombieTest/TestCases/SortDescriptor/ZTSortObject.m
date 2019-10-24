//
//  ZTSortObject.m
//  ZombieTest
//
//  Created by JiangWang on 2019/10/15.
//  Copyright © 2019 JiangWang. All rights reserved.
//

#import "ZTSortObject.h"

@implementation ZTSortObject

static NSTimeInterval counter = 0;

- (instancetype)init {
    self = [super init];
    if (self) {
        counter += 100;
        _createdDate = [NSDate dateWithTimeIntervalSinceReferenceDate:counter];
    }
    return self;
}

- (void)reload {
    _createdDate = [NSDate dateWithTimeIntervalSinceReferenceDate:counter];
}

@end
