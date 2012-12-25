//
//  UITableView+na.h
//  SK3
//
//  Created by nashibao on 2012/11/30.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (na)

- (void)scrollToBottomWithAnimated:(BOOL)animated;

- (BOOL)hasIndexPath:(NSIndexPath *)indexPath;

@end
