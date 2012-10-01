//
//  NASelectFormValue.h
//  SK3
//
//  Created by nashibao on 2012/09/27.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NAFormValue.h"

@interface NASelectFormValue : NAFormValue

//中身はdictionaryかobject
@property (strong, nonatomic) NSArray *selects;

@property (readonly, nonatomic) NSString *selectedLabel;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;

@property (strong, nonatomic) NSString *label_key;
@property (strong, nonatomic) NSString *value_key;

@end
