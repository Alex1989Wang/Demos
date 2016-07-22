//
//  ViewController.m
//  DictionaryAndBool
//
//  Created by JiangWang on 7/22/16.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSMutableDictionary *dict;

@end

static NSString *const testKey = @"testKey";
static NSString *const falseKey = @"falseKey";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableDictionary *presentSettings = [NSMutableDictionary dictionary];
    [presentSettings setObject:@(YES) forKey:testKey];
    
    [presentSettings setObject:@(0) forKey:falseKey];
    
    self.dict = presentSettings;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"false key object: %d", [self.dict objectForKey:falseKey] != nil);
    
    NSLog(@"false key bool value: %d", [[self.dict objectForKey:falseKey] boolValue]);
    
}

@end
