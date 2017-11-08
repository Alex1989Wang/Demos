//
//  DemoDepartment+CoreDataProperties.m
//  CoreDataDemo
//
//  Created by JiangWang on 10/07/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "DemoDepartment+CoreDataProperties.h"

@implementation DemoDepartment (CoreDataProperties)

+ (NSFetchRequest<DemoDepartment *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"DemoDepartment"];
}

@dynamic createDate;
@dynamic departName;
@dynamic employee;

@end
