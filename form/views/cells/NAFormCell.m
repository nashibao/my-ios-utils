//
//  NAFormCell.m
//  SK3
//
//  Created by nashibao on 2012/09/27.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NAFormCell.h"

#import "NATheme.h"

@implementation NAFormCell

- (void)setFormValue:(NAFormValue *)formValue{
    _formValue = formValue;
    formValue.targetViewDelegate = self;
    [formValue highlight];
    [self formValue:formValue isUploading:formValue.isUploading];
}

- (void)formValue:(NAFormValue *)formValue focused:(BOOL)focused{
}

- (void)formValue:(NAFormValue *)formValue highlighted:(BOOL)highlighted{
    if(highlighted){
        [self setBackgroundColor:[[NATheme currentTheme] cellErrorHighlightBackgroundColor]];
        [self.textLabel setBackgroundColor:[[NATheme currentTheme] cellErrorHighlightBackgroundColor]];
        [self.detailTextLabel setBackgroundColor:[[NATheme currentTheme] cellErrorHighlightBackgroundColor]];
    }else{
        [self setBackgroundColor:[[NATheme currentTheme] cellBackgroundColor]];
        [self.textLabel setBackgroundColor:[[NATheme currentTheme] cellBackgroundColor]];
        [self.detailTextLabel setBackgroundColor:[[NATheme currentTheme] cellBackgroundColor]];
    }
    [self update];
}

- (void)update{
    
}

- (void)formValue:(NAFormValue *)formValue isUploading:(BOOL)isUploading{
    if(isUploading){
        [self setAlpha:0.5f];
    }else{
        [self setAlpha:1.0f];
    }
}

- (void)formValueWillValidate:(NAFormValue *)formValue{
    
}

- (void)formValueDidValidate:(NAFormValue *)formValue{
    
}

- (BOOL)focusEnabled{
    return NO;
}

@end
