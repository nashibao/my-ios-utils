//
//  NATableViewController.h
//  SK3
//
//  Created by nashibao on 2012/10/01.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NAViewController.h"

@interface NATableViewController : UITableViewController<NAViewController>

/*
 default: NO
 storyboardなどで作った静的テーブルの場合はここをYESに．
 */
@property (nonatomic) BOOL isStaticTable;

@property (nonatomic) UITableViewCellStyle cellStyle;

@property (strong, nonatomic) NSIndexPath *selectedIndexPath;

- (void)updateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end
