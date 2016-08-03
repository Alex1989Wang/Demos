//
//  ViewController.m
//  KeyValueObserving
//
//  Created by JiangWang on 16/7/26.
//  Copyright © 2016年 JiangWang. All rights reserved.
//

#import "ViewController.h"
#import "Salary.h"
#import "XDDataCenter.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *displayLabel;

@property (nonatomic, strong) XDDataCenter *center;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self instantiateSalaryAndObserve];
    
    XDUserIndentityType defaultType;
    
    NSLog(@"the default type is: %lu", defaultType);
}


- (void)instantiateSalaryAndObserve {

    self.center = [XDDataCenter sharedDataCenter];
    
    [self.center addObserver:self forKeyPath:@"salary.theNewValueToBeObserved" options:NSKeyValueObservingOptionNew];
    [self.center addObserver:self forKeyPath:@"salary.theNewValueToBeObserved" options:NSKeyValueObservingOptionNew];
    [self.center addObserver:self forKeyPath:@"salary.theNewValueToBeObserved" options:NSKeyValueObservingOptionNew];
    [self.center addObserver:self forKeyPath:@"salary.theNewValueToBeObserved" options:NSKeyValueObservingOptionNew];
    [self.center addObserver:self forKeyPath:@"salary.theNewValueToBeObserved" options:NSKeyValueObservingOptionNew];
    [self.center addObserver:self forKeyPath:@"salary.theNewValueToBeObserved" options:NSKeyValueObservingOptionNew];
    [self.center addObserver:self forKeyPath:@"salary.theNewValueToBeObserved" options:NSKeyValueObservingOptionNew];
    [self.center addObserver:self forKeyPath:@"salary.theNewValueToBeObserved" options:NSKeyValueObservingOptionNew];
    [self.center addObserver:self forKeyPath:@"salary.theNewValueToBeObserved" options:NSKeyValueObservingOptionNew];
    [self.center addObserver:self forKeyPath:@"salary.theNewValueToBeObserved" options:NSKeyValueObservingOptionNew];
    [self.center addObserver:self forKeyPath:@"salary.theNewValueToBeObserved" options:NSKeyValueObservingOptionNew];
    [self.center addObserver:self forKeyPath:@"salary.theNewValueToBeObserved" options:NSKeyValueObservingOptionNew];

}

#pragma mark - key value observing methods
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {

    
    
}



@end
