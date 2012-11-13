//
//  NAValidator.m
//  SK3
//
//  Created by nashibao on 2012/09/26.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NAValidator.h"

#import "NATheme.h"

#import "NAFormValue.h"

@implementation NAValidator

static NSDictionary *validate_settings = nil;

+ (void)load{
    validate_settings = @{
    @"required" : @{
        @"message": @"この項目は必須です．",
    },
    @"mail" : @{
        @"message": @"フォーマットが正しくありません．",
    },
    @"maxLength" : @{
        @"message": @"長すぎます．",
    },
    @"minLength" : @{
    @"message": @"短すぎます．",
    },
    @"number" : @{
    @"message": @"数字で入力して下さい．",
    },
    @"pattern" : @{
    @"message": @"フォーマットが違います．",
    },
    @"custom" : @{
    @"message": @"間違っています．",
    },
    @"equal" : @{
    @"message": @"等しくありません．",
    },
    };
}

+ (NSString *)errorMessage:(NSString *)type options:(id)options{
    if([options isKindOfClass:[NSDictionary class]] && options[@"message"])
        return options[@"message"];
    return validate_settings[type][@"message"];
}

+ (NSString *)validateRequired:(id)object options:(id)options{
    if([object isKindOfClass:[NSString class]]){
        if(!object || [object length] == 0){
            return [self errorMessage:@"required" options:options];
        }
        return nil;
    }else if(!object){
        return [self errorMessage:@"required" options:options];
    }
    return nil;
}

+ (NSString *)validateMaxLength:(id)object options:(id)options{
    if([object isKindOfClass:[NSString class]]){
        if(!object)
            return nil;
        if([object length] > [options intValue]){
            return [self errorMessage:@"maxLength" options:options];
        }
        return nil;
    }
    return nil;
}

+ (NSString *)validateMinLength:(id)object options:(id)options{
    if([object isKindOfClass:[NSString class]]){
        if(!object)
            return nil;
        if([object length] < [options intValue]){
            return [self errorMessage:@"minLength" options:options];
        }
        return nil;
    }
    return nil;
}

+ (NSString *)validateNumber:(id)object options:(id)options{
    if(!object){
        return nil;
    }else{
        return [self _validatePattern:@"number" pattern:@"[1-9][0-9]*" object:object options:options];
    }
    return nil;
}

+ (NSString *)validateEqual:(id)object options:(id)options{
    id val = options[@"value"];
    if([object isKindOfClass:[NSString class]]){
        if(![object isEqualToString:val])
            return [self errorMessage:@"equal" options:options];
    }else if([object isKindOfClass:[NSNumber class]]){
        if(![object isEqualToNumber:val])
            return [self errorMessage:@"equal" options:options];
    }
    return nil;
}

//パターン型のvalidationの場合
+ (NSString *)_validatePattern:(NSString *)type pattern:(NSString *)pattern object:(id)object options:(id)options{
    if([object isKindOfClass:[NSString class]]){
        if(!object || [object length] == 0){
            return [self errorMessage:type options:options];
        }
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionAllowCommentsAndWhitespace error:nil];
        NSUInteger matches = [regex numberOfMatchesInString:object options:NSMatchingCompleted range:NSMakeRange(0, [object length])];
        if(matches == 0){
            return [self errorMessage:type options:options];
        }
        return nil;
    }
    return nil;
}

+ (NSString *)validatePattern:(id)object options:(id)options{
    return [self _validatePattern:@"pattern" pattern:options[@"params"] object:object options:options];
}

+ (NSString *)validateMail:(id)object options:(id)options{
    return [self _validatePattern:@"mail" pattern:@"^[^@]+@[^.@]+.[^.@]+$" object:object options:options];
}

// blockで指定する場合
+ (NSString *)validateCustom:(id)object options:(id)options{
    BOOL (^block)(id value) = options[@"block"];
    if(!block(object)){
        return [self errorMessage:@"custom" options:options];
    }
    return nil;
}

+ (NSString *)validates:(NSArray *)formValues{
    for(NAFormValue *formValue in formValues){
        [formValue validate];
    }
    [self highlightErrorOnViews:formValues];
    return [self makeShortMessage:formValues];
}

+ (NSString *)makeShortMessage:(NSArray *)formValues{
    NSMutableString *_temp = [@"" mutableCopy];
    for(NAFormValue *formValue in formValues){
        if([formValue errors] > 0){
            NSString *val = [formValue shortErrorMessage];
            if(val && [val length] > 0){
                [_temp appendFormat:@"%@:", formValue.label];
                [_temp appendString:val];
            }
        }
    }
    return _temp;
}

+ (void)highlightErrorOnViews:(NSArray *)formValues{
    for(NAFormValue *formValue in formValues){
        [formValue highlight];
    }
}

@end
