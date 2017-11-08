//
//  DemoEmployee+CoreDataProperties.m
//  CoreDataDemo
//
//  Created by JiangWang on 10/07/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "DemoEmployee+CoreDataProperties.h"

@implementation DemoEmployee (CoreDataProperties)

+ (NSFetchRequest<DemoEmployee *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"DemoEmployee"];
}

@dynamic birthDate;
@dynamic name;
@dynamic height;
@dynamic sectionName;
@dynamic department;

@end
