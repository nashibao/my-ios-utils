//
//  NAFormBoolCell.m
//  SK3
//
//  Created by nashibao on 2012/11/13.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NAFormBoolCell.h"

@implementation NAFormBoolCell

//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if(self){
//        self.swch = [[UISwitch alloc] init];
//        self.accessoryView = _swch;
//        [_swch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
//    }
//    return self;
//}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        self.swch = [[UISwitch alloc] init];
        self.accessoryView = _swch;
        [_swch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

- (void)switchChanged:(id)sender{
    NSNumber *modifiedData = @(self.swch.on);
    self.formValue.value = modifiedData;
    if(self.delegate){
        [self.delegate formCell:self inTableViewController:self.tableViewController modifiedData:modifiedData formValue:self.formValue indexPath:self.indexPath];
    }
    
}

- (void)setFormValue:(NAFormValue *)formValue{
    [super setFormValue:formValue];
    [self.textLabel setText:formValue.label];
    [self.swch setOn:[formValue.value boolValue]];
}

@end
