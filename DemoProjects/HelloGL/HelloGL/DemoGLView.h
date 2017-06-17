//
//  DemoGLView.h
//  HelloGL
//
//  Created by JiangWang on 07/06/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DemoGLView : UIView
@property (nonatomic, weak) CAEAGLLayer *eaglLayer;
@property (nonatomic, strong) EAGLContext *glContext;
@property (nonatomic, assign) GLuint colorRenderBuffer;
@end
