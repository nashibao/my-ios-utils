//
//  KeyboardHeader.h
//  newsk
//
//  Created by 直樹 柴山 on 11/11/23.
//  Copyright (c) 2011年 s-cubism.inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KeyboardHeader : UIViewController

@property (retain, nonatomic) IBOutlet UIToolbar *toolBar;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *closeBarButtonItem;

@property (nonatomic, assign) UIControl *_textControl;
@property (nonatomic, readwrite) UIControl *textControl;

- (IBAction)close:(id)sender;

@end
