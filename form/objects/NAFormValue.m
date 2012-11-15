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

NSString * const NAFormCellIdentifierSwitch = @"NAFormCellIdentifierSwitch";
NSString * const NAFormCellIdentifierPushSelect = @"NAFormCellIdentifierPushSelect";
NSString * const NAFormCellIdentifierPush = @"NAFormCellIdentifierPush";
NSString * const NAFormCellIdentifierTextField = @"NAFormCellIdentifierTextField";
NSString * const NAFormCellIdentifierTextArea = @"NAFormCellIdentifierTextArea";
NSString * const NAFormCellIdentifierSecureTextField = @"NAFormCellIdentifierSecureTextField";
NSString * const NAFormCellIdentifierLabel = @"NAFormCellIdentifierLabel";
NSString * const NAFormCellIdentifierDate = @"NAFormCellIdentifierDate";
NSString * const NAFormCellIdentifierButton = @"NAFormCellIdentifierButton";

@implementation NAFormValue

- (id)initWithValue:(id)value label:(NSString *)label name:(NSString *)name validateRules:(NSDictionary *)validateRules options:(NSDictionary *)options cellIdentifier:(NSString *)cellIdentifier actionType:(NAFormTableSelectActionType)actionType{
    self = [self init];
    self.value = value;
    self.label = label;
    self.name = name;
    self.validatRules = validateRules;
    self.options = options;
    self.cellIdentifier = cellIdentifier;
    self.actionType = actionType;
    return self;
}

- (BOOL)validate{
    if(_targetViewDelegate){
        [_targetViewDelegate formValueWillValidate:self];
    }
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
    if(_targetViewDelegate){
        [_targetViewDelegate formValueDidValidate:self];
    }
    return [self.errors count] == 0;
}

- (NSString *)shortErrorMessage{
    NSMutableString *_temp = [@"" mutableCopy];
    for(NSString *_key in self.errors){
        NSString *message = self.errors[_key];
        if(message && [message length] > 0){
            if([_temp length] > 0)
                [_temp appendString:@", "];
            [_temp appendString:message];
        }
    }
    return _temp;
}

- (void)highlight{
    if(_targetViewDelegate)
        if([_targetViewDelegate respondsToSelector:@selector(formValue:highlighted:)])
            [_targetViewDelegate formValue:self highlighted:([self.errors count] > 0)];
}

- (void)focus:(BOOL)focusin{
    if(_targetViewDelegate)
        [_targetViewDelegate formValue:self focused:focusin];
}

- (NSString *)stringValue{
    if(self.cachedStringValue)
        return self.cachedStringValue;
    if(self.value && self.value != [NSNull null])
        return [NSString stringWithFormat:@"%@", self.value];
    return @"";
}

- (void)appendQuery:(NSMutableDictionary *)queries{
    if(_name && self.value){
        queries[_name] = self.value;
    }
}

- (NSDictionary *)query{
    return @{self.name: self.value};
}

- (void)setIsUploading:(BOOL)isUploading{
    _isUploading = isUploading;
    
    if(_targetViewDelegate)
        if([_targetViewDelegate respondsToSelector:@selector(formValue:isUploading:)])
            [_targetViewDelegate formValue:self isUploading:isUploading];
}

@end
