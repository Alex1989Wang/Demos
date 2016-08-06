//
//  XDGiftGroupBuffer.m
//  seeYouTime
//
//  Created by JiangWang on 8/2/16.
//  Copyright © 2016 形点网络. All rights reserved.
//

#import "XDGiftGroupBuffer.h"
#import "XDAniGiftView.h"
#import "XDGiftGroup.h"

NSString *const BufferAddedNewGiftGroup = @"BufferAddedNewGiftGroup";

@interface XDGiftGroupBuffer()

/* using weak should be enough */
/* these three views have been add to the screen */
@property (nonatomic, weak) XDAniGiftView *topView;
@property (nonatomic, weak) XDAniGiftView *middleView;
@property (nonatomic, weak) XDAniGiftView *bottomView;

/* gift array corresponding to topView, middleView, and bottomView */
@property (nonatomic, strong) NSMutableArray<XDGiftGroup *> *giftGroupsArray;

@end

@implementation XDGiftGroupBuffer

#pragma mark - initilization
+ (instancetype)sharedBuffer {
    static XDGiftGroupBuffer *sharedBuffer;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedBuffer = [[XDGiftGroupBuffer alloc] init];
        sharedBuffer.giftGroupsArray = [NSMutableArray array];
    });
    
    return sharedBuffer;
}

- (void)initializeSharedBufferWithBannerViews:(NSArray *)giftBanners {
    self.topView = giftBanners[0];
    self.middleView = giftBanners[1];
    self.bottomView = giftBanners[2];
}

#pragma mark - buffers the gift group
- (void)bufferAddGiftGroup:(XDGiftGroup *)giftGroup {
    // add the object
    [self.giftGroupsArray addObject:giftGroup];
    
    //post notification
    [[NSNotificationCenter defaultCenter] postNotificationName:BufferAddedNewGiftGroup object:nil];
}

#pragma mark - accesssing gift groups
- (XDGiftGroup *)fetchGiftGroupWithID:(NSString *)groupID {
    //if there is no gift group to fetch
    if (self.giftGroupsArray.count == 0) {
        return nil;
    }
    
    //if there are gift groups in the array;
    //find the gift group with the same group_id which appears first in the giftGroupsArray;
    __block XDGiftGroup *groupToReturn = nil;
    [self.giftGroupsArray enumerateObjectsUsingBlock:^(XDGiftGroup * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([groupID isEqualToString:obj.group_id]) {
            groupToReturn = obj;
            *stop = YES;
        }
    }];
    
    //delete this founded group
    if (!groupToReturn) {       //have found a gift group
        [self.giftGroupsArray removeObject:groupToReturn];        
    }
    return groupToReturn;
}

- (XDGiftGroup *)fetchFirstGiftGroup {
    return (self.giftGroupsArray.count == 0) ? nil : [self.giftGroupsArray firstObject];
}

- (void)deleteGiftGroup:(XDGiftGroup *)group {
    [self.giftGroupsArray removeObject:group];
}

@end
