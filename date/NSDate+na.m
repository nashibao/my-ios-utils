//
//  NSDate+na.m
//  SK3
//
//  Created by nashibao on 2012/11/13.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NSDate+na.h"

@implementation NSDate (na)

+ (NSDate *)dateWithString:(NSString *)str{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    NSArray *formats = @[@"YYYY-MM-dd HH:mm:ss", @"YYYY-MM-dd'T'HH:mm:ss", @"YYYY/MM/dd HH:mm:ss", @"YYYY/MM/dd'T'HH:mm:ss"];
    NSDate *date;
    for (NSString *format in formats) {
        [formatter setDateFormat:format];
        date = [formatter dateFromString:str];
        if(date)
            break;
    }
    return date;
}

- (NSDate *)dateWithOnlyDay{
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit |NSTimeZoneCalendarUnit;
    NSDateComponents *comps = [cal components:unitFlags fromDate:self];
    NSDate *date = [cal dateFromComponents:comps];
    return date;
}

@end
