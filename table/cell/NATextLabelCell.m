//
//  NATextLabelCell.m
//  SK3
//
//  Created by nashibao on 2012/10/15.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NATextLabelCell.h"

@implementation NATextLabelCell

- (NSString *)textFieldKey{
    return @"text";
}

- (NSString *)detailTextFieldKey{
    return @"detailText";
}

- (void)setData:(id)data{
    if([data isKindOfClass:[NSString class]]){
        [self.textLabel setText:data];
        [self.detailTextLabel setText:@""];
    }else if([data isKindOfClass:[NSDictionary class]]){
        [self.textLabel setText:data[[self textFieldKey]]];
        [self.detailTextLabel setText:data[[self detailTextFieldKey]]];
    }else{
        [self.textLabel setText:@""];
        [self.detailTextLabel setText:@""];
    }
}

@end
