//
//  HttpHelper.h
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/8/13.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (httphelper)

/** 获取url 请求 */
- (NSString *)httpGetMethodDomain;

/** 获取url的参数键值对 */
- (NSDictionary *)httpGetMethodParams;

/** 对字符串URLencode编码 */
- (NSString *)urlEncoding;

/** 对字符串URLdecode解码 */
- (NSString *)urlDecoding;

@end

@interface HttpHelper : NSObject

/** 在状态栏上显示网络连接状态的转子 */
+ (void)showNetworkIndicator;

/** 在状态栏上隐藏网络连接状态的转子 */
+ (void)hiddenNetworkIndicator;

/** HTTP 请求头报错时的错误信息 */
+ (NSString *)httpStatusErrorStr:(NSInteger)statusCode;

/** 从一个 NSError 对象中解析错误信息 */
+ (NSString *)descriptionFromError:(NSError *)error;

@end
