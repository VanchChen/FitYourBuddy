//
//  TimerManager.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/4/7.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "TimerManager.h"

static NSInteger const ExerciseLevelLimit = 31;     //锻炼等级上限

@interface TimerManager()

@property(nonatomic, strong) NSTimer *timer;        //计时器
@property(nonatomic, strong) NSDate *lastDate;      //上一次日期

@end

@implementation TimerManager

SINGLETON_IMPLEMENT(TimerManager)

//开始计时
- (void)startTickTock {
    NSError *error;//获取上次登陆日期
    NSString *lastDateString = [AccountCoreDataHelper getDataByName:@"lastLaunchDate" withError:&error];
    if (lastDateString && lastDateString.length > 0) {
        _lastDate = [lastDateString dateFromString];
    } else {
        _lastDate = [NSDate date];
    }
    //保存本次登陆日期
    [AccountCoreDataHelper setDataByName:@"lastLaunchDate" andData:[NSString today] withError:&error];
    //开启计时器，10秒一次更新
    _timer = [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(handleTimeChanged) userInfo:nil repeats:YES];
    //先触发一次
    [self handleTimeChanged];
}

//触发了计时器事件
- (void)handleTimeChanged {
    NSDate* tmpDate = [NSDate date];
    if (![tmpDate sameDayWithDate:_lastDate]) {//跨天了
        //锻炼等级更新
        [self checkUpdateByType:ExerciseTypePushUp];
        [self checkUpdateByType:ExerciseTypeSitUp];
        [self checkUpdateByType:ExerciseTypeSquat];
        [self checkUpdateByType:ExerciseTypeWalk];
    
        //最后更新上次登陆日期
        _lastDate = tmpDate;
    }
}

//TODO:先还是按照等级上限为31来做
//检查锻炼等级更新
- (void)checkUpdateByType:(ExerciseType)type {
    NSError *error;
    NSString *lastDateString = [_lastDate dayString];
    
    NSInteger lastDateNum = [ExerciseCoreDataHelper getNumByType:type andDate:lastDateString withError:&error];
    NSInteger targetNum, level;
    switch (type) {
        case ExerciseTypePushUp:
            level = [[AccountCoreDataHelper getDataByName:@"pushUpLevel" withError:&error] integerValue];
            if (level < ExerciseLevelLimit) {
                targetNum = [CommonUtil getTargetNumFromType:type andLevel:level];
                if (lastDateNum > targetNum) {//升级
                    level ++;
                    [AccountCoreDataHelper setDataByName:@"pushUpLevel" andData:[NSString stringFromInteger:level] withError:&error];
                }
            }
            break;
        case ExerciseTypeSitUp:
            level = [[AccountCoreDataHelper getDataByName:@"sitUpLevel" withError:&error] integerValue];
            if (level < ExerciseLevelLimit) {
                targetNum = [CommonUtil getTargetNumFromType:type andLevel:level];
                if (lastDateNum > targetNum) {//升级
                    level ++;
                    [AccountCoreDataHelper setDataByName:@"sitUpLevel" andData:[NSString stringFromInteger:level] withError:&error];
                }
            }
            break;
        case ExerciseTypeSquat:
            level = [[AccountCoreDataHelper getDataByName:@"squatLevel" withError:&error] integerValue];
            if (level < ExerciseLevelLimit) {
                targetNum = [CommonUtil getTargetNumFromType:type andLevel:level];
                if (lastDateNum > targetNum) {//升级
                    level ++;
                    [AccountCoreDataHelper setDataByName:@"squatLevel" andData:[NSString stringFromInteger:level] withError:&error];
                }
            }
            break;
        case ExerciseTypeWalk:
            level = [[AccountCoreDataHelper getDataByName:@"walkLevel" withError:&error] integerValue];
            if (level < ExerciseLevelLimit) {
                targetNum = [CommonUtil getTargetNumFromType:type andLevel:level];
                if (lastDateNum > targetNum) {//升级
                    level ++;
                    [AccountCoreDataHelper setDataByName:@"walkLevel" andData:[NSString stringFromInteger:level] withError:&error];
                }
            }
            break;
            
        default:
            break;
    }
}

@end
