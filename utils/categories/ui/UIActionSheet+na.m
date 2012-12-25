//
//  UIActionSheet+na.m
//  SK3
//
//  Created by nashibao on 2012/12/23.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "UIActionSheet+na.h"

@implementation UIActionSheet (na)

- (void)showInKeyWindow{
    [self showInView:[[UIApplication sharedApplication] keyWindow]];
}


+ (UIActionSheet *)showWithTitle:(NSString *)title
                      cancelTitle:(NSString *)cancelTitle
                          doTitle:(NSString *)doTitle
                    cancelHandler:(void(^)())cancelHandler
                       doHandler:(void(^)())doHandler{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:title];
    if(doTitle)
        [sheet addButtonWithTitle:doTitle handler:doHandler];
    if(cancelTitle)
        [sheet setCancelButtonWithTitle:cancelTitle handler:cancelHandler];
    [sheet showInKeyWindow];
    return sheet;
}

+ (UIActionSheet *)showWithTitle:(NSString *)title
                      cancelTitle:(NSString *)cancelTitle
                   cancelHandler:(void(^)())cancelHandler{
    return [self showWithTitle:title cancelTitle:cancelTitle doTitle:nil cancelHandler:cancelHandler doHandler:nil];
}


@end
