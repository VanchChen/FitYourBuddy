//
//  NSDate+Base.h
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/4/3.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

@interface NSDate (Base)

/** 获取当天的包括“年”，“月”，“日”，“周”，“时”，“分”，“秒”的NSDateComponents */
- (NSDateComponents *)componentsOfDay;

#pragma mark - 系统自带的基本属性
/** 纪元 */
- (NSInteger)era;
/** 年 */
- (NSInteger)year;
/** 季度 */
- (NSInteger)quarter;
/** 月 */
- (NSInteger)month;
/** 星期几,1是周日 7是周六 */
- (NSInteger)weekday;
/** 当月第几个周几,比如第一个周一 */
- (NSInteger)weekdayOrdinal;
/** 一个月中的第几周 */
- (NSInteger)weekOfMonth;
/** 一年中的第几周 */
- (NSInteger)weekOfYear;
/** 日 */
- (NSInteger)day;
/** 时 */
- (NSInteger)hour;
/** 分 */
- (NSInteger)minute;
/** 秒 */
- (NSInteger)second;
/** 是不是闰月 */
- (BOOL)isLeapMonth;

#pragma mark - 处理时间
/** 当天的起始时间（00:00:00）*/
- (NSDate *)beginingOfDay;
/** 当天的结束时间（23:59:59）*/
- (NSDate *)endOfDay;
/** 前一天 */
- (NSDate *)previousDay;
/** 前几天 */
- (NSDate *)previousDayWithNum:(NSInteger)num;
/** 后一天 */
- (NSDate *)followingDay;
/** 后几天 */
- (NSDate *)followingDayWithNum:(NSInteger)num;

#pragma mark - 月相关
/** 当月共有几天 */
- (NSInteger)numberOfDaysInMonth;
/** 当月共有几周 */
- (NSInteger)numberOfWeeksInMonth;
/** 当月第一天 */
- (NSDate *)firstDayOfTheMonth;
/** 当月最后一天 */
- (NSDate *)lastDayOfTheMonth;

#pragma mark - 周相关
/** 当周共有几天 */
- (NSInteger)numberOfDaysInWeek;
/** 当周第一天 */
- (NSDate *)firstDayOfTheWeek;
/** 当周最后一天 */
- (NSDate *)lastDayOfTheWeek;
/** 当天的前一周时间 */
- (NSDate *)associateDayOfThePreviousWeek;
/** 当天的后一周时间 */
- (NSDate *)associateDayOfTheFollowingWeek;

#pragma mark - 时间比较
/** 比较是否同一天，不管时分秒 */
- (BOOL)sameDayWithDate:(NSDate *)otherDate;

@end
