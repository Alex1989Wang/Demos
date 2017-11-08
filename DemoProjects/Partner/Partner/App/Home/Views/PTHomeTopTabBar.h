//
//  PTHomeTopTabBar.h
//  Partner
//
//  Created by JiangWang on 13/08/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import <TYPagerController/TYTabPagerBar.h>
#import <TYPagerController/TYTabPagerBarCell.h>

@interface PTHomeTopTabBar : TYTabPagerBar
@end

@interface PTHomeTopTabBarCell : UICollectionViewCell<TYTabPagerBarCellProtocol>
@property (nonatomic, strong, readonly) UIImageView *cellImageView;
@end
