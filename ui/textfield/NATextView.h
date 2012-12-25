//
//  NATextView.h
//  SK3
//
//  Created by nashibao on 2012/11/14.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NAKeyboardHeaderViewController.h"

@interface NATextView : UITextView

@property (strong, nonatomic) NAKeyboardHeaderViewController *keyboardHeaderViewController;

@end
