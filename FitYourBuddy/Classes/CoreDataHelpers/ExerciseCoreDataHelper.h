//
//  ExerciseCoreDataHelper.h
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/3/8.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import <Foundation/Foundation.h>

//帖子类型
typedef NS_ENUM(NSInteger, ExerciseType) {
    ExerciseTypeSitUp,
    ExerciseTypePushUp,
    ExerciseTypeSquat,
    ExerciseTypeWalk
};

@interface ExerciseCoreDataHelper : NSObject

//根据类型得到当天锻炼总次数
+ (NSInteger)getTodayNumByType:(ExerciseType)type withError:(NSError **)error;

//根据类型得到锻炼总次数
+ (NSInteger)getNumByType:(ExerciseType)type andDate:(NSString *)date withError:(NSError **)error;

//根据类型得到最好成绩
+ (NSInteger)getBestNumByType:(ExerciseType)type withError:(NSError **)error;

//根据类型存数据
+ (BOOL)addExerciseByType:(ExerciseType)type andNum:(NSInteger)num withError:(NSError **)error;

@end
