////
////  PCMainMengbanV.m
////  SelfieCamera
////
////  Created by Cc on 2017/1/22.
////  Copyright © 2017年 Pinguo. All rights reserved.
////
//
//#import "SCMainMengbanV.h"
//#import <pg_sdk_common/pg_sdk_common.h>
//
//@interface PCMainMengbanV ()
//
//    @property (nonatomic,strong) UIButton *xxx;
//    @property (nonatomic,weak) id<PCMainMengbanVDelegate> mDelegate;
//
//@end
//
//@implementation PCMainMengbanV
//
//- (instancetype)initWithFrame:(CGRect)rect withDelegate:(id<PCMainMengbanVDelegate>)delegate
//{
//    self = [super initWithFrame:rect];
//    if (self) {
//        
//        _mDelegate = delegate;
//        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
//        
//        
//        
//        {
//            // body
//            CGFloat _x = 0;
//            CGFloat _w = self.bounds.size.width;
//            CGFloat _h = _w / (640.0 / 582.0);
//            CGFloat _y = self.bounds.size.height - PCUIGeometricAdaptation1136(360.0) - _h;
//            
//            UIView *av = [[UIView alloc] initWithFrame:CGRectMake(_x, _y, _w, _h)];
//            av.userInteractionEnabled = YES;
//            NSString *path = [[NSBundle mainBundle] pathForResource:@"MainRecourse/body" ofType:@"png"];
//            if (path) {
//                
//                UIImage *image = [UIImage imageWithContentsOfFile:path];
//                av.layer.masksToBounds = YES;
//                av.layer.contentsGravity = kCAGravityResizeAspectFill;
//                av.layer.contents = (id)image.CGImage;
//                [self addSubview:av];
//            }
//            SDKAssertElseLog(@"");
//        }
//        
//        {
//            // 箭头
//            CGFloat _w = PCUIGeometricAdaptation640(46);
//            CGFloat _h = _w / (46.0 / 92);
//            CGFloat _x = (self.bounds.size.width - _w) / 2.0;
//            CGFloat _y = self.bounds.size.height - PCUIGeometricAdaptation1136(205) - _h;
//            UIView *av = [[UIView alloc] initWithFrame:CGRectMake(_x, _y, _w, _h)];
//            av.userInteractionEnabled = YES;
//            NSString *path = [[NSBundle mainBundle] pathForResource:@"MainRecourse/allow" ofType:@"png"];
//            if (path) {
//                
//                UIImage *image = [UIImage imageWithContentsOfFile:path];
//                av.layer.masksToBounds = YES;
//                av.layer.contentsGravity = kCAGravityResizeAspectFill;
//                av.layer.contents = (id)image.CGImage;
//                [self addSubview:av];
//            }
//            SDKAssertElseLog(@"");
//        }
//        
//        {
//            // 国际化文字
//            CGFloat _w = self.bounds.size.width;
//            CGFloat _h = _w / (640.0 / 300.0);
//            CGFloat _x = (self.bounds.size.width - _w) / 2.0;
//            CGFloat _y = self.bounds.size.height - PCUIGeometricAdaptation1136(256) - _h;
//            UIView *av = [[UIView alloc] initWithFrame:CGRectMake(_x, _y, _w, _h)];
//            av.userInteractionEnabled = YES;
//            NSString *lang = [[pg_sdk_common_device_manager instance] pGotSystemLanguage];
//            NSString *name = @"MainRecourse/title_en";
//            if ([lang isEqualToString:kPg_common_language_zh_Hans]
//                || [lang isEqualToString:kPg_common_language_zh_Hant]
//                || [lang isEqualToString:kPg_common_language_ja]) {
//                
//                name = [NSString stringWithFormat:@"MainRecourse/title_%@", lang];
//            }
//            
//            NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"png"];
//            if (path) {
//                
//                UIImage *image = [UIImage imageWithContentsOfFile:path];
//                av.layer.masksToBounds = YES;
//                av.layer.contentsGravity = kCAGravityResizeAspectFill;
//                av.layer.contents = (id)image.CGImage;
//                [self addSubview:av];
//            }
//            SDKAssertElseLog(@"");
//        }
//        
//        
//        self.xxx = [[UIButton alloc] initWithFrame:self.bounds];
//        [self.xxx addTarget:self action:@selector(onClick:) forControlEvents:(UIControlEventTouchUpInside)];
//        [self addSubview:self.xxx];
//    }
//    
//    return self;
//}
//
//- (void)dealloc
//{
//    [self.xxx removeTarget:self action:nil forControlEvents:(UIControlEventAllEvents)];
//    self.xxx = nil;
//}
//
//- (void)onClick:(id)sender
//{
//    [self.mDelegate dgPCMainMengbanV_close];
//}
//
//@end

