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
@property (nonatomic, strong) NSDictionary *immutable;

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
    
    
    /* dictionary */
    NSMutableDictionary *immutable = [NSMutableDictionary dictionary];
    for (NSUInteger index = 0; index < 200; index ++) {
        [immutable setObject:@(index) forKey:[NSString stringWithFormat:@"key%ld", index]];
    }
    
    self.immutable = [immutable copy];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"false key object: %d", [self.dict objectForKey:falseKey] != nil);
    
    NSLog(@"false key bool value: %d", [[self.dict objectForKey:falseKey] boolValue]);
    
    NSMutableDictionary *mutablePointToImmutable = [self.immutable mutableCopy];
    [mutablePointToImmutable setObject:@"can i set this" forKey:testKey];
    
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    for (NSUInteger repeat = 0; repeat < 2000; repeat ++) {
        NSMutableDictionary *dict = [self.immutable mutableCopy];
        NSLog(@"%@", dict);
    }
}

@end
