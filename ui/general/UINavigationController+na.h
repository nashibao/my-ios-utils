//
//  UINavigationController+nashibao.h
//  senko
//
//  Created by na shibao on 12/03/23.
//  Copyright (c) 2012年 s-cubism.inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (na)

- (void)popViewController;

- (void)pushStoryBoardWithName:(NSString *)storyBoardName animated:(BOOL)animated;

- (void)presentStoryBoardWithName:(NSString *)storyBoardName animated:(BOOL)animated completion:(void(^)(void))completion;

@end
