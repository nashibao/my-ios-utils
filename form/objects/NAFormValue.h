//
//  NAFormValue.h
//  SK3
//
//  Created by nashibao on 2012/09/26.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NAFormActionType.h"


extern NSString * const NAFormCellIdentifierSwitch;
extern NSString * const NAFormCellIdentifierPushSelect;
extern NSString * const NAFormCellIdentifierPush;
extern NSString * const NAFormCellIdentifierTextField;
extern NSString * const NAFormCellIdentifierTextArea;
extern NSString * const NAFormCellIdentifierSecureTextField;
extern NSString * const NAFormCellIdentifierLabel;
extern NSString * const NAFormCellIdentifierDate;
extern NSString * const NAFormCellIdentifierButton;

@protocol NAFormValuTargetViewDelegate;

@interface NAFormValue : NSObject

@property (weak, nonatomic) id<NAFormValuTargetViewDelegate> targetViewDelegate;

@property (strong, nonatomic) id value;
@property (strong, nonatomic) NSString *label;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSDictionary *validatRules;
@property (strong, nonatomic) NSDictionary *options;
//validationエラーがここに入る
@property (strong, nonatomic) NSDictionary *errors;
//エラーメッセージのカスタマイズ
@property (strong, nonatomic) NSString *errorMessage;
//ヘルプテキスト
@property (strong, nonatomic) NSString *helpText;
//表示用value
@property (strong, nonatomic) NSString *stringValue;
//表示用valueのキャッシュ
@property (strong, nonatomic) NSString *cachedStringValue;
//比較用value
@property (strong, nonatomic) id raw_value;
//indicatorを出す用途
@property (nonatomic) BOOL isUploading;

@property (readonly, nonatomic) NSDictionary *query;


//表示周りに必要なところ
@property (strong, nonatomic) NSString *cellIdentifier;
@property (nonatomic) NAFormTableSelectActionType actionType;

#pragma mark TODO: このindexPath無くしたい
//indexPathはtableView用．．微妙か．
//@property (strong, nonatomic) NSIndexPath *indexPath;

- (id)initWithValue:(id)value label:(NSString *)label name:(NSString *)name validateRules:(NSDictionary *)validateRules options:(NSDictionary *)options cellIdentifier:(NSString *)cellIdentifier actionType:(NAFormTableSelectActionType)actionType;

- (BOOL)validate;

- (NSString *)shortErrorMessage;

- (void)highlight;

- (void)focus:(BOOL)focusin;

- (void)appendQuery:(NSMutableDictionary *)queries;

@end

@protocol NAFormValuTargetViewDelegate <NSObject>

@required

//validateの前後
- (void)formValueWillValidate:(NAFormValue *)formValue;
//validateの前後
- (void)formValueDidValidate:(NAFormValue *)formValue;
//フォーカス
- (void)formValue:(NAFormValue *)formValue focused:(BOOL)focused;

//エラーによるハイライト
- (void)formValue:(NAFormValue *)formValue highlighted:(BOOL)highlighted;

//uploadingによるハイライト
- (void)formValue:(NAFormValue *)formValue isUploading:(BOOL)isUploading;

@end
