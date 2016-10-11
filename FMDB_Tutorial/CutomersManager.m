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

+ (BOOL)openCustomersTable {
    NSString *customersTableSchema = @"CREATE TABLE IF NOT EXISTS 'CustomersTable'  (       \
                    ID INTEGER PRIMARY KEY NOT NULL,                                        \
                    firstName  TEXT NOT NULL,                                               \
                    lastName TEXT NOT NULL                                                  \
                    );";
    return [[TutorialDataBaseManager sharedManager].globalDataBase executeUpdate:customersTableSchema];
}

+ (NSArray<Customer *> *)getCutomers {
    NSString *getCutomersSQL = @"SELECT * FROM 'CustomersTable'";
    FMResultSet *customersSet = [[TutorialDataBaseManager sharedManager].globalDataBase executeQuery:getCutomersSQL];
    
    NSMutableArray *tempCustomers = [NSMutableArray array];
    while ([customersSet next]) {
        Customer *tempCus = [[Customer alloc] init];
        tempCus.firstName = [customersSet stringForColumn:@"firstName"];
        tempCus.lastName = [customersSet stringForColumn:@"lastName"];
        [tempCustomers addObject:tempCus];
    }
    return [tempCustomers copy];
}

+ (BOOL)insertACustomer:(Customer *)customer {
    NSString *insertSQL = @"INSERT INTO 'CustomersTable' (ID, firstName, lastName) VALUES (NULL, ?, ?);";
    BOOL insertRes = [[TutorialDataBaseManager sharedManager].globalDataBase executeUpdate:insertSQL, customer.firstName, customer.lastName];
    return insertRes;
}


+ (BOOL)insertCustomers:(NSArray<Customer *> *)customers {
    __block BOOL insertRes = YES;
    [customers enumerateObjectsUsingBlock:^(Customer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BOOL singleInsertionRes = [self insertACustomer:obj];
        if (!singleInsertionRes) {
            insertRes = NO;
        }
    }];
    return insertRes;
}


@end
