//
//  NSString+Base.h
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/3/25.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

@interface NSString (Base)

#pragma mark - 字符串处理
/** 给字符串加下划线 */
- (NSAttributedString *)bottomLineString;

/** 去掉字符串两端的空白字符 */
- (NSString *)trim;

/** 忽略大小写比较两个字符串 */
- (BOOL)equalsIgnoreCase:(NSString *)str;

/** 是否包含特定字符串 */
- (BOOL)contains:(NSString *)str;

/** 从数字转到字符串 */
+ (NSString *)stringFromInteger:(NSInteger)num;

#pragma mark - 处理时间
/** 返回标准格式的今天日期 */
+ (NSString *)today;

/** 根据标准日期字符串返回日期 */
- (NSDate *)dateFromString;

/** 从标准的日期字符串去除年月时分秒 只要天 */
- (NSString *)formatDay;

/** 从标准的日期字符串去除时分秒 yyyy-MM-dd */
- (NSString *)formatDate;

#pragma mark - 判断是否是数字
/** 字符串是否是整形 */
- (BOOL)isPureInt;

/** 字符串是否是浮点型 */
- (BOOL)isPureFloat;

@end
