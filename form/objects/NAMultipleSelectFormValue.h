//
//  NAMultipleSelectValue.h
//  SK3
//
//  Created by nashibao on 2012/10/31.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NAFormValue.h"

@interface NAMultipleSelectFormValue : NAFormValue

//中身はdictionaryかobject
@property (strong, nonatomic) NSArray *selects;

@property (readonly, nonatomic) NSString *selectedLabel;
@property (strong, nonatomic) NSMutableArray *selectedIndexPaths;

@property (strong, nonatomic) NSString *label_key;
@property (strong, nonatomic) NSString *value_key;

@end
