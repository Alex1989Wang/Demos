//
//  XDThumbnailMessageCell.m
//  ChatDemo
//
//  Created by JiangWang on 7/5/16.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "XDThumbnailMessageCell.h"

/* frame related */
#define kDeleteButtomWidth self.deleteMessageButton.frame.size.width
#define kUnreadOrReadButtonWidth self.unreadOrReadButton.frame.size.width
#define kPersonalPageButtonWidth self.personalPageButton.frame.size.width

/* animation time */
#define kAnimationTime 0.5f

@interface XDThumbnailMessageCell()<UIGestureRecognizerDelegate>

/* properties need to be assigned values to */
@property (weak, nonatomic) IBOutlet UIImageView *userIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
#warning use label first - might change this later;
@property (weak, nonatomic) IBOutlet UILabel *messageCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *latestMessageReceivedTimeLabel;

/* UI manipulation */
@property (weak, nonatomic) IBOutlet UIView *customizedCellContentView;
/* the position of the cell's customizedCellContentView */
@property (nonatomic, assign) XDThumbnailCellPosition position;

@property (nonatomic, assign) CGPoint previousTranslation;

@end

@implementation XDThumbnailMessageCell
- (IBAction)readOrUnread:(id)sender {
    NSLog(@"%s", __func__);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //gesture recognizer left and right;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self.customizedCellContentView addGestureRecognizer:pan];
    pan.delegate = self;
    pan.delaysTouchesBegan = YES;
    self.pan = pan;
    
    
    //round the message count label
     self.messageCountLabel.layer.cornerRadius = 0.5 * self.messageCountLabel.frame.size.height;
    self.messageCountLabel.layer.masksToBounds = YES;
    
#warning text font - using "PingFang-SC-Light" at present - might change this later;
    [self.userNameLabel setFont:[UIFont boldSystemFontOfSize:14.f]];
    [self.userDistanceLabel setFont:[UIFont systemFontOfSize:10.f]];
    [self.messageLabel setFont:[UIFont systemFontOfSize:12.f]];
    [self.messageCountLabel setFont:[UIFont systemFontOfSize:10.f]];
    [self.latestMessageReceivedTimeLabel setFont:[UIFont systemFontOfSize:10.f]];
}

#pragma mark - assign values;


#pragma mark - taget actions
- (void)handleCellSwipe:(UISwipeGestureRecognizer *)swipe {
    //the original frame - (0, 0, customizedCellContentView.frame.size.width, customizedCellContentView.frame.size.height)
    CGRect customizedViewFrame = self.customizedCellContentView.frame;
    
    if (self.position == XDThumbnailMessageCellLeft || self.position == XDThumbnailMessageCellRight) {
        //reset the position if the customized view has been moved;
        customizedViewFrame.origin = CGPointZero;
        [UIView animateWithDuration:kAnimationTime animations:^{
            self.customizedCellContentView.frame = customizedViewFrame;
        }];
        
        if ([self.delegate respondsToSelector:@selector(thumbnailMessageCell:hasMovedBackByGesture:)]) {
            [self.delegate thumbnailMessageCell:self hasMovedBackByGesture:swipe];
        }
        
        self.position = XDThumbnailMessageCellOriginal;
        
    }else {
        //personal page
        if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
            customizedViewFrame.origin.x += kPersonalPageButtonWidth;
            [UIView animateWithDuration:kAnimationTime animations:^{
                self.customizedCellContentView.frame = customizedViewFrame;
            }];
   
            if ([self.delegate respondsToSelector:@selector(thumbnailMessageCell:hasMovedElsewhereByGesture:)]) {
                [self.delegate thumbnailMessageCell:self hasMovedElsewhereByGesture:swipe];
            }
            self.position = XDThumbnailMessageCellRight;
        }
        
        //delete the all messages or set all messages to the state of already-read;
        if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
            customizedViewFrame.origin.x -= (kUnreadOrReadButtonWidth + kDeleteButtomWidth);
            [UIView animateWithDuration:kAnimationTime animations:^{
                self.customizedCellContentView.frame = customizedViewFrame;
            }];
 
            if ([self.delegate respondsToSelector:@selector(thumbnailMessageCell:hasMovedElsewhereByGesture:)]) {
                [self.delegate thumbnailMessageCell:self hasMovedElsewhereByGesture:swipe];
            }
            self.position = XDThumbnailMessageCellLeft;
        }
    }
    
}

#pragma mark - other added cell methods
- (void)thumbnailMessageCellBackToNormalPosition {
    [self handleCellSwipe:[[UISwipeGestureRecognizer alloc] init]];
    
}

#pragma mark - handle pan gesture
- (void)handlePanGesture: (UIPanGestureRecognizer *)pan {
    //use x direction
    CGPoint thisTranslation = [pan translationInView:self.contentView];
    CGFloat xDiff = thisTranslation.x - self.previousTranslation.x;
    
    CGFloat animationDuration = xDiff / [pan velocityInView:self.contentView].x;
    
    //    [UIView animateWithDuration:animationDuration animations:^{
    //
    //    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.customizedCellContentView.frame = CGRectMake(self.customizedCellContentView.frame.origin.x + xDiff, self.customizedCellContentView.frame.origin.y, self.customizedCellContentView.frame.size.width, self.customizedCellContentView.frame.size.height);
    }];
    
    if (pan.state != UIGestureRecognizerStateEnded) {
        
        self.previousTranslation = [pan translationInView:self.contentView];
    }else {
        self.previousTranslation = CGPointZero;
    }

}

#pragma mark - gesture delegate 
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    NSLog(@"%s", __func__);
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    NSLog(@"%s", __func__);
    return YES;
}


@end
