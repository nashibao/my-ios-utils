//
//  NATableViewController.h
//  SK3
//
//  Created by nashibao on 2012/10/01.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NAViewControllerProtocol.h"

@interface NATableViewController : UITableViewController<NAViewControllerProtocol>

/*
 default: NO
 storyboardなどで作った静的テーブルの場合はここをYESに．
 */
@property (nonatomic) BOOL isStaticTable;

@property (nonatomic) UITableViewCellStyle cellStyle;

@property (strong, nonatomic) Class cellClass;

@property (strong, nonatomic) NSString *cellIdentifier;

@property (strong, nonatomic) NSIndexPath *selectedIndexPath;

@property (nonatomic) BOOL enableRefleshControl;

@property (nonatomic) UITableViewCellAccessoryType cellAccessoryType;

- (void)initializeCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath reuseIdentifier:(NSString *)reuseIdentifier;
- (void)updateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;


- (void)preLoadHandler;
- (void)postLoadHandlerWithError:(NSError *)err;
- (void)load;
- (void)refreshed:(UIRefreshControl *)control;

@end
