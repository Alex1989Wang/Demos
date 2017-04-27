//
//  TestOperationQueueManager.m
//  ConcurrentDemo
//
//  Created by JiangWang on 26/04/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "TestOperationQueueManager.h"
@interface TestOperationQueueManager()
@property (nonatomic, strong) NSOperationQueue *APIQueue;
@end;

@implementation TestOperationQueueManager

+ (TestOperationQueueManager *)sharedManager {
    static TestOperationQueueManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[TestOperationQueueManager alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.APIQueue = [[NSOperationQueue alloc] init];
    }
    return self;
}

- (void)addOperation:(NSOperation *)operation {
    if ([operation isKindOfClass:[TestOperation class]]) {
        [operation addObserver:self
                    forKeyPath:@"isFinished"
                       options:NSKeyValueObservingOptionNew
                       context:NULL];
        [operation addObserver:self
                    forKeyPath:@"isReady"
                       options:NSKeyValueObservingOptionNew
                       context:NULL];
        [operation addObserver:self
                    forKeyPath:@"isExecuting"
                       options:NSKeyValueObservingOptionNew
                       context:NULL];
        
    }
    [self.APIQueue addOperation:operation];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    id newValue = change[NSKeyValueChangeNewKey];
    if ([keyPath isEqualToString:@"isFinished"] &&
        [newValue respondsToSelector:@selector(boolValue)]) {
        if ([newValue boolValue]) {
            NSLog(@"operation finished.");
            [object removeObserver:self
                        forKeyPath:@"isReady"];
            [object removeObserver:self
                        forKeyPath:@"isExecuting"];
            [object removeObserver:self
                        forKeyPath:@"isFinished"];
        }
    }
    else if ([keyPath isEqualToString:@"isReady"] &&
        [newValue respondsToSelector:@selector(boolValue)]) {
        if ([newValue boolValue]) {
            NSLog(@"operation ready.");
        }
    }
    else if ([keyPath isEqualToString:@"isExecuting"] &&
             [newValue respondsToSelector:@selector(boolValue)]) {
        if ([newValue boolValue]) {
            NSLog(@"operation executing.");
        }
    }
}
@end
