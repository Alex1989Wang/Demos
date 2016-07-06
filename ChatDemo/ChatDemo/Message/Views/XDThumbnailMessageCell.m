//
//  XDThumbnailMessageCell.m
//  ChatDemo
//
//  Created by JiangWang on 7/5/16.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "XDThumbnailMessageCell.h"
#import "XDThumbnailMessage.h"

/* frame related */
#define kDeleteButtomWidth self.deleteMessageButton.frame.size.width
#define kUnreadOrReadButtonWidth self.unreadOrReadButton.frame.size.width
#define kPersonalPageButtonWidth self.personalPageButton.frame.size.width

/* animation time */
#define kAnimationTime 0.5f

@interface XDThumbnailMessageCell()

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
@property (weak, nonatomic) IBOutlet UIButton *unreadOrReadButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteMessageButton;
@property (weak, nonatomic) IBOutlet UIButton *personalPageButton;

@end

@implementation XDThumbnailMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //gesture recognizer left and right;
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleCellSwipe:)];
    [leftSwipe setDirection:UISwipeGestureRecognizerDirectionLeft];
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleCellSwipe:)];
    [rightSwipe setDirection:UISwipeGestureRecognizerDirectionRight];
    
    [self addGestureRecognizer:leftSwipe];
    [self addGestureRecognizer:rightSwipe];
    
    //round the message count label
    self.messageCountLabel.layer.cornerRadius = 0.5 * self.messageCountLabel.frame.size.height;
    self.messageCountLabel.layer.masksToBounds = YES;
}

#pragma mark - assign values;
- (void)setThumbnailMessage:(XDThumbnailMessage *)thumbnailMessage {
    _thumbnailMessage = thumbnailMessage;
    
#warning use a test icon image - change this later;
    self.userIconImageView.image = [UIImage imageNamed:@"test_icon_image"];
    self.userNameLabel.text = thumbnailMessage.name;
    self.userDistanceLabel.text = thumbnailMessage.distance;
    self.messageLabel.text = thumbnailMessage.messageContent;
    self.messageCountLabel.text = thumbnailMessage.messageCount;
    self.latestMessageReceivedTimeLabel.text = thumbnailMessage.latestMessageRecivedTime;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    /*
     cell reuse related;
     */
    CGRect customizedViewFrame = self.customizedCellContentView.frame;
    if (self.thumbnailMessage.position == XDThumbnailMessageCellOriginal) {
        customizedViewFrame.origin.x = 0.0f;
        self.customizedCellContentView.frame = customizedViewFrame;
    }else if (self.thumbnailMessage.position == XDThumbnailMessageCellRight) {
        customizedViewFrame.origin.x = kPersonalPageButtonWidth;
        self.customizedCellContentView.frame = customizedViewFrame;
    }else {
        customizedViewFrame.origin.x = -1.0 * (kDeleteButtomWidth + kUnreadOrReadButtonWidth);
        self.customizedCellContentView.frame = customizedViewFrame;
    }
}


#pragma mark - taget actions
- (void)handleCellSwipe:(UISwipeGestureRecognizer *)swipe {
    //the original frame - (0, 0, customizedCellContentView.frame.size.width, customizedCellContentView.frame.size.height)
    CGRect customizedViewFrame = self.customizedCellContentView.frame;
    
    if (self.thumbnailMessage.position == XDThumbnailMessageCellLeft || self.thumbnailMessage.position == XDThumbnailMessageCellRight) {
        //reset the position if the customized view has been moved;
        customizedViewFrame.origin = CGPointZero;
        [UIView animateWithDuration:kAnimationTime animations:^{
            self.customizedCellContentView.frame = customizedViewFrame;
        }];
        self.thumbnailMessage.position = XDThumbnailMessageCellOriginal;
    }else {
        //jump to the person's personal page
        if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
            customizedViewFrame.origin.x += kPersonalPageButtonWidth;
            [UIView animateWithDuration:kAnimationTime animations:^{
                self.customizedCellContentView.frame = customizedViewFrame;
            }];
            self.thumbnailMessage.position = XDThumbnailMessageCellRight;
        }
        
        //delete the all messages or set all messages to the state of already-read;
        if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
            customizedViewFrame.origin.x -= (kUnreadOrReadButtonWidth + kDeleteButtomWidth);
            [UIView animateWithDuration:kAnimationTime animations:^{
                self.customizedCellContentView.frame = customizedViewFrame;
            }];
            self.thumbnailMessage.position = XDThumbnailMessageCellLeft;
        }
    }
    
}

#pragma mark - button actions
- (IBAction)tagReadOrUnread:(UIButton *)sender {
    
}

- (IBAction)deleteMessage {
    /* the cell should be deleted */
}

- (IBAction)jumpToPersonalPage {
}


@end
