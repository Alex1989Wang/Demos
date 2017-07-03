//
//  EncodeTestExamples.m
//  EncodeTestExamples
//
//  Created by JiangWang on 28/06/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GLDecodeUtility.h"

@interface EncodeTestExamples : XCTestCase
@property (nonatomic, copy) NSString *encodeKey;
@property (nonatomic, copy) NSString *encodedInfo;
@end

@implementation EncodeTestExamples

- (void)setUp {
    [super setUp];
    self.encodeKey = @"100001_1498607394893";
    self.encodedInfo = @"pwbdDxheVfq5yOTf4x0zvNYBe69AIx3d0gZOoDBZviICvzn0hl2beCdpThdMG0Em5l7rCBwl6DwtU0Dx+OwR/H7WfVtjD6FmKrnW0VvMFyk=";
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDecodeAlgorithm {
    NSString *decodedInfo = [GLDecodeUtility decodeSecretInfo:self.encodedInfo withKey:self.encodedInfo];
    XCTAssertTrue(decodedInfo.length);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
