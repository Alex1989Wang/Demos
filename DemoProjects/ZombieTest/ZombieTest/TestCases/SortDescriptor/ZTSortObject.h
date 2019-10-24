//
//  ZTSortObject.h
//  ZombieTest
//
//  Created by JiangWang on 2019/10/15.
//  Copyright © 2019 JiangWang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZTSortObject : NSObject

@property (nonatomic, strong) NSDate *createdDate;

- (void)reload;

@end

NS_ASSUME_NONNULL_END
