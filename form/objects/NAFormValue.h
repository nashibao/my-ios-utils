//
//  NAFormValue.h
//  SK3
//
//  Created by nashibao on 2012/09/26.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NAFormValue : NSObject

//ハイライト用
@property (weak, nonatomic) UIView *targetView;
@property (strong, nonatomic) id value;
@property (strong, nonatomic) NSString *label;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSDictionary *validatRules;
@property (strong, nonatomic) NSDictionary *options;
//validationエラーがここに入る
@property (strong, nonatomic) NSDictionary *errors;
//エラーメッセージのカスタマイズ
@property (strong, nonatomic) NSString *errorMessage;
//表示用value
@property (strong, nonatomic) NSString *stringValue;
//表示用valueのキャッシュ
@property (strong, nonatomic) NSString *cachedStringValue;

#pragma mark TODO: このindexPath無くしたい
//indexPathはtableView用．．微妙か．
@property (strong, nonatomic) NSIndexPath *indexPath;

- (id)initWithValue:(id)value label:(NSString *)label name:(NSString *)name targetView:(UIView *)targetView validateRules:(NSDictionary *)validateRules options:(NSDictionary *)options;

- (BOOL)validate;

- (NSString *)shortErrorMessage;

- (void)highlight;

@end
