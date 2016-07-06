//
//  XDThumbnailMessage.h
//  ChatDemo
//
//  Created by JiangWang on 7/5/16.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import <Foundation/Foundation.h>

/* cell's customized content view's position */
typedef NS_ENUM(NSUInteger, XDThumbnailCellPosition) {
    XDThumbnailMessageCellOriginal = 0,                 // the original position - (0, 0);
    XDThumbnailMessageCellLeft,                         // has already moved to the left-side because of the left swipe;
    XDThumbnailMessageCellRight,                        // has already moved to the right-side because of the right swipe;
};

@interface XDThumbnailMessage : NSObject

/* the sender's name */
@property (nonatomic, copy) NSString *name;

/* the sender's distance */
@property (nonatomic, copy) NSString *distance;

/* the thumbnail message */
@property (nonatomic, copy) NSString *messageContent;

/* message count */
@property (nonatomic, copy) NSString *messageCount;

/* the time last message was received */
@property (nonatomic, copy) NSString *latestMessageRecivedTime;

/* the cell's position - original origin (0,0); */
@property (nonatomic, assign) XDThumbnailCellPosition position;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)thumbnailMessageWithDict:(NSDictionary *)dict;


@end
