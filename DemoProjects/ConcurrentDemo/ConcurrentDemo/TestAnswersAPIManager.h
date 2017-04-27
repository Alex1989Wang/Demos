//
//  TestAnswersAPIManager.h
//  ConcurrentDemo
//
//  Created by JiangWang on 26/04/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "TestOperation.h"
#import "TypeDefineConstants.h"

@interface TestAnswersAPIManager : TestOperation

+ (void)retrieveAnswersWithCompletion:(TestAnswersOperationCompletion)completion;
@end
