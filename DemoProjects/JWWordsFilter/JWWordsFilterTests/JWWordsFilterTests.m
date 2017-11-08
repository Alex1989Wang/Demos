//
//  JWWordsFilterTests.m
//  JWWordsFilterTests
//
//  Created by JiangWang on 28/08/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GLSensitiveWordsFilter.h"

@interface JWWordsFilterTests : XCTestCase

@end

@implementation JWWordsFilterTests

- (void)setUp {
    [super setUp];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"SensitiveWords" ofType:@"txt"];
    [[GLSensitiveWordsFilter sharedFilter] setFilterVocabularyPath:path];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSampleOne {
    NSString *sampleOne = @"chinesenewsnet";
    NSString *filteredSample = [[GLSensitiveWordsFilter sharedFilter] filterWords:sampleOne];
    NSString *expect = [@"" stringByPaddingToLength:sampleOne.length
                                         withString:@"*"
                                    startingAtIndex:0];
    XCTAssertTrue([expect isEqualToString:filteredSample]);
}


- (void)testSampleTwo {
    NSString *sampleTwo = @"Jend. TNI (Purn.) Ryamizard Ryacudu";
    NSString *filteredSample = [[GLSensitiveWordsFilter sharedFilter] filterWords:sampleTwo];
    NSString *expect = [@"" stringByPaddingToLength:sampleTwo.length
                                         withString:@"*"
                                    startingAtIndex:0];
    XCTAssertTrue([expect isEqualToString:filteredSample]);
}

- (void)testSampleThree {
    NSString *sampleThree = @"Fuck YOUR MOTHER"; //case
    NSString *filteredSample = [[GLSensitiveWordsFilter sharedFilter] filterWords:sampleThree];
    NSString *expect = [@"" stringByPaddingToLength:sampleThree.length
                                         withString:@"*"
                                    startingAtIndex:0];
    XCTAssertTrue([expect isEqualToString:filteredSample]);
}

- (void)testMixedSample {
    NSString *sampleThree = @"mixed prefix Fuck YOUR MOTHER suffix"; //case
    NSString *filteredSample = [[GLSensitiveWordsFilter sharedFilter] filterWords:sampleThree];
    NSString *expect = [@"mixed prefix " stringByPaddingToLength:@"mixed prefix Fuck YOUR MOTHER".length
                                                      withString:@"*"
                                                 startingAtIndex:0];
    expect = [expect stringByAppendingString:@" suffix"];
    XCTAssertTrue([expect isEqualToString:filteredSample]);
}

- (void)testMixedSampleTwo {
    NSString *sampleThree = @"prefix (Fuck YOUR MOTHER"; //case
    NSString *filteredSample = [[GLSensitiveWordsFilter sharedFilter] filterWords:sampleThree];
    NSString *expect = [@"prefix (" stringByPaddingToLength:@"prefix (Fuck YOUR MOTHER".length
                                                      withString:@"*"
                                                 startingAtIndex:0];
    XCTAssertTrue([expect isEqualToString:filteredSample]);
}

- (void)testMixedSampleThree {
    NSString *sampleThree = @"prefix (Fuck YOUR MOTHER"; //case
    NSString *filteredSample = [[GLSensitiveWordsFilter sharedFilter] filterWords:sampleThree];
    NSString *expect = [@"prefix (" stringByPaddingToLength:@"prefix (Fuck YOUR MOTHER".length
                                                      withString:@"*"
                                                 startingAtIndex:0];
    XCTAssertTrue([expect isEqualToString:filteredSample]);
}

- (void)testMixedSampleFour {
    NSString *sampleThree = @"#Fuck YOUR MOTHER"; //case
    NSString *filteredSample = [[GLSensitiveWordsFilter sharedFilter] filterWords:sampleThree];
    NSString *expect = [@"#" stringByPaddingToLength:@"#Fuck YOUR MOTHER".length
                                          withString:@"*"
                                     startingAtIndex:0];
    XCTAssertTrue([expect isEqualToString:filteredSample]);
}

- (void)testMixedSampleFive {
    NSString *sampleThree = @"aFuck YOUR MOTHER"; //case
    NSString *filteredSample = [[GLSensitiveWordsFilter sharedFilter] filterWords:sampleThree];
    NSString *expect = [@"a" stringByPaddingToLength:@"aFuck YOUR MOTHER".length
                                          withString:@"*"
                                     startingAtIndex:0];
    XCTAssertTrue([expect isEqualToString:filteredSample]);
}

- (void)testLongSentencePerformance {
    [self measureBlock:^{
        NSString *sampleThree = @"mixed p dfjaoifjoaf dfj idof aiof difj aodif arefix Fuck YOUR MOTHER suffix"; //case
        NSString *filteredSample = [[GLSensitiveWordsFilter sharedFilter] filterWords:sampleThree];
    }];
}

@end
