//
//  NAFormDateViewController.m
//  SK3
//
//  Created by nashibao on 2012/11/14.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NAFormDateViewController.h"

@interface NAFormDateViewController ()

@end

@implementation NAFormDateViewController

- (IBAction)datePickerValueChanged:(UIDatePicker *)picker {
}

- (IBAction)close:(id)sender {
    self.formValue.value = _datePicker.date;
    [_delegate closeCustomModelViewController:self formValue:self.formValue];
}

@end
