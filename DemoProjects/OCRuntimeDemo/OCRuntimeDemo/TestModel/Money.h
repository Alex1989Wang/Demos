//
//  Money.h
//  OCRuntimeDemo
//
//  Created by JiangWang on 05/06/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, DemoCurrency) {
    DemoCurrencyTypeRMB,
    DemoCurrencyUSD,
};

@interface Money : NSObject
@property (nonatomic, assign) DemoCurrency currency;
@property (nonatomic, assign) double amount;

/**
 price in usd;

 @return price in usd;
 */
- (double)priceInUSD;
@end
