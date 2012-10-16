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

- (void)formValue:(NAFormValue *)formValue focused:(BOOL)focused{
    
}

- (void)formValue:(NAFormValue *)formValue highlighted:(BOOL)highlighted{
    if(highlighted){
        [self setBackgroundColor:[[NATheme currentTheme] cellErrorHighlightBackgroundColor]];
    }else{
        [self setBackgroundColor:[[NATheme currentTheme] cellBackgroundColor]];
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
