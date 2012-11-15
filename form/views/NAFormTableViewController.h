//
//  NAFormTableViewController.h
//  SK3
//
//  Created by nashibao on 2012/10/15.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NAArrayTableViewController.h"

#import "NAFormCell.h"

@protocol NAFormTableViewControllerDelegate;

@interface NAFormTableViewController : NAArrayTableViewController <NAFormCellDelegate, NAFormTableViewControllerDelegate>

- (BOOL)enableNextFocus;

- (void)changeFormValue:(NAFormValue *)formValue newValue:(id)newValue;

- (void)closeCustomModelViewController:(UIViewController *)controller formValue:(NAFormValue *)formValue;

@property (strong, nonatomic) UIViewController *customModelViewController;

@end

@protocol NAFormTableViewControllerDelegate <NSObject>

- (void)closeCustomModelViewController:(UIViewController *)controller formValue:(NAFormValue *)formValue;

@end
