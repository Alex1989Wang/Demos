//
//  XDInputLimitTextView.m
//  MaxNumberInputTextView
//
//  Created by JiangWang on 7/26/16.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "XDInputLimitTextView.h"

@interface XDInputLimitTextView()<UITextViewDelegate>

@end

@implementation XDInputLimitTextView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.delegate = self;
        
        [self initializeProperties];
    }
    return self;
}

- (void)initializeProperties {
    /* the initial values of the text view's properties */
    _maxNumOfLines = NSIntegerMax;
    _maxNumOfCharacters = NSIntegerMax;
}

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
// replacementText:(NSString *)text
//{
//    NSString *combinedString = [textView.text stringByReplacingCharactersInRange:range withString:text];
//    
//    NSLog(@"range: %@ -- replacement text: %@ -- commbined string: %@", NSStringFromRange(range), text, combinedString);
//    
//    NSInteger canInputLength = self.maxNumOfCharacters - combinedString.length;
//    
//    NSLog(@"characters need to input: %ld", canInputLength);
//    
//    if (canInputLength >= 0)
//    {
//        return YES;
//    }else {
//        NSInteger len = text.length + canInputLength;
//        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
//        NSRange rg = {0,MAX(len,0)};
//        
//        if (rg.length > 0)
//        {
//            NSString *s = [text substringWithRange:rg];
//            
//            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
//        }
//        return NO;
//    }
//    
//}

- (void)textViewDidChange:(UITextView *)textView
{
    NSString  *presentText = textView.text;
    NSInteger presentCharacterNum = presentText.length;
    
    if (presentCharacterNum > self.maxNumOfCharacters)
    {
        // truncate the string to the maximally allowed length;
        NSString *s = [presentText substringToIndex:self.maxNumOfCharacters];
        
        [textView setText:s];
    }
    
    //不让显示负数
    NSLog(@"characters: %@, count remaining: %ld", textView.text, self.maxNumOfCharacters - presentCharacterNum);
    NSLog(@"characters remaining: %@", [NSString stringWithFormat:@"%ld/%ld",MAX(0,self.maxNumOfCharacters - presentCharacterNum), self.maxNumOfCharacters]);
}

@end
