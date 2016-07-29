//
//  XDShareController.m
//  WeChatSDKShare
//
//  Created by JiangWang on 7/27/16.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "XDShareController.h"
#import "XDShareView.h"

#import "WXApi.h"

@interface XDShareController ()<XDShareViewDelegate>

@property (nonatomic, weak) XDShareView *shareView;

@end

@implementation XDShareController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeView];
}

- (void)initializeView {
    XDShareView *shareView = [XDShareView shareView];
    shareView.delegate = self;
    self.shareView = shareView;
    
    self.view = shareView;
    
}


- (void)shareView:(XDShareView *)view clickButton:(UIButton *)btn
{
    if ([btn.currentTitle isEqualToString:@"朋友圈"]) {
        [self weChatShare:1];
        return;
    }
    
    if ([btn.currentTitle isEqualToString:@"微信"]) {
        [self weChatShare:0];
        return;
    }
    
    if ([btn.currentTitle isEqualToString:@"QQ好友"]) {
        //share to QQ friends;
        
        
        return;
    }
    
    if ([btn.currentTitle isEqualToString:@"新浪微博"]) {
        //share to sina blog
        
        
        return;
    }
    
    if ([btn.currentTitle isEqualToString:@"QQ空间"]) {
        //share to Qzone
        
        
        return;
    }
    
    if ([btn.currentTitle isEqualToString:@"更多"]) {
        //taps the more button
        
        [self moreButtonClicked];
        
        return;
    }
}

- (void)weChatShare:(int)scene {
    //share to wechat and return
    // 1. what oject you want to share
    NSLog(@"wechat share");
    
    WXImageObject *imageOject = [WXImageObject object];
    imageOject.imageData = UIImagePNGRepresentation([UIImage imageNamed:@"wechat"]);
    
    // 2. encapsulate in a message
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"share to wechat";
    message.description = @"change this later - what description to show??";
    message.mediaTagName = @"what's the use of this?";
    message.mediaObject = imageOject;
    [message setThumbImage:[UIImage imageNamed:@"wechat"]];
    
    // 3. encapsulate message in a request
    SendMessageToWXReq *sendRequest = [[SendMessageToWXReq alloc] init];
    sendRequest.message = message;
    sendRequest.bText = NO;
    sendRequest.scene = scene;
    
    // 4. send request
    BOOL sendSuccess = [WXApi sendReq:sendRequest];
    NSLog(@"send success: %d", sendSuccess);
}

- (void)moreButtonClicked {
    NSString *info = @"share test";  // 分享的标题
    NSURL *url = [NSURL URLWithString:@"http://www.google.com"]; // 分享的链接
    NSArray *postItems=@[info, url];
    
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:postItems applicationActivities:nil];
    
    // Exclude all activities except UIActivityTypePostToTwitter, UIActivityTypePostToFacebook,
    // UIActivityTypeMessage, UIActivityTypeMail.
    // UIActivityTypeCopyToPasteboard
    NSArray *excludedActivities = @[UIActivityTypeAirDrop,
                                    UIActivityTypePostToWeibo,
                                    UIActivityTypePrint,
                                    UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll,
                                    UIActivityTypeAddToReadingList, UIActivityTypePostToFlickr,
                                    UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo];
    controller.excludedActivityTypes = excludedActivities;
    
    // Present the controller
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)dealloc {
    NSLog(@"asdfadf");
}


@end
