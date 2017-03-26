//
//  TutorialDataBase.m
//  FMDB_Tutorial
//
//  Created by JiangWang on 05/10/2016.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "TutorialDataBaseManager.h"

@implementation TutorialDataBaseManager

+ (TutorialDataBaseManager *)sharedManager {
    static TutorialDataBaseManager *sharedManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    
    return sharedManager;
}

- (BOOL)checkAndConnectSharedDataBase {
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dataBaseFullPath = [documentsPath stringByAppendingPathComponent:@"tutorial.db"];
    
    FMDatabase *dataBase = [FMDatabase databaseWithPath:dataBaseFullPath];
    _globalDataBase = dataBase;
    
    return (dataBase == nil) ? NO : [dataBase open];
}

- (BOOL)closeSharedDataBase {
    return [self.globalDataBase close];
}

@end
