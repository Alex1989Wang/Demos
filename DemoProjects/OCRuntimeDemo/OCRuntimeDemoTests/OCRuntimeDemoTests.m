//
//  OCRuntimeDemoTests.m
//  OCRuntimeDemoTests
//
//  Created by JiangWang on 02/06/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSString+MJExtension.h"

@interface OCRuntimeDemoTests : XCTestCase

@end

@implementation OCRuntimeDemoTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testUnderlineFromCamel {
    NSString *sourceStr = @"XCTestDemoJIANG";
    NSString *result = @"xctest_demo_jiang";
    XCTAssertEqualObjects(result, [sourceStr mj_underlineFromCamel],
                          @"result should be equal.");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
