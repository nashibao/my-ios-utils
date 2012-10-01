//
//  NAFormTextFieldCell.h
//  SK3
//
//  Created by nashibao on 2012/09/27.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NAFormCell.h"

#import "NAFormValue.h"

@interface NAFormTextFieldCell : NAFormCell <UITextFieldDelegate>

@property (strong, nonatomic) UITextField *textField;

@end
