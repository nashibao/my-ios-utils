//
//  NATheme.m
//  SK3
//
//  Created by nashibao on 2012/09/26.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NATheme.h"

@implementation NATheme

NATheme *__current_theme__ = nil;

+ (NATheme *)currentTheme{
    if(!__current_theme__){
        __current_theme__ = [[NATheme alloc] init];
    }
    return __current_theme__;
}

- (UIColor *)cellBackgroundColor{
    return [UIColor whiteColor];
}

- (UIColor *)cellErrorHighlightBackgroundColor{
    return [UIColor colorWithRed:1.000 green:0.816 blue:0.835 alpha:1.000];
//    return [UIColor colorWithRed:1.000 green:0.973 blue:0.894 alpha:1.000];
}

- (UIColor *)labelFontColor{
    return [UIColor blackColor];
}

- (UIColor *)labelDisabledFontColor{
    return [UIColor lightGrayColor];
}

@end
