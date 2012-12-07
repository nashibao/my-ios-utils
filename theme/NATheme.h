//
//  NATheme.h
//  SK3
//
//  Created by nashibao on 2012/09/26.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import <Foundation/Foundation.h>


/** theme用無形カテゴリによるプロトコル　もしくはシングルトン
 blockによるアニメーションなども汎用的なものはここに外だししていく
 */
@interface NATheme : NSObject

+ (NATheme *)currentTheme;

- (UIColor *)cellBackgroundColor;

- (UIColor *)cellErrorHighlightBackgroundColor;

- (UIColor *)labelFontColor;

- (UIColor *)labelDisabledFontColor;

@end
