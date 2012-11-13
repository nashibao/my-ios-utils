//
//  NAKeyboardHeaderViewController.m
//  SK3
//
//  Created by nashibao on 2012/11/12.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NAKeyboardHeaderViewController.h"

@interface NAKeyboardHeaderViewController ()

@end

@implementation NAKeyboardHeaderViewController


- (void)setTextControl:(UIControl *)textControl{
    if([textControl isKindOfClass:[UITextField class]]){
        UITextField *textField = (UITextField *)textControl;
        textField.inputAccessoryView = self.view;
    }else if([textControl isKindOfClass:[UITextView class]]){
        UITextView *textView = (UITextView *)textControl;
        textView.inputAccessoryView = self.view;
    }
    _textControl = textControl;
}

- (IBAction)close:(id)sender{
    if(_textControl){
        [_textControl resignFirstResponder];
    }
}
@end
