//
//  ViewController.m
//  textShare
//
//  Created by 形点网络 on 16/6/29.
//  Copyright © 2016年 形点网络. All rights reserved.
//

#import "ViewController.h"
#import <UMSocial.h>
#import "UMSocialQQHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialWechatHandler.h"
#import "XDShareView.h"

@interface ViewController ()<XDShareViewDelegate>
@property (nonatomic, weak) XDShareView *v;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
}


// UMshare 576cddb3e0f55a29140006ec
- (IBAction)shareClick:(id)sender {
    
    // 创建分享按钮
    XDShareView *view = [[XDShareView alloc] init];
    view.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 170, [UIScreen mainScreen].bounds.size.width, 170);
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
    switch (btn.tag) {
        case 100:
            
            NSLog(@"点击了朋友圈");
        {
            [UMSocialData defaultData].extConfig.title = @"朋友圈";
            [UMSocialData defaultData].extConfig.wechatSessionData.url = @"http://baidu.com";
            UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                                @"http://www.baidu.com/img/bdlogo.gif"];
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:@"分享内嵌文字" image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
                if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功！");
                }
            }];
        }
            break;
        case 101:
            
            NSLog(@"点击了微信好友");
        {
            [UMSocialData defaultData].extConfig.title = @"微信好友";
            [UMSocialData defaultData].extConfig.wechatSessionData.url = @"http://baidu.com";
            UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                                @"http://www.baidu.com/img/bdlogo.gif"];
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:@"分享内嵌文字" image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
                if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功！");
                }
            }];
        }
            break;
        case 102:
            
            NSLog(@"点击了QQ好友");
        {
            
            
        }
            break;
        case 103:
            
            NSLog(@"点击了新浪微博");
        {
            [UMSocialData defaultData].extConfig.title = @"新浪微博";
            [UMSocialData defaultData].extConfig.sinaData.urlResource.url = @"http://baidu.com";
            UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                                @"http://www.baidu.com/img/bdlogo.gif"];
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:@"分享内嵌文字" image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
                if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功！");
                }
            }];
        }
            break;
        case 104:
            
            NSLog(@"点击了QQ空间");
        {
            
        }
            break;
        case 105:
            
            NSLog(@"点击了更多");
        {
            NSString *info = @"share test";  // 分享的标题
            //    UIImage *image=[UIImage imageNamed:@"UIBarButtonItemGrid.png"]; // 分享的图片
            NSURL *url = [NSURL URLWithString:@"http://www.google.com"]; // 分享的链接
            NSArray *postItems=@[info, url];
            
            UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:postItems applicationActivities:nil];
            [self presentViewController:controller animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}












































































- (IBAction)moreClick:(id)sender {
    NSString *info = @"share test";  // 分享的标题
//    UIImage *image=[UIImage imageNamed:@"UIBarButtonItemGrid.png"]; // 分享的图片
    NSURL *url = [NSURL URLWithString:@"http://www.google.com"]; // 分享的链接
    NSArray *postItems=@[info, url];
    
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:postItems applicationActivities:nil];
    
//    // Exclude all activities except AirDrop.
//    NSArray *excludedActivities = @[UIActivityTypePostToTwitter, UIActivityTypePostToFacebook,
//                                    UIActivityTypePostToWeibo,
//                                    UIActivityTypeMessage, UIActivityTypeMail,
//                                    UIActivityTypePrint, UIActivityTypeCopyToPasteboard,
//                                    UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll,
//                                    UIActivityTypeAddToReadingList, UIActivityTypePostToFlickr,
//                                    UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo];
//    controller.excludedActivityTypes = excludedActivities;
    
    // Present the controller
    [self presentViewController:controller animated:YES completion:nil];
    
//    UIDocumentInteractionController;
}
@end
