//
//  XCTestDemoPerformanceTest.m
//  XCTestDemo
//
//  Created by JiangWang on 30/05/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DemoUser.h"

@interface XCTestDemoPerformanceTest : XCTestCase

@end

@implementation XCTestDemoPerformanceTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testJsonSerializationPerformance {
    NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
    NSString *userInfoFile = [testBundle pathForResource:@"Alex1989Wang" ofType:@".plist"];
    NSData *fileData = [NSData dataWithContentsOfFile:userInfoFile];
    
    XCTAssertNotNil(fileData, @"should not be nil");
    [self measureBlock:^{
        DemoUser *me = [[DemoUser alloc] initWithUserInfoData:fileData];
    }];
}

@end
