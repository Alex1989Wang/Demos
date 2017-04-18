//
//  ViewController.m
//  RunTimePractice
//
//  Created by JiangWang on 23/03/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>

static NSString *const kTestAssociateKey = @"kTestAssociateKey";

@interface ViewController ()
@property (nonatomic, weak) UILabel *infoLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self infoLabel];

    [self runtimeTest];
}

#pragma mark - Test
- (void)runtimeTest {
    NSNumber *storedNumber = @(5687);
    objc_setAssociatedObject(self, &kTestAssociateKey, storedNumber, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    NSNumber *getStoredNumber = objc_getAssociatedObject(self, &kTestAssociateKey);
    unsigned int count = 0;
    Ivar *result = class_copyIvarList([self class], &count);
    NSString *iVarsInfo = [NSString string];
    for (NSInteger index = 0; index < count; index++) {
        const char *iVarName = ivar_getName(result[index]);
        NSString *ivarName = [NSString stringWithCString:iVarName encoding:NSUTF8StringEncoding];
        iVarsInfo = [iVarsInfo stringByAppendingFormat:@"%@\n", ivarName];
    }
    free(result);
    
    if ([getStoredNumber isKindOfClass:[NSNumber class]]) {
        iVarsInfo = [iVarsInfo stringByAppendingFormat:@"%ld", [getStoredNumber integerValue]];
    }
    self.infoLabel.text = iVarsInfo;
}

- (void)numberFormatterTest {
    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
    currencyFormatter.numberStyle = kCFNumberFormatterCurrencyStyle;
    currencyFormatter.locale = [NSLocale currentLocale];
    currencyFormatter.decimalSeparator = @"?";
    currencyFormatter.positivePrefix = @"?";
    currencyFormatter.currencySymbol = @"RMB";
    currencyFormatter.paddingCharacter = @"\t";
    currencyFormatter.paddingPosition = NSNumberFormatterPadAfterPrefix;
    
    
    NSNumber *testNumber = [NSNumber numberWithInteger:123414];
    NSString *formattedNumberStr = [currencyFormatter stringFromNumber:testNumber];
    self.infoLabel.text = formattedNumberStr;
    NSLog(@"formatted string: %@", formattedNumberStr);
}

#pragma mark - Lazy Loading
- (UILabel *)infoLabel {
    if (nil == _infoLabel) {
        UILabel *infoLabel = [[UILabel alloc] init];
        infoLabel.numberOfLines = 0;
        infoLabel.textColor = [UIColor blackColor];
        infoLabel.font = [UIFont systemFontOfSize:14.f];
        infoLabel.textAlignment = NSTextAlignmentCenter;
        infoLabel.frame = self.view.bounds;
        _infoLabel = infoLabel;
        [self.view addSubview:infoLabel];
    }
    return _infoLabel;
}

@end
