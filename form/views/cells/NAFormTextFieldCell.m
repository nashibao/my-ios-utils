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
    [self update];
}

- (void)update{
    [self.textField setPlaceholder:self.formValue.label];
    NSString *val = self.formValue.stringValue;
    if(val && [val length]>0){
        [self.textField setText:val];
    }else{
        [self.textField setText:@""];
    }
    if(self.formValue.validatRules[@"number"]){
        [self.textField setKeyboardType:UIKeyboardTypeNumberPad];
    }
    NSString *errorMessage = [self.formValue shortErrorMessage];
    if(errorMessage){
        [self.helpLabel setText:errorMessage];
        [self.helpLabel setTextColor:[UIColor redColor]];
    }else{
        [self.helpLabel setTextColor:[UIColor lightGrayColor]];
        if(self.formValue.helpText){
            [self.helpLabel setText:self.formValue.helpText];
        }else{
            [self.helpLabel setText:@""];
        }
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(self.delegate){
        [self.delegate formCell:self inTableViewController:self.tableViewController nextFocus:YES formValue:self.formValue];
    }
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSString *modifiedData = [self.textField text];
    if(self.delegate){
        [self.delegate formCell:self inTableViewController:self.tableViewController modifiedData:modifiedData formValue:self.formValue];
    }
}

- (BOOL)focusEnabled{
    return YES;
}

- (void)formValue:(NAFormValue *)formValue focused:(BOOL)focused{
    [self.textField becomeFirstResponder];
}

- (void)formValueWillValidate:(NAFormValue *)formValue{
    [self.textField resignFirstResponder];
//    NSString *modifiedData = [self.textField text];
//    if(self.delegate){
//        [self.delegate formCell:self inTableViewController:self.tableViewController modifiedData:modifiedData formValue:self.formValue indexPath:self.indexPath];
//    }
}

@end
