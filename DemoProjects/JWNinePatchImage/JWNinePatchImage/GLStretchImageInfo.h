//
//  GLStretchImageInfo.h
//  JWNinePatchImage
//
//  Created by JiangWang on 28/12/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLEdgeInsets : NSObject
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat right;

- (UIEdgeInsets)edgeInsets;
@end

@interface GLStretchImageInfo : NSObject
@property (nonatomic, strong) GLEdgeInsets *strechInsets;
@property (nonatomic, strong) GLEdgeInsets *contentInsets;

- (instancetype)initWithImageJson:(NSString *)json;
@end
