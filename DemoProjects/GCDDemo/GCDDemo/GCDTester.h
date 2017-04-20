//
//  GCDTester.h
//  GCDDemo
//
//  Created by JiangWang on 20/04/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCDTester : NSObject

/**
 Test Serial Queue
 */
- (void)serialTest;

/**
 Test barrier block behavior on a private concurrent queue.
 */
- (void)barrierTest;
@end
