//
//  Tile.h
//  musicmap
//
//  Created by shibao na on 11/09/05.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Tile : UIView

@property(nonatomic)NSInteger row;
@property(nonatomic)NSInteger column;
@property(nonatomic)CGRect correctFrame;

@property(nonatomic, strong)UILabel *textLabel;

@end
