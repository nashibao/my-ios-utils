//
//  NATextView.m
//  SK3
//
//  Created by nashibao on 2012/11/14.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NATextView.h"

@implementation NATextView

COMMON_INITIAL_SETTINGS()

- (void)commonInitialSettings{
    self.keyboardHeaderViewController = [[NAKeyboardHeaderViewController alloc] initWithNibName];
    self.inputAccessoryView = _keyboardHeaderViewController.view;
    _keyboardHeaderViewController.textControl = self;
}

@end
