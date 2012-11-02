//
//  NAFormTableViewController.h
//  SK3
//
//  Created by nashibao on 2012/10/15.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NAArrayTableViewController.h"

#import "NAFormCell.h"

typedef enum FormTableSelectActionType : NSUInteger {
    FormTableSelectActionTypeOpenSelectTable,
    FormTableSelectActionTypeOpenMultipleSelectTable,
} FormTableSelectActionType;

@interface NAFormTableViewController : NAArrayTableViewController <NAFormCellDelegate>


- (BOOL)enableNextFocus;

- (void)changeFormValue:(NAFormValue *)formValue newValue:(id)newValue;

@end
