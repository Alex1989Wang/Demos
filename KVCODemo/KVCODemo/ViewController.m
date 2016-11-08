//
//  ViewController.m
//  KVCODemo
//
//  Created by JiangWang on 06/11/2016.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "ViewController.h"
#import "Children.h"

static void *childOneCtx = &childOneCtx;
static void *childTwoCtx = &childTwoCtx;

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
    
    self.childTwo = [[Children alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSKeyValueObservingOptions options =
    NSKeyValueObservingOptionNew |
    NSKeyValueObservingOptionOld;
    [self.childOne addObserver:self
                    forKeyPath:@"name"
                       options:options
                       context:childOneCtx];
    [self.childOne addObserver:self
                    forKeyPath:@"age"
                       options:options
                       context:childOneCtx];
    [self.childTwo addObserver:self
                    forKeyPath:@"age"
                       options:options
                       context:childTwoCtx];
    
    
    //赋值
    [self.childOne setValue:@(28) forKey:@"age"];
    [self.childTwo setValue:@(30) forKey:@"age"];
    
    self.childOne.name = @"Michelle";
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"name"])
    {
        NSLog(@"changed key path: %@", keyPath);
        NSLog(@"change dictionary: %@", change);
        return;
    }
    
    if ([keyPath isEqualToString:@"age"])
    {
        if (context == childOneCtx) {
            NSLog(@"child one's change");
        }
        
        if (context == childTwoCtx) {
            NSLog(@"child two's change");
        }
        NSLog(@"changed key path: %@", keyPath);
        NSLog(@"change dictionary: %@", change);
    }
}


@end
