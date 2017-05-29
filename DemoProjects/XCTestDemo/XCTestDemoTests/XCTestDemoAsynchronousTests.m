//
//  XCTestDemoAsynchronousTests.m
//  XCTestDemo
//
//  Created by JiangWang on 29/05/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DemoSearchManager.h"

@interface XCTestDemoAsynchronousTests : XCTestCase

@end

@implementation XCTestDemoAsynchronousTests

- (void)testAsynchronousSearch {
    XCTestExpectation *expectation =
    [self expectationWithDescription:@"XCTestDemo.asynchronousSearch"];
    
    NSString *myName = @"Alex1989Wang"; //my github user account
    //This test doesn't take networking reachability into account.
    [[DemoSearchManager sharedManager] getUserInfoWithUserName:myName
                                                     completed:
     ^(NSData *userInfoData) {
         XCTAssertNotNil(userInfoData, @"my account definitely exists.");
         [expectation fulfill];
     }];
    
    //wait for expection for 2 seconds
    [self waitForExpectationsWithTimeout:2.0
                                 handler:nil]; 
}


@end
