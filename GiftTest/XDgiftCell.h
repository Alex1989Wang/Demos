//
//  XDgiftCell.h
//  testGift
//
//  Created by 形点网络 on 16/7/1.
//  Copyright © 2016年 形点网络. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDgiftCell : UICollectionViewCell

@property (nonatomic, assign, getter=isSelect) BOOL select;

@property (nonatomic, strong) UIImage *image;
@end
