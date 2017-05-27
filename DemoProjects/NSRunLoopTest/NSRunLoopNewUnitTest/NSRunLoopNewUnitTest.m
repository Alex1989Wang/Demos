//
//  NSRunLoopNewUnitTest.m
//  NSRunLoopNewUnitTest
//
//  Created by JiangWang on 26/05/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface NSRunLoopNewUnitTest : XCTestCase

@end

@implementation NSRunLoopNewUnitTest
+ (void)setUp {
    //class setup method
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    //setup code helps you gather infomation or app states for later test methods;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

+ (void)tearDown {
    //class tearDown method;
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    XCTAssertEqualObjects(@"10", @"0", @"They should be equal.");
}

- (void)DISABLED_testExample {
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

// all test methods are written in this way.
- (void)testXXX {
    
}


@end
