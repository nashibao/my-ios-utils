//
//  NAFormPushCell.m
//  SK3
//
//  Created by nashibao on 2012/10/15.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NAFormPushCell.h"

@implementation NAFormPushCell

@synthesize formValue = _formValue;

- (void)setFormValue:(NAFormValue *)formValue{
    _formValue = formValue;
    [self.textLabel setText:self.formValue.label];
    NSString *val = _formValue.stringValue;
    if(val && [val length]>0){
        [self.detailTextLabel setText:val];
    }else{
        [self.detailTextLabel setText:@"選択して下さい．"];
    }
}

@end
