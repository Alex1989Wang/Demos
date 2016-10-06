//
//  MessageModel+CoreDataProperties.h
//  CoreDataPractice
//
//  Created by JiangWang on 02/10/2016.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "MessageModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface MessageModel (CoreDataProperties)

+ (NSFetchRequest<MessageModel *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *content;
@property (nonatomic) int64_t myUID;
@property (nullable, nonatomic, copy) NSDate *sentDate;
@property (nullable, nonatomic, retain) MessageUser *sender;

@end

NS_ASSUME_NONNULL_END
