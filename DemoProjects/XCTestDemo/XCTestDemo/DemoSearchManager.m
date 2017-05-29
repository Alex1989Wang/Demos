//
//  DemoSearchManager.m
//  XCTestDemo
//
//  Created by JiangWang on 29/05/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "DemoSearchManager.h"
#define kGithubUserAPI @"https://api.github.com/users"

@interface DemoSearchManager()
<NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSessionDataTask *onGoingTask;
@property (nonatomic, copy) SearchResultBlock resultBlock;
@property (nonatomic, strong) NSMutableData *resultData;
@property (nonatomic, strong) dispatch_queue_t dataOperationQueue;
@end

@implementation DemoSearchManager

#pragma mark - Public Methods
+ (DemoSearchManager *)sharedManager {
    static DemoSearchManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[DemoSearchManager alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *queueID = @"XCtestDemo.NetworkingDataQueue";
        const char *constQueueID = [queueID UTF8String];
        _dataOperationQueue = dispatch_queue_create(constQueueID, DISPATCH_QUEUE_SERIAL);
        [self resultData];
    }
    return self;
}

- (void)getUserInfoWithUserName:(NSString *)userName
                      completed:(SearchResultBlock)completion {
    if (self.onGoingTask) {
        [self resetTask];
    }
   
    self.resultBlock = completion;
    NSString *encodedName = [userName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *requestURLStr = [kGithubUserAPI stringByAppendingPathComponent:encodedName];
    NSURL *requestURL = [NSURL URLWithString:requestURLStr];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:requestURL];
    NSURLSessionConfiguration *defaultCon =
    [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:defaultCon
                                                          delegate:self
                                                     delegateQueue:nil];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request];
    self.onGoingTask = dataTask;
    [dataTask resume];
}

- (void)resetTask {
    [self.onGoingTask cancel];
    self.onGoingTask = nil;
    
    dispatch_async(self.dataOperationQueue, ^{
        self.resultData = nil;
    });
    [self resultData];
}
     
#pragma mark - Delegate
- (void)URLSession:(NSURLSession *)session
              task:(nonnull NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error {
    if (error) {
        NSLog(@"data task can't be finished.");
        if (self.resultBlock) {
            self.resultBlock(nil);
        }
    }
    else {
        dispatch_async(self.dataOperationQueue, ^{
            NSData *finisedData = [self.resultData copy];
            if (finisedData.length) {
                if (self.resultBlock) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.resultBlock(finisedData);
                    });
                }
            }
            else if (self.resultBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.resultBlock(nil);
                });
            }
        });
    }
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
    NSLog(@"data: %@", data);
    __weak typeof(self) weakSelf = self;
    dispatch_async(self.dataOperationQueue, ^{
        __strong typeof(weakSelf) strSelf = weakSelf;
        [strSelf.resultData appendData:data];
    });
}

#pragma mark - Lazy Loading
- (NSMutableData *)resultData {
    if (_resultData == nil) {
        dispatch_sync(self.dataOperationQueue, ^{
            _resultData = [NSMutableData data];
        });
    }
    return _resultData;
}

@end
