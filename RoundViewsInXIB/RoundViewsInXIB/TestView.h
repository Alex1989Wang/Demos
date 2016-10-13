//
//  TestView.h
//  RoundViewsInXIB
//
//  Created by JiangWang on 13/10/2016.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestView : UIView

@property (weak, nonatomic, readonly) IBOutlet UIImageView *testImageView;


+ (instancetype)testView;

@end
