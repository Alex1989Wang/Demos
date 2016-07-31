//
//  XDDataCenter.m
//  KeyValueObserving
//
//  Created by JiangWang on 7/31/16.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "XDDataCenter.h"
#import "Salary.h"

@interface XDDataCenter()

@property (nonatomic, strong) Salary *salary;

@property (nonatomic, strong) NSTimer *notiTimer;

@end

@implementation XDDataCenter

+ (instancetype)sharedDataCenter {
    
    static XDDataCenter *sharedCenter;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCenter = [[XDDataCenter alloc] init];
    });
    
    return sharedCenter;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _salary = [[Salary alloc] initWithNewValue:5000 oldValue:6000];
        
        _notiTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(timerTicked) userInfo:nil repeats:YES];
    }
    
    return self;
}

- (void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options {
    if ([keyPath isEqualToString:@"salary.theNewValueToBeObserved"]) {
        [_salary addObserver:observer forKeyPath:@"theNewValueToBeObserved" options:options context:NULL ];
    }
}


- (void)timerTicked {
    _salary.theNewValueToBeObserved += 500;
}


@end
