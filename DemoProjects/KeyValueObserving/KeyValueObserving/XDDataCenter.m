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

@property (nonatomic, strong) NSMutableArray<Salary *> *salaryCollection;

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
        
        [self.salaryCollection addObject:_salary];
        
        _notiTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(timerTicked) userInfo:nil repeats:YES];
    }
    
    return self;
}

- (void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options {
    if ([keyPath isEqualToString:@"salary.theNewValueToBeObserved"]) {
        [_salary addObserver:observer forKeyPath:@"theNewValueToBeObserved" options:options context:NULL ];
    }
    
    if ([keyPath isEqualToString:@"salaryCollection"]) {
        [self addObserver:observer forKeyPath:@"salaryCollection" options:options context:NULL];
    }
}

- (void)addObserver:(id)observer forKey:(NSString *)key {
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:@selector(handleMutableArrayChange:) name:key object:nil];
}


- (void)timerTicked {
//    Salary *newlyAddedSalary = [[Salary alloc] initWithNewValue:100 oldValue:200];
//    NSMutableArray *salaryCollectionProxy = [self mutableArrayValueForKey:@"salaryCollection"];
//    
//    [salaryCollectionProxy insertObject:newlyAddedSalary atIndex:0];
//    
//    Salary *anotherSalaryReplacement = [[Salary alloc] initWithNewValue:200 oldValue:300];
//    [salaryCollectionProxy replaceObjectAtIndex:1 withObject:anotherSalaryReplacement];
//    
//    [salaryCollectionProxy removeObjectAtIndex:0];
    
    
    NSDictionary *userinfo = @{
                               @"new" : self.salaryCollection,
                               @"change" : @"inserting"
                               };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mutableArray" object:nil userInfo:userinfo];
}

- (void)timerTickedTestOne {
    _salary.theNewValueToBeObserved += 500;
}

- (NSMutableArray<Salary *> *)salaryCollection {
    if (nil == _salaryCollection) {
        
        _salaryCollection = [NSMutableArray array];
        
    }
    
    return _salaryCollection;
}


@end
