//
//  Defines.h
//  P3ShowCase
//
//  Created by JiangWang on 2021/1/20.
//

#import <Foundation/Foundation.h>


#define F2U8(x)         (int)MAX(MIN(255, x * 255.f + 0.5f), 0)
#define U82F(x)         MAX(MIN((float)(x)/255.f, 1.f), 0.f)

