//
//  ViewController.m
//  emumerateUsingblock
//
//  Created by JiangWang on 8/6/16.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSArray<NSString *> *testArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *testArray = @[@"jiang", @"wang", @"chun"];
    
    self.testArray = testArray;
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    
//    [self.testArray enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        
//        if ([obj isEqualToString:@"wang"]) {
//            *stop = YES;
//        }
//        return;
//    }];
//    
//    return;
//    
//    
//    NSLog(@"test array: %@", self.testArray);
//    
//}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    for (NSString *str in self.testArray) {
        if ([str isEqualToString:@"wang"]) {
            continue;
        }
    }
    
    NSLog(@"test array: %@", self.testArray);
}

@end
