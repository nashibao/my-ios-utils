//
//  NAMultipleFormValue.m
//  SK3
//
//  Created by nashibao on 2012/09/27.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NAMultipleFormValue.h"

#import "NAValidator.h"

@implementation NAMultipleFormValue

- (BOOL)validate{
    NSMutableDictionary *_temp = [@{} mutableCopy];
    for(NAFormValue *formValue in self.formValues){
        [formValue validate];
        [_temp addEntriesFromDictionary:formValue.errors];
    }
    self.errors = _temp;
    return [self.errors count] > 0;
}

- (NSString *)stringValue{
    if(self.cachedStringValue)
        return self.cachedStringValue;
    NSMutableString *temp = [@"" mutableCopy];
    for(NAFormValue *formValue in self.formValues){
        NSString *stringValue = [formValue stringValue];
        if([temp length] > 0 && stringValue > 0)
            [temp appendString:@"/"];
        [temp appendFormat:@"%@", stringValue];
    }
    return temp;
}

- (void)appendQuery:(NSMutableDictionary *)queries{
    for(NAFormValue *formValue in self.formValues){
        [formValue appendQuery:queries];
    }
}

@end
