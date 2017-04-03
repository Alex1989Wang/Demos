//
//  CutomersManager.h
//  FMDB_Tutorial
//
//  Created by JiangWang on 05/10/2016.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Customer;

typedef void(^DataBaseExecuteStatementCompletionBlock)(BOOL result);

@interface CutomersManager : NSObject

/**
 Open table to store customers data;

 */
+ (void)openCustomersTableCompleted:(DataBaseExecuteStatementCompletionBlock)completion;

/**
 *  Get customers from the data base table;
 *
 */
+ (void)getCutomers:(void(^)(NSArray <Customer *> *customers))completion;

/**
 *  Insert a customer;
 *
 */
+ (void)insertACustomer:(Customer *)customer
              completed:(DataBaseExecuteStatementCompletionBlock)completion;


/**
 *  Insert an array of customers;
 *
 */
+ (void)insertCustomers:(NSArray <Customer *> *)customers
              completed:(DataBaseExecuteStatementCompletionBlock)completion;

+ (void)deleteCustomersByFirstName:(NSString *)firstName
                         completed:(DataBaseExecuteStatementCompletionBlock)completion;

@end
