//
//  NSDate+na.h
//  SK3
//
//  Created by nashibao on 2012/11/13.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (na)

+ (NSDate *)dateWithString:(NSString *)str;

+ (NSDate *)dateWithString:(NSString *)str withFormats:(NSArray *)formats;

- (NSString *)string;

- (NSString *)stringWithFormat:(NSString *)format;

- (NSDate *)dateWithOnlyDay;

@end
