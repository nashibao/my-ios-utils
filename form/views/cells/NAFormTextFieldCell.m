//
//  NAFormTextFieldCell.m
//  SK3
//
//  Created by nashibao on 2012/09/27.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NAFormTextFieldCell.h"

@implementation NAFormTextFieldCell

- (void)setFormValue:(NAFormValue *)formValue{
    [super setFormValue:formValue];
    [self.textField setPlaceholder:formValue.label];
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

- (void)textFieldDidBeginEditing:(UITextField *)textField{
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(self.delegate){
        [self.delegate formCell:self inTableViewController:self.tableViewController nextFocus:YES formValue:self.formValue indexPath:self.indexPath];
    }
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSString *modifiedData = [self.textField text];
    if(self.delegate){
        [self.delegate formCell:self inTableViewController:self.tableViewController modifiedData:modifiedData formValue:self.formValue indexPath:self.indexPath];
    }
}

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
