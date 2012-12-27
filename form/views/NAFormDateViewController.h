//
//  NAFormDateViewController.h
//  SK3
//
//  Created by nashibao on 2012/11/14.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NAFormValue.h"

#import "NAFormTableViewController.h"

@interface NAFormDateViewController : UIViewController

@property (strong, nonatomic) NAFormValue *formValue;

@property (weak, nonatomic) id<NAFormTableViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
- (IBAction)datePickerValueChanged:(UIDatePicker *)picker;
- (IBAction)close:(id)sender;

@end
