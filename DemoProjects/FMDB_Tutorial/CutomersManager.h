//
//  CutomersManager.h
//  FMDB_Tutorial
//
//  Created by JiangWang on 05/10/2016.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Customer;

@interface CutomersManager : NSObject

/**
 Open table to store customers data;

 @return A boolean value to indicate 
         whether the table is successfully opened
         or created;
 */
+ (BOOL)openCustomersTable;

/**
 *  Get customers from the data base table;
 *
 */
+ (NSArray <Customer *> *)getCutomers;

/**
 *  Insert a customer;
 *
 */
+ (BOOL)insertACustomer:(Customer *)customer;


/**
 *  Insert an array of customers;
 *
 */
+ (BOOL)insertCustomers:(NSArray <Customer *> *)customers;

@end
