//
//  NATableViewCell.h
//  SK3
//
//  Created by nashibao on 2012/10/15.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NATableViewCell : UITableViewCell

//@property (strong, nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) UITableViewController *tableViewController;
@property (strong, nonatomic) UIColor *defaultBackgroundColor;

@property (strong, nonatomic) id data;

@end
