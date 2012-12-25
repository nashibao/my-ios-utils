//
//  KeyboardHeader.m
//  newsk
//
//  Created by 直樹 柴山 on 11/11/23.
//  Copyright (c) 2011年 s-cubism.inc. All rights reserved.
//

#import "KeyboardHeader.h"

@implementation KeyboardHeader

- (UIControl *)textControl{
    return self._textControl;
}

- (void)setTextControl:(UIControl *)textControl{
    if([textControl isKindOfClass:[UITextField class]]){
        UITextField *textField = (UITextField *)textControl;
        textField.inputAccessoryView = self.view;
    }else if([textControl isKindOfClass:[UITextView class]]){
        UITextView *textView = (UITextView *)textControl;
        textView.inputAccessoryView = self.view;
    }
    self._textControl = textControl;
}

- (IBAction)close:(id)sender {
    if(self._textControl){
        [self._textControl resignFirstResponder];
    }
}

@end
