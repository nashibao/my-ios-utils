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
    NSArray *formats = @[@"YYYY-MM-dd HH:mm:ss", @"YYYY-MM-dd'T'HH:mm:ss", @"YYYY/MM/dd HH:mm:ss", @"YYYY/MM/dd'T'HH:mm:ss"];
    return [self dateWithString:str withFormats:formats];
}

+ (NSDate *)dateWithString:(NSString *)str withFormats:(NSArray *)formats{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    NSDate *date;
    for (NSString *format in formats) {
        [formatter setDateFormat:format];
        date = [formatter dateFromString:str];
        if(date)
            break;
    }
    return date;
}

- (NSString *)string{
    NSString *format = @"YY/M/d H:mm";
    return [self stringWithFormat:format];
}

- (NSString *)stringWithFormat:(NSString *)format{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:self];
}

- (NSDate *)dateWithOnlyDay{
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit |NSTimeZoneCalendarUnit;
    NSDateComponents *comps = [cal components:unitFlags fromDate:self];
    NSDate *date = [cal dateFromComponents:comps];
    return date;
}

@end
