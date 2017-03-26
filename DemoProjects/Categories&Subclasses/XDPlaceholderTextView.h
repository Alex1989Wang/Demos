//
//  XDPlaceholderTextView.h
//  seeYouTime
//
//  Created by JiangWang on 7/29/16.
//  Copyright © 2016 形点网络. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDPlaceholderTextView : UITextView

@property (copy, nonatomic) IBInspectable NSString *placeholder;
@property (nonatomic) IBInspectable double fadeTime;
@property (copy, nonatomic) NSAttributedString *attributedPlaceholder;
@property (retain, nonatomic) UIColor *placeholderTextColor UI_APPEARANCE_SELECTOR;

@end
