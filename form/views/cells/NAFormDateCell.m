//
//  NAFormDateCell.m
//  SK3
//
//  Created by nashibao on 2012/11/14.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NAFormDateCell.h"

@implementation NAFormDateCell

- (void)setFormValue:(NAFormValue *)formValue{
    [super setFormValue:formValue];
    [self.textLabel setText:self.formValue.label];
    NSString *val = self.formValue.stringValue;
    if(val && [val length]>0){
        [self.detailTextLabel setText:val];
    }else{
        [self.detailTextLabel setText:@""];
    }
}


@end
