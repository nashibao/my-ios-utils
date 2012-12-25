//
//  UIView+nashi.h
//  senko
//
//  Created by na shibao on 12/03/19.
//  Copyright (c) 2012年 s-cubism.inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (na)

@property(nonatomic) CGFloat left;
@property(nonatomic) CGFloat right;
@property(nonatomic) CGFloat top;
@property(nonatomic) CGFloat bottom;
@property(nonatomic) CGFloat width;
@property(nonatomic) CGFloat height;

+ (id)allocinitframeautorelease:(CGRect)frame;

- (void)setLeft:(CGFloat)left duration:(float)duration completion:(void(^)(BOOL finished))completion;
- (void)setRight:(CGFloat)right duration:(float)duration completion:(void(^)(BOOL finished))completion;
- (void)setTop:(CGFloat)top duration:(float)duration completion:(void(^)(BOOL finished))completion;
- (void)setBottom:(CGFloat)bottom duration:(float)duration completion:(void(^)(BOOL finished))completion;
- (void)setHeight:(CGFloat)height duration:(float)duration completion:(void(^)(BOOL finished))completion;
- (void)setWidth:(CGFloat)width duration:(float)duration completion:(void(^)(BOOL finished))completion;

- (void)setLeft:(CGFloat)left completion:(void(^)(BOOL finished))completion;
- (void)setRight:(CGFloat)right completion:(void(^)(BOOL finished))completion;
- (void)setTop:(CGFloat)top completion:(void(^)(BOOL finished))completion;
- (void)setBottom:(CGFloat)bottom completion:(void(^)(BOOL finished))completion;
- (void)setHeight:(CGFloat)height completion:(void(^)(BOOL finished))completion;
- (void)setWidth:(CGFloat)width completion:(void(^)(BOOL finished))completion;

- (void)setLeft:(CGFloat)left animated:(BOOL)animated;
- (void)setRight:(CGFloat)right animated:(BOOL)animated;
- (void)setTop:(CGFloat)top animated:(BOOL)animated;
- (void)setBottom:(CGFloat)bottom animated:(BOOL)animated;
- (void)setHeight:(CGFloat)height animated:(BOOL)animated;
- (void)setWidth:(CGFloat)width animated:(BOOL)animated;

@end
