//
//  PCMainDownCameraView.h
//  SelfieCamera
//
//  Created by Cc on 2016/11/1.
//  Copyright © 2016年 Pinguo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCMainDownCameraView : UIView

- (void)pAsyncUpdate;


- (void)pMovePoint:(CGPoint)point;


/**
 *  0 = (0, -h, w, h)
 *  1 = (0, 0, w, h)
 */
- (void)pSetupStatus:(NSInteger)state withAnimation:(BOOL)animation withCompletion:(void (^ __nullable)(BOOL finished))completion;

@end

