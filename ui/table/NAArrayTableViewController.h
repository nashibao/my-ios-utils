//
//  NAArrayTableViewController.h
//  SK3
//
//  Created by nashibao on 2012/10/12.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NATableViewController.h"

@interface NAArrayTableViewController : NATableViewController

@property (strong, nonatomic) NSArray *sections;

- (NSArray *)sectionRows:(id)section;
- (id)rowData:(id)row;
- (id)rowAction:(id)row;
#warning 名前付けがおかしすぎる didSelectEndとか、willSelectStartに変更する
- (id)rowActionBackBlock:(id)row;
- (id)rowAtIndexPath:(NSIndexPath *)indexPath;

- (void)initializeCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath reuseIdentifier:(NSString *)reuseIdentifier row:(id)row;
- (void)updateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath row:(id)row;

- (void)willActionBacked:(UITableViewController *)controller;

@end
