//
//  DemoViewController.m
//  KeyboardShorcutsDemo
//
//  Created by JiangWang on 13/07/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "DemoViewController.h"
#import "DemoVimViewController.h"

@interface DemoViewController ()
@property (nonatomic, copy) NSString *firstPropertyDeclaration;
@end

@implementation DemoViewController

/*
 1.0 新建项目和打开文档有几个常用的快捷键。
 
 Shift + CMD + n为新建一个项目
 OPT + CMD + n为项目新建一个文件group
 CMD + n为新建一个源文件
 
 CMD + o为打开一个文件（不常用，除了误触）
 Shift + CMD + o为快速打开（模糊搜索）
 */

/* 
 文件浏览这个部分有三个常用的快捷键组合：
 
 CMD + Shift + O 模糊查找
 CMD + Shift + J 展开该文件所在的项目目录，同时在文件导航区选中该文件
 CMD + J XCode从聚焦文件导航区状态，变回聚焦源文件编辑区状态，源文件进入编辑状态
 CTR + CMD + UP 在头文件和.m文件之间切换
 */

/* 
 在一个头文件或者.m文件中如何快速地定位到某个方法或者property呢？
 
 CTR + 6 搜索文件中定义的property和方法
 
 CTR + CMD + J 跳转到其他文件中定义的方法实现或者property
 CTR + CMD + LEFT 回到上一级
 （vim有其他的快捷键）
 */
- (void)firstMethodImplementation {
    NSLog(@"I am the first method implementation.");
    DemoVimViewController *demoVimVC = [[DemoVimViewController alloc] init];
    
    //如何跳转到其他文件的定义
    NSLog(@"Second property declaration: %@", demoVimVC.secondPropertyDeclaration);
}

/*
 自定义行为
 */

@end
