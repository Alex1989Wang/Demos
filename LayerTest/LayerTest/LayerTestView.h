//
//  LayerTestView.h
//  LayerTest
//
//  Created by JiangWang on 09/05/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LayerTestView;
@protocol LayerTestViewDelegate <NSObject>

- (UIImage *)layerTestViewNeedDispalyContent:(LayerTestView *)testView;

@end

@interface LayerTestView : UIView
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, weak) id<LayerTestViewDelegate> delegate;

/**
 override init method

 @return view instance;
 */
- (instancetype)initWithFrame:(CGRect)frame;
@end
