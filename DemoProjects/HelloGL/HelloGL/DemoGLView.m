//
//  DemoGLView.m
//  HelloGL
//
//  Created by JiangWang on 07/06/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "DemoGLView.h"
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES2/gl.h>

@implementation DemoGLView

+ (Class)layerClass {
    return [CAEAGLLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupLayer];
        [self setupContext];
        [self setupRenderBuffer];
        [self setupFrameBuffer];
        [self render];
    }
    return self;
}

- (void)setupLayer {
    _eaglLayer = (CAEAGLLayer *)self.layer;
    _eaglLayer.opaque = YES;
}

- (void)setupContext {
    EAGLRenderingAPI apiVersion = kEAGLRenderingAPIOpenGLES2;
    _glContext = [[EAGLContext alloc] initWithAPI:apiVersion];
    if (!_glContext) {
        NSLog(@"failed to setup glcontext.");
        exit(1);
    }
    
    if (![EAGLContext setCurrentContext:_glContext]) {
        NSLog(@"failed to set current context.");
        exit(1);
    }
}

- (void)setupRenderBuffer {
    glGenRenderbuffers(1, &_colorRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
    [_glContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];
}

- (void)setupFrameBuffer {
    GLuint frameBuffer = 0;
    glGenFramebuffers(1, &frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, frameBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderBuffer);
}

- (void)render {
    glClearColor(0, 104/255.0, 55/255.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    [self.glContext presentRenderbuffer:GL_RENDERBUFFER];
}

@end
