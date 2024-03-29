//
//  ExerciseCoreDataHelper.h
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/3/8.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

//健身类型
typedef NS_ENUM(NSInteger, ExerciseType) {
    ExerciseTypeSitUp,
    ExerciseTypePushUp,
    ExerciseTypeSquat,
    ExerciseTypeWalk
};

@interface ExerciseCoreDataHelper : NSObject

/**根据类型得到锻炼天数（已废，现用数据库记录）*/
+ (NSInteger)getHistoryDayByType:(ExerciseType)type withError:(NSError **)error;

/**根据类型得到当天锻炼总次数*/
+ (NSInteger)getTodayNumByType:(ExerciseType)type withError:(NSError **)error;

/**根据类型得到某一天的锻炼次数*/
+ (NSInteger)getNumByType:(ExerciseType)type andDate:(NSString *)date withError:(NSError **)error;

/**根据类型得到最好成绩*/
+ (NSInteger)getBestNumByType:(ExerciseType)type withError:(NSError **)error;

/**根据类型得到总记录*/
+ (NSInteger)getTotalNumByType:(ExerciseType)type withError:(NSError **)error;

/**根据类型得到一周的数据*/
+ (NSDictionary *)getOneWeekNumByType:(ExerciseType)type withError:(NSError **)error;

/**得到某一个月的锻炼情况*/
+ (NSArray *)getMonthExerciseDayByDate:(NSDate *)date withError:(NSError **)error;

/**得到某一个日期后的所有锻炼数据*/
+ (NSArray *)getExerciseByDate:(NSString *)date withError:(NSError **)error;

/**根据类型存数据*/
+ (BOOL)addExerciseByType:(ExerciseType)type andNum:(NSInteger)num withError:(NSError **)error;

@end
