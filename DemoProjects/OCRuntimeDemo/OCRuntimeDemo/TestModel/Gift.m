//
//  Gift.m
//  OCRuntimeDemo
//
//  Created by JiangWang on 05/06/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "Gift.h"
#import "Money.h"

@implementation Gift

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    NSLog(@"resolve instance method called.");
    return [super resolveInstanceMethod:sel];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    NSLog(@"forward target for selector.");
    if (aSelector == @selector(priceInUSD)) {
        return self.price;
    }
    else {
        return [super forwardingTargetForSelector:aSelector];
    }
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSLog(@"forward invacation called.");
    if (anInvocation.selector == @selector(priceInUSD)) {
        [anInvocation invokeWithTarget:self.price];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSLog(@"method signature for selector.");
    if (aSelector == @selector(priceInUSD)) {
        NSMethodSignature *mthdSig =
        [self.price methodSignatureForSelector:@selector(priceInUSD)];
        return mthdSig;
    }
    else {
        return [super methodSignatureForSelector:aSelector];
    }
}
@end
