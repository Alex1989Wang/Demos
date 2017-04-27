//
//  TestAnswersOperation.h
//  ConcurrentDemo
//
//  Created by JiangWang on 26/04/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "TestOperation.h"
#import "TypeDefineConstants.h"

@interface TestAnswersOperation : TestOperation

/**
 Init method.

 @param completion completion block
 @return Newly created instance.
 */
- (instancetype)initWithCompletion:(TestAnswersOperationCompletion)completion;
@end
