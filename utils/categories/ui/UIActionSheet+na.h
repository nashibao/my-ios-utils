//
//  UIActionSheet+na.h
//  SK3
//
//  Created by nashibao on 2012/12/23.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIActionSheet (na)

- (void)showInKeyWindow;

+ (UIActionSheet *)showWithTitle:(NSString *)title
                      cancelTitle:(NSString *)cancelTitle
                          doTitle:(NSString *)doTitle
                    cancelHandler:(void(^)())cancelHandler
                        doHandler:(void(^)())doHandler;

+ (UIActionSheet *)showWithTitle:(NSString *)title
                      cancelTitle:(NSString *)cancelTitle
                    cancelHandler:(void(^)())cancelHandler;


@end
