//
//  AccountCoreDataHelper.h
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/3/8.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountCoreDataHelper : NSObject

//初始化账号数据库，添加字段
+ (BOOL)initAccountWithName:(NSString *)name andGender:(NSString *)gender andError:(NSError **)error;

//根据字段取某一条数据
+ (NSString *)getDataByName:(NSString *)name withError:(NSError **)error;

//根据字段保存某一条数据
+ (BOOL)setDataByName:(NSString *)name andData:(NSString *)data withError:(NSError **)error;

//返回首页信息
+ (NSDictionary *)getAccountDictionaryWithError:(NSError **)error;

@end
