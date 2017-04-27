//
//  TestAnswersAPIManager.m
//  ConcurrentDemo
//
//  Created by JiangWang on 26/04/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "TestAnswersAPIManager.h"
#import "TestAnswersOperation.h"
#import "TestOperationQueueManager.h"

@implementation TestAnswersAPIManager

+ (void)retrieveAnswersWithCompletion:(TestAnswersOperationCompletion)completion {
    TestAnswersOperation *retrieveAnswersOperation =
    [[TestAnswersOperation alloc] initWithCompletion:completion];
    [[TestOperationQueueManager sharedManager] addOperation:retrieveAnswersOperation];
}
@end
