//
//  XDThumbnailMessageCell.h
//  ChatDemo
//
//  Created by JiangWang on 7/5/16.
//  Copyright © 2016 JiangWang. All rights reserved.
//



/* @class */
@class XDThumbnailMessage;
@class XDThumbnailMessageCell;

/* imported header files */
#import <UIKit/UIKit.h>

/* cell's customized content view's position */
typedef NS_ENUM(NSUInteger, XDThumbnailCellPosition) {
    XDThumbnailMessageCellOriginal = 0,                 // the original position - (0, 0);
    XDThumbnailMessageCellLeft,                         // has already moved to the left-side because of the left swipe;
    XDThumbnailMessageCellRight,                        // has already moved to the right-side because of the right swipe;
};

/* protocals - XDThumbnailMessageCellDelegate */
@protocol XDThumbnailMessageCellDelegate <NSObject>

/**
 *  when the swipe gesture has moved the cell content view off the original (0,0) posistion - call this method;
 *  don't use this method if the gesture moves the cell content view to its original position;
 *  @param cell  the cell that has moved elsewhere
 *  @param swipe the swipe gesture which causes this
 */
- (void)thumbnailMessageCell:(XDThumbnailMessageCell *)cell hasMovedElsewhereByGesture:(UISwipeGestureRecognizer *)swipe;
- (void)thumbnailMessageCell:(XDThumbnailMessageCell *)cell hasMovedBackByGesture:(UISwipeGestureRecognizer *)swipe;
@end

@interface XDThumbnailMessageCell : UITableViewCell

/*
 Properties
 */
@property (nonatomic, strong) XDThumbnailMessage *thumbnailMessage;
@property (nonatomic, weak) id<XDThumbnailMessageCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *unreadOrReadButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteMessageButton;
@property (weak, nonatomic) IBOutlet UIButton *personalPageButton;

@property (weak, nonatomic) UIPanGestureRecognizer *pan;

/*
 Methods
 */
- (void)thumbnailMessageCellBackToNormalPosition;


@end
