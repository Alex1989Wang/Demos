//
//  JWWaveTableCell.h
//  JWLayerTest
//
//  Created by JiangWang on 19/03/2018.
//  Copyright © 2018 JiangWang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, JWWaveViewType) {
    JWWaveViewTypeTimer,
    JWWaveViewTypeReplicator,
};

#define kJWTableCellHeight (60)

@interface JWWaveTableCell : UITableViewCell
@property (nonatomic, assign) JWWaveViewType waveViewType;
@end
