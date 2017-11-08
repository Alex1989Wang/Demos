//
//  DemoVimViewController.m
//  KeyboardShorcutsDemo
//
//  Created by JiangWang on 13/07/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "DemoVimViewController.h"

@interface DemoVimViewController ()
@property (nonatomic, copy) NSString *firstVimProperty;

//竖向修改
@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, weak) UIView *contentViewTwo;
@property (nonatomic, weak) UIView *jfoiadjfioa;
@property (nonatomic, weak) UIView *contentViewTwo;
@property (nonatomic, weak) UIView *contentViewThree;
@end

@implementation DemoVimViewController

/* 
 文件内跳转
 1. G, gg, 19G
 2. /
 3. CMD + ]
 4. ``
 */
- (void)testCommandPlus {
    self.firstVimProperty;
    //在这里修改
}


/*
 复制、粘贴
 
 使用定义多个property作为示范
 first vim 
 
 property
 
 yy p
 */

/*
 选中、修改
 1. 选修饰符内内容
 2. 直接修改任何成对修饰符
 3. 竖向修改
 */
- (void)testChangeIn {
    NSLog(@"change anything in (括号)");
}

@end
