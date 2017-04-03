//
//  TutorialDataBase.h
//  FMDB_Tutorial
//
//  Created by JiangWang on 05/10/2016.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>

@interface TutorialDataBaseManager : NSObject

@property (nonatomic, strong, readonly) FMDatabaseQueue *sharedOperationQueue;

#pragma mark - 
#pragma mark - Methods
/**
 *  The singleton manager 
 *
 */
+ (TutorialDataBaseManager *)sharedManager;

@end
