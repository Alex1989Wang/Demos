//
//  DemoDepartment+CoreDataProperties.h
//  CoreDataDemo
//
//  Created by JiangWang on 10/07/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "DemoDepartment+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface DemoDepartment (CoreDataProperties)

+ (NSFetchRequest<DemoDepartment *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *createDate;
@property (nullable, nonatomic, copy) NSString *departName;
@property (nullable, nonatomic, retain) NSSet<DemoEmployee *> *employee;

@end

@interface DemoDepartment (CoreDataGeneratedAccessors)

- (void)addEmployeeObject:(DemoEmployee *)value;
- (void)removeEmployeeObject:(DemoEmployee *)value;
- (void)addEmployee:(NSSet<DemoEmployee *> *)values;
- (void)removeEmployee:(NSSet<DemoEmployee *> *)values;

@end

NS_ASSUME_NONNULL_END
