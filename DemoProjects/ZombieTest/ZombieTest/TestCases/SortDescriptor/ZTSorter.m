//
//  ZTSorter.m
//  ZombieTest
//
//  Created by JiangWang on 2019/10/15.
//  Copyright © 2019 JiangWang. All rights reserved.
//

#import "ZTSorter.h"
#import "ZTSortObject.h"

@interface ZTSorter()
@property (nonatomic, strong) NSArray<ZTSortObject *> *objects;
@end

@implementation ZTSorter

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    static ZTSorter *sorter = nil;
    dispatch_once(&onceToken, ^{
        sorter = [[ZTSorter alloc] init];
    });
    return sorter;
}

- (void)simulateSorting {
    NSMutableArray *muatable = [NSMutableArray array];
    for (NSInteger index = 0; index < 100000; index++) {
        [muatable addObject:[[ZTSortObject alloc] init]];
    }
    self.objects = [muatable copy];
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        NSSortDescriptor *dateDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"createdDate" ascending:YES];
        NSArray<ZTSortObject *> *sorted = [muatable sortedArrayUsingDescriptors:@[dateDescriptor]];
        for (ZTSortObject *object in muatable) {
            NSTimeInterval value = [object.createdDate timeIntervalSince1970];
            NSLog(@"time interval: %f", value);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.objects = sorted;
        });
    });
}

- (void)simulateObjectDateChange {
    for (ZTSortObject *object in self.objects) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
            [object reload];
        });
    }
}

@end
