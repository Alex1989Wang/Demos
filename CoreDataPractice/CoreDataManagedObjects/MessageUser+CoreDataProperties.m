//
//  MessageUser+CoreDataProperties.m
//  CoreDataPractice
//
//  Created by JiangWang on 02/10/2016.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "MessageUser+CoreDataProperties.h"

@implementation MessageUser (CoreDataProperties)

+ (NSFetchRequest<MessageUser *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"MessageUser"];
}

@dynamic name;
@dynamic uid;
@dynamic sentMessage;

@end
