//
//  CutomersManager.m
//  FMDB_Tutorial
//
//  Created by JiangWang on 05/10/2016.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "CutomersManager.h"
#import "TutorialDataBaseManager.h"
#import "Customer.h"

@implementation CutomersManager

+ (void)openCustomersTableCompleted:(DataBaseExecuteStatementCompletionBlock)completion {
    NSString *customersTableSchema =
    @"CREATE TABLE IF NOT EXISTS 'CustomersTable'  ( "
    "ID INTEGER PRIMARY KEY NOT NULL, "
    "firstName  TEXT NOT NULL, "
    "lastName TEXT NOT NULL);";
    [[TutorialDataBaseManager sharedManager].sharedOperationQueue
     inDatabase:^(FMDatabase *db) {
         BOOL updateRes = [db executeUpdate:customersTableSchema];
         if (!updateRes) {
             NSLog(@"Error: %@", [db.lastError localizedDescription]);
         }
         if (completion) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 completion(updateRes);
             });
         }
    }];
}

+ (void)getCutomers:(void (^)(NSArray<Customer *> *))completion {
    NSString *getCutomersSQL = @"SELECT * FROM 'CustomersTable'";
    [[TutorialDataBaseManager sharedManager].sharedOperationQueue
     inDatabase:^(FMDatabase *db) {
         FMResultSet *customersSet = [db executeQuery:getCutomersSQL];
         if (customersSet == nil) {
             NSLog(@"Error: %@", [db.lastError localizedDescription]);
         }
         else {
             NSMutableArray *tempCustomers = [NSMutableArray array];
             while ([customersSet next]) {
                 Customer *tempCus = [[Customer alloc] init];
                 tempCus.firstName = [customersSet stringForColumn:@"firstName"];
                 tempCus.lastName = [customersSet stringForColumn:@"lastName"];
                 [tempCustomers addObject:tempCus];
             }
             
             if (completion) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     completion([tempCustomers copy]);
                 });
             }
         }
     }];
}

+ (void)insertACustomer:(Customer *)customer
              completed:(DataBaseExecuteStatementCompletionBlock)completion {
    if (!customer &&
        [customer isKindOfClass:[Customer class]]) {
        if (completion) {
            completion(NO);
        }
        return;
    }
    
    [self insertCustomers:@[customer]
                completed:completion];
}

+ (void)insertCustomers:(NSArray<Customer *> *)customers
              completed:(DataBaseExecuteStatementCompletionBlock)completion {
    NSString *insertSQL = @"INSERT INTO 'CustomersTable' (ID, firstName, lastName) VALUES (NULL, ?, ?);";
    __block BOOL insertRes = YES;
    [[TutorialDataBaseManager sharedManager].sharedOperationQueue
     inTransaction:^(FMDatabase *db, BOOL *rollback) {
         [customers enumerateObjectsUsingBlock:
          ^(Customer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
              BOOL singleInsertionRes = [db executeUpdate:insertSQL, obj.firstName, obj.lastName];
              if (!singleInsertionRes) {
                  insertRes = NO;
              }
          }];
         
         if (completion) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 completion(insertRes);
             });
         }
     }];
}

+ (void)deleteCustomersByFirstName:(NSString *)firstName
                         completed:(DataBaseExecuteStatementCompletionBlock)completion {
    NSString *deleteSQL = @"DELETE FROM 'CustomersTable' WHERE firstName = ?;";
    [[TutorialDataBaseManager sharedManager].sharedOperationQueue
    inDatabase:^(FMDatabase *db) {
        BOOL deleteRes = [db executeUpdate:deleteSQL, firstName];
         if (completion) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 completion(deleteRes);
             });
         }
    }];
}

@end
