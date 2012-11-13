//
//  NAValidator.h
//  SK3
//
//  Created by nashibao on 2012/09/26.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NAValidator : NSObject

//必須
+ (NSString *)validateRequired:(id)object options:(id)options;
//maxLength, minLength
+ (NSString *)validateMaxLength:(id)object options:(id)options;
+ (NSString *)validateMinLength:(id)object options:(id)options;
+ (NSString *)validateNumber:(id)object options:(id)options;
+ (NSString *)validateEqual:(id)object options:(id)options;
//pattern
+ (NSString *)validatePattern:(id)object options:(id)options;
//メールパターン
+ (NSString *)validateMail:(id)object options:(id)options;
// blockで指定する場合
+ (NSString *)validateCustom:(id)object options:(id)options;

+ (NSString *)validates:(NSArray *)formValues;

@end
