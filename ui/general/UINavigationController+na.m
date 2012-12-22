//
//  UINavigationController+nashibao.m
//  senko
//
//  Created by na shibao on 12/03/23.
//  Copyright (c) 2012年 s-cubism.inc. All rights reserved.
//

#import "UINavigationController+na.h"

@implementation UINavigationController (na)

- (void)popViewController{
    [self popViewControllerAnimated:YES];
}

- (void)pushStoryBoardWithName:(NSString *)storyBoardName animated:(BOOL)animated{
    [self pushViewController:[[UIStoryboard storyboardWithName:storyBoardName bundle:[NSBundle mainBundle]] instantiateInitialViewController] animated:animated];
}

- (void)presentStoryBoardWithName:(NSString *)storyBoardName animated:(BOOL)animated completion:(void(^)(void))completion{
    [self presentViewController:[[UIStoryboard storyboardWithName:storyBoardName bundle:[NSBundle mainBundle]] instantiateInitialViewController] animated:animated completion:completion];
}

@end
