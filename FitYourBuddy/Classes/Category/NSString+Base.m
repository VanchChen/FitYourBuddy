//
//  NSString+Base.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/3/25.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "NSString+Base.h"

@implementation NSString (Base)

#pragma mark - 字符串处理
//给字符串加下划线
- (NSAttributedString *)bottomLineString {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self];
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(0, self.length)];
    return str;
}

/**
 * 去掉字符串两端的空白字符
 *
 * @return NSString
 **/
- (NSString *) trim {
    if(nil == self){
        return nil;
    }
    
    NSMutableString *re = [NSMutableString stringWithString:self];
    CFStringTrimWhitespace((CFMutableStringRef)re);
    return (NSString *)re;
}

/**
 * 忽略大小写比较两个字符串
 *
 * @return BOOL
 **/
- (BOOL)equalsIgnoreCase:(NSString *)str {
    if (nil == str) {
        return NO;
    }
    
    return [[str lowercaseString] isEqualToString:[self lowercaseString]];
}

/** 是否包含特定字符串 */
- (BOOL)contains:(NSString *)str {
    if (nil == str || [str length] < 1) {
        return NO;
    }
    
    return [self rangeOfString:str].location != NSNotFound;
}

/** 从数字转到字符串 */
+ (NSString *)getFromInteger:(NSInteger)num {
    return [NSString stringWithFormat:@"%ld", (long)num];
}

#pragma mark - 处理时间
/** 返回标准格式的今天日期 */
+ (NSString *)today {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter stringFromDate:[NSDate date]];
}

/** 从标准的日期字符串去除年月时分秒 只要天 */
- (NSString *)formatDay {
    if (self == nil || self.length < 10) {
        return self;
    }
    
    NSString *dayString = [self substringWithRange:NSMakeRange(8, 2)];
    
    return [NSString getFromInteger:[dayString integerValue]]; //转一下去除0
}

/** 从标准的日期字符串去除时分秒 yyyy-MM-dd */
- (NSString *)formatDate {
    if (self == nil || self.length < 10) {
        return self;
    }
    return [self substringWithRange:NSMakeRange(0, 10)];
}

@end
