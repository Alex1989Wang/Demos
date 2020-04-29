//
//  OTDummy.h
//  ObjcTests
//
//  Created by JiangWang on 2019/12/18.
//  Copyright © 2019 JiangWang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OTDummy : NSObject {
    BOOL _hasIvar;
}

@property (nonatomic, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
