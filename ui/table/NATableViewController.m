//
//  NATableViewController.m
//  SK3
//
//  Created by nashibao on 2012/10/01.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NATableViewController.h"

#import "NATableViewCell.h"

@interface NATableViewController ()

@end

@implementation NATableViewController


//initialization -------------------------
- (void)initialize{
    self.isStaticTable = NO;
    self.cellClass = [UITableViewCell class];
    self.cellIdentifier = @"Cell";
    self.cellAccessoryType = UITableViewCellAccessoryNone;
    /*
     implementation
     */
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self initialize];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        [self initialize];
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style{
    self = [super initWithStyle:style];
    if(self){
        [self initialize];
    }
    return self;
}


//update cells ---------------------------------

- (void)initializeCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath reuseIdentifier:(NSString *)reuseIdentifier{
    /*
     implementation
     */
}

- (void)updateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    /*
     implementation
     */
    if([cell isKindOfClass:[NATableViewCell class]]){
        NATableViewCell *ncell = (NATableViewCell *)cell;
//        ncell.indexPath = indexPath;
        ncell.tableViewController = self;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *oldIndexPath = self.selectedIndexPath;
    NSArray *temp = nil;
    if(oldIndexPath && (oldIndexPath.section != indexPath.section || oldIndexPath.row != indexPath.row)){
        temp = @[oldIndexPath, indexPath];
    }else{
        temp = @[indexPath];
    }
    self.selectedIndexPath = indexPath;
    if(!self.isStaticTable){
        [tableView reloadRowsAtIndexPaths:temp withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark TODO: 汎用化したい, 基本的にはbackボタンで戻ってきたときの処理．
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(self.selectedIndexPath){
        [self.tableView deselectRowAtIndexPath:self.selectedIndexPath animated:animated];
        [self.tableView reloadRowsAtIndexPaths:@[self.selectedIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - Table view delegate


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    
    if(self.isStaticTable){
        cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
        [cell setAccessoryType:self.cellAccessoryType];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
        if(!cell){
            cell = [[self.cellClass alloc] initWithStyle:self.cellStyle reuseIdentifier:self.cellIdentifier];
            [cell setAccessoryType:self.cellAccessoryType];
            [self initializeCell:cell atIndexPath:indexPath reuseIdentifier:self.cellIdentifier];
        }
    }
    
    [self updateCell:cell atIndexPath:indexPath];
    
    return cell;
}

@end
