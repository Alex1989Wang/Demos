//
//  ViewController.m
//  OCRuntimeDemo
//
//  Created by JiangWang on 02/06/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "Gift.h"
#import "Money.h"

@interface ViewController ()
@property (nonatomic, strong) Gift *testGift;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    uint propertyCount = 0;
    objc_property_t *propertyList = class_copyPropertyList([self.testGift class], &propertyCount);
    
    while (propertyCount) {
//        NSLog(@"property: %s \n"
//              "property attributes: %s",
//              property_getName(*propertyList),
//              property_getAttributes(*propertyList));
        propertyCount--;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.testGift isObjectRound];
    [(id)self.testGift priceInUSD];
}

#pragma mark - Lazy Loading
- (Gift *)testGift {
    if (_testGift == nil) {
        Gift *newGift = [[Gift alloc] init];
        newGift.giftID = [NSNumber numberWithInt:1313414];
        newGift.giftName = @"testdata_gift";
        newGift.count = 1;
        Money *price = [[Money alloc] init];
        price.currency = DemoCurrencyTypeRMB;
        price.amount = 1000;
        newGift.price = price;
        _testGift = newGift;
    }
    return _testGift;
}

@end
