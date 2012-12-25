//
//  UIView+nashi.m
//  senko
//
//  Created by na shibao on 12/03/19.
//  Copyright (c) 2012年 s-cubism.inc. All rights reserved.
//

#import "UIView+na.h"

@implementation UIView (na)

+ (id)allocinitframeautorelease:(CGRect)frame{
    return [[self alloc] initWithFrame:frame];
}

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}



- (void)setLeft:(CGFloat)left duration:(float)duration completion:(void(^)(BOOL finished))completion{
    [UIView animateWithDuration:duration animations:^(void){
        [self setLeft:left];
    }completion:completion];
}

- (void)setRight:(CGFloat)right duration:(float)duration completion:(void(^)(BOOL finished))completion{
    [UIView animateWithDuration:duration animations:^(void){
        [self setRight:right];
    }completion:completion];
    
}

- (void)setTop:(CGFloat)top duration:(float)duration completion:(void(^)(BOOL finished))completion{
    [UIView animateWithDuration:duration animations:^(void){
        [self setTop:top];
    }completion:completion];
    
}

- (void)setBottom:(CGFloat)bottom duration:(float)duration completion:(void(^)(BOOL finished))completion{
    [UIView animateWithDuration:duration animations:^(void){
        [self setBottom:bottom];
    }completion:completion];
    
}

- (void)setHeight:(CGFloat)height duration:(float)duration completion:(void(^)(BOOL finished))completion{
    [UIView animateWithDuration:duration animations:^(void){
        [self setHeight:height];
    }completion:completion];
}
- (void)setWidth:(CGFloat)width duration:(float)duration completion:(void(^)(BOOL finished))completion{
    [UIView animateWithDuration:duration animations:^(void){
        [self setWidth:width];
    }completion:completion];
}

- (void)setLeft:(CGFloat)left completion:(void(^)(BOOL finished))completion{
    [self setLeft:left duration:0.3f completion:completion];
}

- (void)setRight:(CGFloat)right completion:(void(^)(BOOL finished))completion{
    [self setRight:right duration:0.3f completion:completion];
}

- (void)setTop:(CGFloat)top completion:(void(^)(BOOL finished))completion{
    [self setTop:top duration:0.3f completion:completion];
}

- (void)setBottom:(CGFloat)bottom completion:(void(^)(BOOL finished))completion{
    [self setBottom:bottom duration:0.3f completion:completion];
}

- (void)setHeight:(CGFloat)height completion:(void(^)(BOOL finished))completion{
    [self setHeight:height duration:0.3f completion:completion];
}
- (void)setWidth:(CGFloat)width completion:(void(^)(BOOL finished))completion{
    [self setWidth:width duration:0.3f completion:completion];
}

- (void)setLeft:(CGFloat)left animated:(BOOL)animated{
    [self setLeft:left completion:^(BOOL finished){}];
}

- (void)setRight:(CGFloat)right animated:(BOOL)animated{
    [self setRight:right completion:^(BOOL finished){}];
}

- (void)setTop:(CGFloat)top animated:(BOOL)animated{
    [self setTop:top completion:^(BOOL finished){}];
}

- (void)setBottom:(CGFloat)bottom animated:(BOOL)animated{
    [self setBottom:bottom completion:^(BOOL finished){}];
}

- (void)setHeight:(CGFloat)height animated:(BOOL)animated{
    [self setHeight:height completion:^(BOOL finished){}];
}
- (void)setWidth:(CGFloat)width animated:(BOOL)animated{
    [self setWidth:width completion:^(BOOL finished){}];
}

@end
