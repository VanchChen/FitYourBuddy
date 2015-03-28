//
//  NSString+Base.h
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/3/25.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

@interface NSString (Base)

/** 给字符串加下划线 */
- (NSAttributedString *)bottomLineString;

/** 去掉字符串两端的空白字符 */
- (NSString *)trim;

/** 忽略大小写比较两个字符串 */
- (BOOL)equalsIgnoreCase:(NSString *)str;

/** 是否包含特定字符串 */
- (BOOL)contains:(NSString *)str;

/** 从数字转到字符串 */
+ (NSString *)getFromInteger:(NSInteger)num;

@end
