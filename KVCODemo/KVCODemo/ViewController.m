//
//  ViewController.m
//  KVCODemo
//
//  Created by JiangWang on 06/11/2016.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "ViewController.h"
#import "Children.h"

@interface ViewController ()

@property (nonatomic, strong) Children *childOne;
@property (nonatomic, strong) Children *childTwo;
@property (nonatomic, strong) Children *childThree;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.childOne = [[Children alloc] init];
    
    [self.childOne setValue:@"Jiang" forKey:@"name"];
    [self.childOne setValue:@(27) forKey:@"age"];
    
    
    self.childOne.child = [[Children alloc] init];
    [self.childOne setValue:@"chun" forKeyPath:@"child.name"];
    [self.childOne setValue:@(28) forKeyPath:@"child.age"];
    
    NSLog(@"child one's child's name: %@ and age: %@",
          [self.childOne.child valueForKeyPath:@"name"],
          [self.childOne.child valueForKeyPath:@"age"]);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
