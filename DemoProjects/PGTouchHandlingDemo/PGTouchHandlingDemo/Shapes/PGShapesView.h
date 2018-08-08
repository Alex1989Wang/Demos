//
//  PGShapesView.h
//  PGTouchHandlingDemo
//
//  Created by JiangWang on 2018/8/8.
//  Copyright © 2018 JiangWang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PGShapesType) {
    PGShapesTypeSquare,
    PGShapesTypeCircle,
    PGShapesTypeTriangle,
};

//200的等宽高区域
#define kPGShapeWidthHeight (200)

NS_ASSUME_NONNULL_BEGIN

@interface PGShapesView : UIView

//随机获得一个shape
+ (instancetype)shapeView;

@end

NS_ASSUME_NONNULL_END
