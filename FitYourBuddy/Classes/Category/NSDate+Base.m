//
//  NSDate+Base.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/4/3.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "NSDate+Base.h"

@implementation NSDate (Base)

- (NSDateComponents *)componentsOfDay
{
    static NSDateComponents *dateComponents = nil;
    static NSDate *previousDate = nil;
    
    if (!previousDate || ![previousDate isEqualToDate:self]) {
        previousDate = self;
        dateComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit | NSWeekCalendarUnit| NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:self];
    }
    
    return dateComponents;
}

#pragma mark - 基本属性
/** 纪元 */
- (NSInteger)era {
    return self.componentsOfDay.era;
}
/** 年 */
- (NSInteger)year {
    return self.componentsOfDay.year;
}
/** 季度 */
- (NSInteger)quarter {
    return self.componentsOfDay.quarter;
}
/** 月 */
- (NSInteger)month {
    return self.componentsOfDay.month;
}
/** 星期几,1是周日 7是周六 */
- (NSInteger)weekday {
    return self.componentsOfDay.weekday;
}
/** 当月第几个周几,比如第一个周一 */
- (NSInteger)weekdayOrdinal {
    return self.componentsOfDay.weekdayOrdinal;
}
/** 一个月中的第几周 */
- (NSInteger)weekOfMonth {
    return self.componentsOfDay.weekOfMonth;
}
/** 一年中的第几周 */
- (NSInteger)weekOfYear {
    return self.componentsOfDay.weekOfYear;
}
/** 日 */
- (NSInteger)day {
    return self.componentsOfDay.day;
}
/** 时 */
- (NSInteger)hour {
    return self.componentsOfDay.hour;
}
/** 分 */
- (NSInteger)minute {
    return self.componentsOfDay.minute;
}
/** 秒 */
- (NSInteger)second {
    return self.componentsOfDay.second;
}
/** 是不是闰月 */
- (BOOL)isLeapMonth {
    return self.componentsOfDay.leapMonth;
}

#pragma mark - 处理时间
/** 当天的起始时间（00:00:00）*/
- (NSDate *)beginingOfDay {
    [[self componentsOfDay] setHour:0];
    [[self componentsOfDay] setMinute:0];
    [[self componentsOfDay] setSecond:0];
    
    return [[NSCalendar currentCalendar] dateFromComponents:[self componentsOfDay]];
}
/** 当天的结束时间（23:59:59）*/
- (NSDate *)endOfDay {
    [[self componentsOfDay] setHour:23];
    [[self componentsOfDay] setMinute:59];
    [[self componentsOfDay] setSecond:59];
    
    return [[NSCalendar currentCalendar] dateFromComponents:[self componentsOfDay]];
}
/** 前一天 */
- (NSDate *)previousDay {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = -1;
    return [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:self options:0];
}
/** 前几天 */
- (NSDate *)previousDayWithNum:(NSInteger)num {
    if (num > 0) {
        NSDateComponents *components = [[NSDateComponents alloc] init];
        components.day = -num;
        return [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:self options:0];
    } else {
        return self;
    }
}
/** 后一天 */
- (NSDate *)followingDay {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = 1;
    return [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:self options:0];
}
/** 后几天 */
- (NSDate *)followingDayWithNum:(NSInteger)num {
    if (num > 0) {
        NSDateComponents *components = [[NSDateComponents alloc] init];
        components.day = num;
        return [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:self options:0];
    } else {
        return self;
    }
}

#pragma mark - 月相关
/** 当月共有几天 */
- (NSInteger)numberOfDaysInMonth {
    return [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self].length;
}
/** 当月共有几周 */
- (NSInteger)numberOfWeeksInMonth {
    return [[NSCalendar currentCalendar] rangeOfUnit:NSWeekCalendarUnit inUnit:NSMonthCalendarUnit forDate:self].length;
}
/** 当月第一天 */
- (NSDate *)firstDayOfTheMonth {
    [[self componentsOfDay] setDay:1];
    return [[NSCalendar currentCalendar] dateFromComponents:[self componentsOfDay]];
}
/** 当月最后一天 */
- (NSDate *)lastDayOfTheMonth {
    [[self componentsOfDay] setDay:[self numberOfDaysInMonth]];
    return [[NSCalendar currentCalendar] dateFromComponents:[self componentsOfDay]];
}

#pragma mark - 周相关
/** 当周共有几天 */
- (NSInteger)numberOfDaysInWeek {
    return [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit inUnit:NSWeekCalendarUnit forDate:self].length;
}
/** 当周第一天 */
- (NSDate *)firstDayOfTheWeek {
    NSDate *firstDay = nil;
    if ([[NSCalendar currentCalendar] rangeOfUnit:NSWeekCalendarUnit startDate:&firstDay interval:NULL forDate:self]) {
        return firstDay;
    }
    
    return firstDay;
}
/** 当周最后一天 */
- (NSDate *)lastDayOfTheWeek {
    //也是逻辑复杂
    return self.associateDayOfTheFollowingWeek.firstDayOfTheWeek.previousDay;
}

/** 当天的前一周时间 */
- (NSDate *)associateDayOfThePreviousWeek {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = -7;
    
    return [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:self options:0];
}
/** 当天的后一周时间 */
- (NSDate *)associateDayOfTheFollowingWeek {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = 7;
    
    return [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:self options:0];
}

#pragma mark - 时间比较
/** 比较是否同一天，不管时分秒 */
- (BOOL)sameDayWithDate:(NSDate *)otherDate {
    if (self.year == otherDate.year && self.month == otherDate.month && self.day == otherDate.day) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - 转型成字符串
/** 转成标准日期字符串 yyyy-MM-dd HH:mm:ss */
- (NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter stringFromDate:self];
}
/** 转成日期天字符串 yyyy-MM-dd */
- (NSString *)dayString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter stringFromDate:self];
}

@end
