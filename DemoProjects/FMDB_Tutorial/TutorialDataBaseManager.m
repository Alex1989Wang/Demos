//
//  TutorialDataBase.m
//  FMDB_Tutorial
//
//  Created by JiangWang on 05/10/2016.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "TutorialDataBaseManager.h"

@interface TutorialDataBaseManager()
@property (nonatomic, strong) FMDatabaseQueue *sharedOperationQueue;
@end

@implementation TutorialDataBaseManager

+ (TutorialDataBaseManager *)sharedManager {
    static TutorialDataBaseManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
        [sharedManager sharedOperationQueue];
    });
    return sharedManager;
}

#pragma mark - Lazy Loading 
- (FMDatabaseQueue *)sharedOperationQueue {
    if (nil == _sharedOperationQueue) {
        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *dataBaseFullPath = [documentsPath stringByAppendingPathComponent:@"tutorial.db"];
        _sharedOperationQueue = [[FMDatabaseQueue alloc] initWithPath:dataBaseFullPath];
    }
    return _sharedOperationQueue;
}

@end
