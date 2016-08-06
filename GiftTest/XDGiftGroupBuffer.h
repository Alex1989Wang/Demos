//
//  XDGiftGroupBuffer.h
//  seeYouTime
//
//  Created by JiangWang on 8/2/16.
//  Copyright © 2016 形点网络. All rights reserved.
//

#import <Foundation/Foundation.h>

/* the buffer notification */
UIKIT_EXTERN NSString *const BufferAddedNewGiftGroup;

@class XDGiftGroup;

@interface XDGiftGroupBuffer : NSObject

/**
 *  Instantiate the singleton to use.
 *
 *  @return The singleton;
 */
+ (instancetype)sharedBuffer;

/**
 *  Add a gift group to the sharedBuffer.
 *
 *  @param giftGroup The gift group to add.
 */
- (void)bufferAddGiftGroup:(XDGiftGroup *)giftGroup;

/**
 *  Fetch a specified gift group with the passed-in groupID.
 *
 *  @param groupID The groupID to indicate which gift group to fetch.
 *
 *  @return The desired gift group.
 */
- (XDGiftGroup *)fetchGiftGroupWithID:(NSString *)groupID;

/**
 *
 *  @return The first gift group;
 */
- (XDGiftGroup *)fetchFirstGiftGroup;

/**
 *  Delete the passed-in group;
 *
 */
- (void)deleteGiftGroup:(XDGiftGroup *)group;

@end
