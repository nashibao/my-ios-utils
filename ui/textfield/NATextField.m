//
//  NATextField.m
//  SK3
//
//  Created by nashibao on 2012/11/12.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NATextField.h"

#import "ViewMacros.h"

@implementation NATextField

COMMON_INITIAL_SETTINGS()

- (void)commonInitialSettings{
    self.keyboardHeaderViewController = [[NAKeyboardHeaderViewController alloc] initWithNibName];
    self.inputAccessoryView = _keyboardHeaderViewController.view;
    _keyboardHeaderViewController.textControl = self;
}

@end
