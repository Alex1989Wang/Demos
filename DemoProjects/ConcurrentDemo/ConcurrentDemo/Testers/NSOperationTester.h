//
//  NSOperationTester.h
//  GCDDemo
//
//  Created by JiangWang on 21/04/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSOperationTester : NSObject
- (void)serialTest;
- (void)concurrentTest;
@end
