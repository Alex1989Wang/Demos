//
//  TestAnswersOperation.m
//  ConcurrentDemo
//
//  Created by JiangWang on 26/04/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "TestAnswersOperation.h"

@interface TestAnswersOperation()
@property (nonatomic, copy) TestAnswersOperationCompletion completion;
@end

@implementation TestAnswersOperation
- (instancetype)initWithCompletion:(TestAnswersOperationCompletion)completion {
    self = [super init];
    if (self) {
        self.name = NSStringFromClass([TestAnswersOperation class]);
        self.completion = completion;
    }
    return self;
}

#pragma mark - Private
- (void)start {
    [super start];
    
    //Start Getting Answers;
    NSURLSession *sharedSession = [NSURLSession sharedSession];
    NSURL *testURL = [NSURL URLWithString:@"https://api.stackexchange.com/2.2/answers?site=stackoverflow"];
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *dataTask =
    [sharedSession dataTaskWithURL:testURL
                 completionHandler:
     ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
         NSDictionary *answersDict = [NSJSONSerialization JSONObjectWithData:data
                                                                     options:NSJSONReadingMutableContainers
                                                                       error:NULL];
         __strong typeof(weakSelf) strSelf = weakSelf;
         if ([answersDict[@"items"] isKindOfClass:[NSArray class]]) {
             if (strSelf.completion) {
                 strSelf.completion(answersDict[@"items"]);
             }
         }
         [strSelf finish];
     }];
    [dataTask resume];
}

#pragma mark - Override 
- (void)cancel {
    [super cancel];
    [self finish];
}
@end
