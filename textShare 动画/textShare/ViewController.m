//
//  ViewController.m
//  textShare
//
//  Created by 形点网络 on 16/6/29.
//  Copyright © 2016年 形点网络. All rights reserved.
//  wx9b64ff39631009d9

#import "ViewController.h"
#import "XDShareView.h"

#import "WXApi.h"

@interface ViewController ()<XDShareViewDelegate>
@property (nonatomic, weak) XDShareView *v;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
}



- (IBAction)shareClick:(id)sender {
    
    // 创建分享按钮
    XDShareView *view = [XDShareView shareView];
    view.delegate = self;
    [self.view addSubview:view];
    
    self.v = view;

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.v removeFromSuperview];
}

- (void)shareView:(XDShareView *)view clickButton:(UIButton *)btn
{
    
    if ([btn.currentTitle isEqualToString:@"微信"]) {
        //share to wechat and return
        // 1. what oject you want to share
        NSLog(@"wechat share");
        
//        WXImageObject *imageOject = [WXImageObject object];
//        imageOject.imageData = UIImagePNGRepresentation([UIImage imageNamed:@"wechat"]);
        
        WXWebpageObject *webPage = [WXWebpageObject object];
        webPage.webpageUrl = @"https://open.weixin.qq.com/";
        
        // 2. encapsulate in a message
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = @"share to wechat";
        message.description = @"change this later - what description to show??";
        message.mediaTagName = @"what's the use of this?";
        message.mediaObject = webPage;
        [message setThumbImage:[UIImage imageNamed:@"wechat"]];
        
        // 3. encapsulate message in a request
        SendMessageToWXReq *sendRequest = [[SendMessageToWXReq alloc] init];
        sendRequest.bText = NO;
        sendRequest.scene = 0;
        
        // 4. send request
        BOOL sendSuccess = [WXApi sendReq:sendRequest];
        NSLog(@"send success: %d", sendSuccess);
    }
    
}



- (IBAction)moreClick:(id)sender {
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
@end
