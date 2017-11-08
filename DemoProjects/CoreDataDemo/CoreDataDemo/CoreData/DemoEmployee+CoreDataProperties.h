//
//  DemoEmployee+CoreDataProperties.h
//  CoreDataDemo
//
//  Created by JiangWang on 10/07/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "DemoEmployee+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface DemoEmployee (CoreDataProperties)

+ (NSFetchRequest<DemoEmployee *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *birthDate;
@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) int16_t height;
@property (nullable, nonatomic, copy) NSString *sectionName;
@property (nullable, nonatomic, retain) DemoDepartment *department;

@end

NS_ASSUME_NONNULL_END
