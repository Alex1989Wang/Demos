//
//  XCTestDemoSynchronousTests.m
//  XCTestDemo
//
//  Created by JiangWang on 29/05/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DemoSearchViewController.h"

@interface XCTestDemoSynchronousTests : XCTestCase
@property (nonatomic, strong) DemoSearchViewController *searchController;
@end

@implementation XCTestDemoSynchronousTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.searchController = [[DemoSearchViewController alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testViewHierachyLazilyLoaded {
    XCTAssertNotNil(self.searchController.searchBar,
                    @"should not be nil");
    XCTAssertNotNil(self.searchController.resultsTable,
                    @"should not be nil");
}

@end
