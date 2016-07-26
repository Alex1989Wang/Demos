//
//  XDInputLimitTextView.h
//  MaxNumberInputTextView
//
//  Created by JiangWang on 7/26/16.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDInputLimitTextView : UITextView

/* the maxmium number of characters the text view allows the user to input */
@property (nonatomic, assign) NSInteger maxNumOfCharacters;

/* maxmiun lines of input the text view allows */
@property (nonatomic, assign) NSInteger maxNumOfLines;

@end
