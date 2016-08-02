//
//  ViewController.m
//  Array
//
//  Created by JiangWang on 8/2/16.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "ViewController.h"
#import "TestObject.h"

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray<TestObject *> *testArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TestObject *objectOne = [[TestObject alloc] init];
    objectOne.name = @"jiang";
    
    TestObject *objectTwo = [[TestObject alloc] init];
    objectTwo.name = @"chun";
    
    TestObject *objectThree = [[TestObject alloc] init];
    objectThree.name = @"wang";
    
    TestObject *objectFour = [[TestObject alloc] init];
    objectFour.name = @"hong";
    
    TestObject *objectFive = [[TestObject alloc] init];
    objectThree.name = @"wang";
    
    self.testArray = [NSMutableArray arrayWithObjects: objectOne, objectTwo, objectThree, objectFour, objectFive,nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    __block TestObject *returnObject = nil;
    
    [self.testArray enumerateObjectsUsingBlock:^(TestObject *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.name isEqualToString:@"wang"]) {
            returnObject = obj;
            *stop = YES;
        }
    }];
    
    
    NSLog(@"test array before deletion: %@", self.testArray);
    
    //delete
    [self.testArray removeObject:returnObject];
    
    NSLog(@"test array after deletion: %@", self.testArray);
    
    NSLog(@"what about the return value: %@", returnObject);
}

@end
