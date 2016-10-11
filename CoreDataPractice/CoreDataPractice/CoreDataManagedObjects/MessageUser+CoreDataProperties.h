//
//  MessageUser+CoreDataProperties.h
//  CoreDataPractice
//
//  Created by JiangWang on 02/10/2016.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "MessageUser+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface MessageUser (CoreDataProperties)

+ (NSFetchRequest<MessageUser *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) int64_t uid;
@property (nullable, nonatomic, retain) NSSet<MessageModel *> *sentMessage;

@end

@interface MessageUser (CoreDataGeneratedAccessors)

- (void)addSentMessageObject:(MessageModel *)value;
- (void)removeSentMessageObject:(MessageModel *)value;
- (void)addSentMessage:(NSSet<MessageModel *> *)values;
- (void)removeSentMessage:(NSSet<MessageModel *> *)values;

@end

NS_ASSUME_NONNULL_END
