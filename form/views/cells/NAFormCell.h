//
//  NAFormCell.h
//  SK3
//
//  Created by nashibao on 2012/09/27.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NAFormValue.h"

#import "NATableViewCell.h"

@protocol NAFormCellDelegate;

@interface NAFormCell : NATableViewCell <NAFormValuTargetViewDelegate>

@property (weak, nonatomic) id<NAFormCellDelegate> delegate;
@property (strong, nonatomic) NAFormValue *formValue;

- (BOOL)focusEnabled;

- (void)update;

@end

@protocol NAFormCellDelegate <NSObject>

@required

- (void)formCell:(NAFormCell *)cell inTableViewController:(UITableViewController *)tableViewController
    modifiedData:(id)modifiedData
       formValue:(NAFormValue *)formValue;

- (void)formCell:(NAFormCell *)cell inTableViewController:(UITableViewController *)tableViewController
    nextFocus:(BOOL)focus
       formValue:(NAFormValue *)formValue;


@end
