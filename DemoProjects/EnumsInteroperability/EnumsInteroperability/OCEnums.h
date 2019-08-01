//
//  OCEnums.h
//  EnumsInteroperability
//
//  Created by JiangWang on 2019/7/4.
//  Copyright © 2019 JiangWang. All rights reserved.
//

@import Foundation;

#ifndef OCEnums_h
#define OCEnums_h

typedef NS_ENUM(NSInteger, OCEnumTest) {
    OCEnumTestR1_1 NS_SWIFT_NAME(r1_1) = 1,
    OCEnumTestR1_2 NS_SWIFT_NAME(r1_2) = 2,
    OCEnumTestRFull NS_SWIFT_NAME(rFull),
} NS_SWIFT_NAME(EnumTest);

//typedef NS_ENUM(NSUInteger, OCEnumTest) {
//    OCEnumTestT1,
//    OCEnumTestT2,
//    OCEnumTestT3,
//};


#endif /* OCEnums_h */
