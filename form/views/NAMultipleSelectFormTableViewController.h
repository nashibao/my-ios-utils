//
//  NAMultipleSelectFormTableViewController.h
//  SK3
//
//  Created by nashibao on 2012/10/31.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NATableViewController.h"

#import "NAMultipleSelectFormValue.h"

#import "NATableViewController.h"

#import "NAFormTableViewController.h"

@interface NAMultipleSelectFormTableViewController : NATableViewController

@property (strong, nonatomic) NAMultipleSelectFormValue *formValue;

@property (weak, nonatomic) NAFormTableViewController *parentTableViewController;

@end
