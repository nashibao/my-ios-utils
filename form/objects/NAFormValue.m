//
//  NAFormValue.m
//  SK3
//
//  Created by nashibao on 2012/09/26.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NAFormValue.h"

#import "NATheme.h"

#import "NAValidator.h"

@implementation NAFormValue

- (id)initWithValue:(id)value label:(NSString *)label name:(NSString *)name targetView:(UIView *)targetView validateRules:(NSDictionary *)validateRules options:(NSDictionary *)options{
    self = [self init];
    self.value = value;
    self.label = label;
    self.name = name;
    self.targetView = targetView;
    self.validatRules = validateRules;
    self.options = options;
    return self;
}

- (BOOL)validate{
    NSMutableDictionary *_temp = [@{} mutableCopy];
    for(NSString *key in self.validatRules){
        NSString *errorMessage = nil;
        if(key==@"required"){
            errorMessage = [NAValidator validateRequired:self.value options:self.validatRules[key]];
        }else if(key==@"mail"){
            errorMessage = [NAValidator validateMail:self.value options:self.validatRules[key]];
        }else if(key==@"custom"){
            errorMessage = [NAValidator validateCustom:self.value options:self.validatRules[key]];
        }else if(key==@"pattern"){
            errorMessage = [NAValidator validatePattern:self.value options:self.validatRules[key]];
        }else if(key==@"maxLength"){
            errorMessage = [NAValidator validateMaxLength:self.value options:self.validatRules[key]];
        }else if(key==@"minLength"){
            errorMessage = [NAValidator validateMinLength:self.value options:self.validatRules[key]];
        }else if(key==@"equal"){
            errorMessage = [NAValidator validateEqual:self.value options:self.validatRules[key]];
        }
        if(errorMessage){
            _temp[key] = errorMessage;
        }
    }
    self.errors = _temp;
    [self highlight];
    return [self.errors count] > 0;
}

- (NSString *)shortErrorMessage{
    NSMutableString *_temp = [@"" mutableCopy];
    for(NSString *_key in self.errors){
        NSString *message = self.errors[_key];
        if([_temp length] > 0)
            [_temp appendString:@", "];
        [_temp appendString:message];
    }
    return _temp;
}

- (void)highlight{
    if(self.targetView){
        if([self.targetView isKindOfClass:[UITableViewCell class]]){
            UITableViewCell *cell = (UITableViewCell *)self.targetView;
            if([self.errors count] > 0){
                [cell setBackgroundColor:[[NATheme currentTheme] cellErrorHighlightBackgroundColor]];
            }else{
                [cell setBackgroundColor:[[NATheme currentTheme] cellBackgroundColor]];
            }
        }
    }
}

- (NSString *)stringValue{
    if(self.cachedStringValue)
        return self.cachedStringValue;
    if(self.value)
        return [NSString stringWithFormat:@"%@", self.value];
    return @"";
}

@end
