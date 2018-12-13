//
//  PCMainDownCameraView.m
//  SelfieCamera
//
//  Created by Cc on 2016/11/1.
//  Copyright © 2016年 Pinguo. All rights reserved.
//

#import "SCMainDownCameraView.h"
#import <pg_sdk_common/pg_sdk_common.h>
#import "UIColor+ext.h"

#define kPCMainVC_animationTime 0.3

@interface PCMainDownCameraView ()

    @property (nonatomic,strong) UIView *mV_DownArrow;
    @property (nonatomic,strong) UIView *mV_Camera;
    @property (nonatomic,strong) UIView *mV_BottomCamera;

@end
@implementation PCMainDownCameraView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.clipsToBounds = NO;
        self.backgroundColor = [UIColor colorWithHex:0xFFEDE9];
        {
            CGFloat x = PCUIGeometricAdaptation640(306.0);
            CGFloat y = PCUIGeometricAdaptation1136(1136.0 + 32.0);
            CGFloat w = PCUIGeometricAdaptation640(27.0);
            CGFloat h = PCUIGeometricAdaptation1136(14.0);

            self.mV_DownArrow = [[UIView alloc] initWithFrame:CGRectMake(x, y, w, h)];
            [self addSubview:self.mV_DownArrow];
        }
        {
            CGFloat w = PCUIGeometricAdaptation640(94.0);
            CGFloat h = PCUIGeometricAdaptation1136(106.0);
            CGFloat x = (self.bounds.size.width - w) / 2.0;
            CGFloat y = (self.bounds.size.height - h) / 2.0;

            self.mV_Camera = [[UIView alloc] initWithFrame:CGRectMake(x, y, w, h)];
            [self addSubview:self.mV_Camera];
        }
        {
            CGFloat w = PCUIGeometricAdaptation640(56.0);
            CGFloat h = PCUIGeometricAdaptation1136(46.0);
            CGFloat x = (self.bounds.size.width - w) / 2.0;
            CGFloat y = self.bounds.size.height - h - PCUIGeometricAdaptation1136(10.0);
            
            self.mV_BottomCamera = [[UIView alloc] initWithFrame:CGRectMake(x, y, w, h)];
            [self addSubview:self.mV_BottomCamera];
        }
    }
    return self;
}

- (void)pAsyncUpdate
{
    UIImage *image = [UIImage imageNamed:@"PCA_Main_Top_Down_Arrow"];
    UIImage *imageCamera = [UIImage imageNamed:@"PCA_Main_DownArrow_Camera"];
    UIImage *imageBottomCamera = [UIImage imageNamed:@"PCA_Main_Top_Down_Camera"];
    
    if (image && imageCamera && imageBottomCamera) {
            self.mV_DownArrow.layer.masksToBounds = YES;
            self.mV_DownArrow.layer.contents = (id)image.CGImage;
            self.mV_DownArrow.layer.contentsGravity = kCAGravityResizeAspectFill;
            
            self.mV_Camera.layer.masksToBounds = YES;
            self.mV_Camera.layer.contents = (id)imageCamera.CGImage;
            self.mV_Camera.layer.contentsGravity = kCAGravityResizeAspectFill;
            
            self.mV_BottomCamera.layer.masksToBounds = YES;
            self.mV_BottomCamera.layer.contents = (id)imageBottomCamera.CGImage;
            self.mV_BottomCamera.layer.contentsGravity = kCAGravityResizeAspectFill;
    }
    SDKAssertElseLog(@"");
 
}

//- (void)setFrame:(CGRect)frame
//{
//    [super setFrame:frame];
//    SDKLog(@"frame = %@", NSStringFromCGRect(frame));
//}

- (void)pMovePoint:(CGPoint)point
{
    
    CGFloat y = -self.bounds.size.height + point.y;
    if (y > -self.bounds.size.height) {
    
        self.frame = CGRectMake(0, y, self.bounds.size.width, self.bounds.size.height);
    }
    
    CGFloat bc = - (self.mV_Camera.frame.origin.y + self.mV_Camera.frame.size.height);
    
    if (self.frame.origin.y < bc) {
        
        self.mV_BottomCamera.alpha = 1;
    }
    else if (self.frame.origin.y >= bc && self.frame.origin.y <= - self.mV_Camera.frame.origin.y) {
        
        CGFloat zongchangdu = -self.mV_Camera.frame.origin.y - bc;
        CGFloat dangqian = self.frame.origin.y - bc;
        CGFloat baifenbi = dangqian / zongchangdu;
        CGFloat alphaA = 1.0 * baifenbi;
        
        self.mV_BottomCamera.alpha = 1.0 - alphaA;
    }
    else {
        
        self.mV_BottomCamera.alpha = 0;
    }
}

- (void)pSetupStatus:(NSInteger)state withAnimation:(BOOL)animation withCompletion:(void (^)(BOOL finished))completion
{
    if (state == 0) {
        
        if (animation) {
            
            SDKWS
            [UIView animateWithDuration:kPCMainVC_animationTime animations:^{
                SDKSS
                
                self.frame = CGRectMake(0, -self.bounds.size.height, self.bounds.size.width, self.bounds.size.height);
                
            } completion:^(BOOL finished) {
                SDKSS
                self.mV_BottomCamera.alpha = 1;
                if (completion) {
                    
                    completion(YES);
                }
            }];
        }
        else {
            
            self.mV_BottomCamera.alpha = 1;
            self.frame = CGRectMake(0, -self.bounds.size.height, self.bounds.size.width, self.bounds.size.height);
            if (completion) {
                
                completion(YES);
            }
        }
    }
    else if (state == 1){
        
        if (animation) {
            SDKWS
            [UIView animateWithDuration:kPCMainVC_animationTime animations:^{
                SDKSS
                
                self.frame = self.bounds;
                self.mV_BottomCamera.alpha = 0;
                
            } completion:completion];
        }
        else {
            
            self.frame = self.bounds;
            if (completion) {
                
                completion(YES);
            }
        }
    }
//    else if (state == 2) {
//        
//        CGFloat y = 50;
//        SDKWS
//        [UIView animateWithDuration:kPCMainVC_animationTime animations:^{
//            SDKSS
//            
//            self.frame = CGRectMake(0, -self.bounds.size.height + y, self.bounds.size.width, self.bounds.size.height);
//            
//        } completion:completion];
//    }
    SDKAssertElseLog(@"");
}

@end

