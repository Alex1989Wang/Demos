//
//  MessageModel+CoreDataProperties.m
//  CoreDataPractice
//
//  Created by JiangWang on 02/10/2016.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "MessageModel+CoreDataProperties.h"

@implementation MessageModel (CoreDataProperties)

+ (NSFetchRequest<MessageModel *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"MessageModel"];
}

@dynamic content;
@dynamic myUID;
@dynamic sentDate;
@dynamic sender;

@end
