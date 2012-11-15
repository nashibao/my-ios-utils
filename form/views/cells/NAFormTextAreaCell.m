//
//  NAFormTextAreaCell.m
//  SK3
//
//  Created by nashibao on 2012/11/14.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NAFormTextAreaCell.h"

@implementation NAFormTextAreaCell

- (void)setFormValue:(NAFormValue *)formValue{
    [super setFormValue:formValue];
    NSString *val = self.formValue.stringValue;
    if(val && [val length]>0){
        [self.textField setText:val];
    }else{
        [self.textField setText:@""];
    }
    if(formValue.validatRules[@"number"]){
        [self.textField setKeyboardType:UIKeyboardTypeNumberPad];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    NSString *modifiedData = [self.textField text];
    if(self.delegate){
        [self.delegate formCell:self inTableViewController:self.tableViewController modifiedData:modifiedData formValue:self.formValue];
    }
}
//
//- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    if(self.delegate){
//        [self.delegate formCell:self inTableViewController:self.tableViewController nextFocus:YES formValue:self.formValue];
//    }
//    [textField resignFirstResponder];
//    return YES;
//}

- (BOOL)focusEnabled{
    return YES;
}

- (void)formValue:(NAFormValue *)formValue focused:(BOOL)focused{
    [self.textField becomeFirstResponder];
}

- (void)formValueWillValidate:(NAFormValue *)formValue{
    //    NSString *modifiedData = [self.textField text];
    //    if(self.delegate){
    //        [self.delegate formCell:self inTableViewController:self.tableViewController modifiedData:modifiedData formValue:self.formValue indexPath:self.indexPath];
    //    }
}

@end
