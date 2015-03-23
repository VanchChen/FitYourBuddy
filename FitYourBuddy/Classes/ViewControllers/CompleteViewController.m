//
//  CompleteViewController.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/3/15.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "CompleteViewController.h"

#import "ExerciseViewController.h"

#import "WQProgressBar.h"

@interface CompleteViewController ()

@end

@implementation CompleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = themeBlueColor;
    self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    NSString *exerciseTypeString, *exerciseCompleteString;
    NSInteger targetNum, exerciseLevel, todayNum, beforeNum;
    float   maxNum, expRatio, beforeExp, afterExp, levelExp;
    
    //保存数据
    NSError *error;
    [ExerciseCoreDataHelper addExerciseByType:self.exerciseType andNum:self.exerciseNum withError:&error];
    
    todayNum = [ExerciseCoreDataHelper getTodayNumByType:self.exerciseType withError:&error];
    beforeNum = todayNum - self.exerciseNum;
    
    UIView* ballon = [[UIView alloc] initWithFrame:CGRectMake(110, 15 + 10, 24, 24)];
    [[ballon layer] setCornerRadius:12];
    [self.view addSubview:ballon];
    
    switch (self.exerciseType) {
        case ExerciseTypePushUp:
            [ballon setBackgroundColor:pushUpColor];
            exerciseTypeString = [NSString stringWithFormat:@"今天共完成%ld个俯卧撑", (long)todayNum];
            
            exerciseLevel = [[AccountCoreDataHelper getDataByName:@"pushUpLevel" withError:&error] integerValue];
            targetNum = exerciseLevel - 1 + 10;
            maxNum = targetNum + (exerciseLevel - 1) * 0.5 + 5;
            expRatio = (exerciseLevel - 1) * 0.1 + 2;
            
            break;
        case ExerciseTypeSitUp:
            [ballon setBackgroundColor:sitUpColor];
            exerciseTypeString = [NSString stringWithFormat:@"今天共完成%ld个仰卧起坐", (long)todayNum];
            
            exerciseLevel = [[AccountCoreDataHelper getDataByName:@"sitUpLevel" withError:&error] integerValue];
            targetNum = exerciseLevel - 1 + 20;
            maxNum = targetNum + (exerciseLevel - 1) * 0.5 + 10;
            expRatio = (exerciseLevel - 1) * 0.1 + 1;
            
            break;
        case ExerciseTypeSquat:
            [ballon setBackgroundColor:squatColor];
            exerciseTypeString = [NSString stringWithFormat:@"今天共完成%ld个深蹲", (long)todayNum];
            
            exerciseLevel = [[AccountCoreDataHelper getDataByName:@"squatLevel" withError:&error] integerValue];
            targetNum = exerciseLevel - 1 + 20;
            maxNum = targetNum + (exerciseLevel - 1) * 0.5 + 10;
            expRatio = (exerciseLevel - 1) * 0.1 + 1;
            
            break;
        case ExerciseTypeWalk:
            [ballon setBackgroundColor:walkColor];
            exerciseTypeString = [NSString stringWithFormat:@"今天共完成%ld个步行", (long)todayNum];
            
            exerciseLevel = [[AccountCoreDataHelper getDataByName:@"walkLevel" withError:&error] integerValue];
            targetNum = (exerciseLevel - 1) * 100 + 1000;
            maxNum = targetNum + (exerciseLevel - 1) * 50 + 500;
            expRatio = (exerciseLevel - 1) * 0.001 + 0.02;
            
            break;
        default:
            break;
    }
    
    //判断是否完成
    if (todayNum > targetNum) {
        exerciseCompleteString = @"目标完成！";
    } else {
        exerciseCompleteString = @"再接再厉";
    }
    
    //计算经验
    beforeExp = [[AccountCoreDataHelper getDataByName:@"exp" withError:&error] floatValue];
    if (todayNum > maxNum) todayNum = (NSInteger)floorf(maxNum); //限制为最大值
    if (beforeNum > maxNum) beforeNum = (NSInteger)floorf(maxNum); //限制为最大值
    
    afterExp = beforeExp + (todayNum - beforeNum) * expRatio;
    levelExp = [self getExpFromLevel:[AccountCoreDataHelper getDataByName:@"level" withError:&error]];
    
    if (afterExp >= levelExp) {
        //升级啦
    }
    
    //保存新经验
    [AccountCoreDataHelper setDataByName:@"exp" andData:[NSString stringWithFormat:@"%f", afterExp] withError:&error];
    
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 15, 100, 44)];
    [titleLabel setText:exerciseCompleteString];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [self.view addSubview:titleLabel];
    
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, 63, self.view.bounds.size.width, 1)];
    [line setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:line];
    
    UILabel* textLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 64 + 5, self.view.bounds.size.width - 40, 30)];
    [textLabel setText:exerciseTypeString];
    [textLabel setTextColor:[UIColor whiteColor]];
    [textLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [self.view addSubview:textLabel];
    
    //临时小胖砸图
    
    if (APPCONFIG_DEVICE_OVER_IPHONE5) {
        UIImageView* littleFatGuy = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 151, 235)]; //9/14
        [littleFatGuy setImage:[UIImage imageNamed:@"LittleFatGuy"]];
        [littleFatGuy setCenter:self.view.center];
        [self.view addSubview:littleFatGuy];
    } else {
        UIImageView* littleFatGuy = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 126, 196)]; //9/14
        [littleFatGuy setImage:[UIImage imageNamed:@"LittleFatGuy"]];
        [littleFatGuy setCenter:self.view.center];
        [self.view addSubview:littleFatGuy];
    }
    
    //等级进度条
    UIView* historyLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 63 - 50, self.view.bounds.size.width, 1)];
    [historyLine setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:historyLine];
    
    UILabel* historyLevel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.view.bounds.size.height - 63 - 50, 30, 50)];
    [historyLevel setText:@"Lv.1"];
    [historyLevel setTextColor:[UIColor whiteColor]];
    [historyLevel setFont:[UIFont boldSystemFontOfSize:16]];
    [historyLevel setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:historyLevel];
    
    WQProgressBar* historyProgressBar = [[WQProgressBar alloc] initWithFrame:CGRectMake(50, self.view.bounds.size.height - 63 - 50 + 13, 220, 23) fromStartRat:beforeExp/levelExp  toEndRat:afterExp/levelExp];
    [self.view addSubview:historyProgressBar];
    
    //完成按钮
    UIButton* completeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 63, self.view.bounds.size.width, 63)];
    [completeButton setBackgroundColor:saveButtonGreyColor];
    [completeButton addTarget:self action:@selector(tappedCompleteButton) forControlEvents:UIControlEventTouchUpInside];
    [completeButton setTitle:@"完成锻炼" forState:UIControlStateNormal];
    [completeButton setTitleColor:saveTextGreyColor forState:UIControlStateNormal];
    [self.view addSubview:completeButton];
}

- (void)tappedCompleteButton
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CompleteTapNote" object:nil];
}

- (float)getExpFromLevel:(NSString *)level
{
    int l = [level intValue];
    switch (l) {
        case 1:
            return 200;
            break;
        case 2:
            return 1000;
            break;
        case 3:
            return 4000;
            break;
        case 4:
            return 12000;
            break;
        default:
            return 0;
            break;
    }
}

@end
