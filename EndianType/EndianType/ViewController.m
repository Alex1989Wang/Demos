//
//  ViewController.m
//  EndianType
//
//  Created by JiangWang on 01/12/2016.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "ViewController.h"

typedef NS_ENUM(NSUInteger, EndianType)
{
    EndianTypeUnknown,
    EndianTypeBig,
    EndianTypeLittle,
};

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"byte order: %lu", [self byteOrder]);
}

- (EndianType)byteOrder
{
    EndianType type = EndianTypeUnknown;
    union {
        short sNum;
        char cNum[sizeof(short)];
    }un;
    
    un.sNum = 0x0102;
    if (sizeof(short) == 2)
    {
        if(un.cNum[0] == 1 && un.cNum[1] == 2)
        {
            type = EndianTypeBig;
        }
        else if (un.cNum[0] == 2 && un.cNum[1] == 1)
        {
            type = EndianTypeLittle;
        }
    }
    return type;
}



@end
