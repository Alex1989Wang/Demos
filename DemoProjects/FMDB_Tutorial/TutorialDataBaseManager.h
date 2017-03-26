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

@property (nonatomic, strong, readonly) FMDatabase *globalDataBase;

#pragma mark - 
#pragma mark - Methods
/**
 *  The singleton manager 
 *
 */
+ (TutorialDataBaseManager *)sharedManager;


/**
 *  Check whether the data base file exists or not?
 *  If not, create the data base file;
 *  Otherwise, connnect to the existing data base file;
 *  
 */
- (BOOL)checkAndConnectSharedDataBase;


/**
 *  Close data base;
 *
 */
- (BOOL)closeSharedDataBase;

@end
