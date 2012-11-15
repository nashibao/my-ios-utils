//
//  NADateFormValue.m
//  SK3
//
//  Created by nashibao on 2012/11/14.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NADateFormValue.h"

@implementation NADateFormValue

- (NSString *)stringValue{
    if(self.cachedStringValue)
        return self.cachedStringValue;
    if(self.value && self.value != [NSNull null]){
        NSDate *date = (NSDate *)self.value;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY/MM/dd"];
        return [formatter stringFromDate:date];
    }
    return @"";
}

@end
