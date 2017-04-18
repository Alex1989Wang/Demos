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

- (void)logCurrentVersion {
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dataBaseFullPath = [documentsPath stringByAppendingPathComponent:@"tutorial.db"];
    FMDatabase *databaseInUse = [[FMDatabase alloc] initWithPath:dataBaseFullPath];
    [databaseInUse open];
    NSLog(@"current version: %d", [databaseInUse userVersion]);
    [databaseInUse close];
}

- (void)setCurrentVersion:(uint32_t)newVersion {
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dataBaseFullPath = [documentsPath stringByAppendingPathComponent:@"tutorial.db"];
    FMDatabase *databaseInUse = [[FMDatabase alloc] initWithPath:dataBaseFullPath];
    [databaseInUse open];
    [databaseInUse setUserVersion:newVersion];
    NSLog(@"set current version: %d", [databaseInUse userVersion]);
    [databaseInUse close];
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
