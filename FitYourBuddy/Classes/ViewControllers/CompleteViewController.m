//
//  CompleteViewController.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/3/15.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "CompleteViewController.h"
#import "WQProgressBar.h"

static CGFloat const dataViewHeight = 100.0f;                   //数据框的高度
static CGFloat const dataViewTopPadding = 28.0f;                //数据框的上边距
static CGFloat const tipTitleLabelWidth = 100.0f;               //数据框的大小

@interface CompleteViewController ()
{
    UIView *navView;
    
    UIView *dayView;
    UIView *coinView;
    UIView *levelView;
}

@property(nonatomic, strong) UILabel        *titleLabel;        //标题文字
@property(nonatomic, strong) UILabel        *textLabel;         //今日完成数目
@property(nonatomic, strong) UIButton       *completeButton;    //完成按钮

@end

@implementation CompleteViewController

- (id)init {
    self = [super init];
    if (self) {
        self.view.backgroundColor = indexBackgroundColor;
        
        navView = [[UIView alloc] init];
        navView.backgroundColor = themeBlueColor;
        [self.view addSubview:navView];
        
        _titleLabel = [CommonUtil createLabelWithText:@"目标完成！" andTextColor:[UIColor whiteColor] andFont:[UIFont boldSystemFontOfSize:20] andTextAlignment:NSTextAlignmentCenter];
        [navView addSubview:_titleLabel];
        
        _textLabel = [CommonUtil createLabelWithText:@"今日共完成40个俯卧撑" andTextColor:themeDeepBlueColor andFont:[UIFont boldSystemFontOfSize:18] andTextAlignment:NSTextAlignmentCenter];
        _textLabel.backgroundColor = RGB_A(255,255,255,0.8f);
        _textLabel.layer.cornerRadius = 15;
        _textLabel.layer.masksToBounds = YES;
        [navView addSubview:_textLabel];
        
        _completeButton = [[UIButton alloc] init];
        [_completeButton setBackgroundColor:themeBlueColor];
        [_completeButton addTarget:self action:@selector(tappedCompleteButton) forControlEvents:UIControlEventTouchUpInside];
        [_completeButton setTitle:@"完成锻炼" forState:UIControlStateNormal];
        [_completeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.view addSubview:_completeButton];
        
        //放置数据块
        dayView = [CommonUtil createView];
        [self.view addSubview:dayView];
        
        coinView = [CommonUtil createView];
        [self.view addSubview:coinView];
        
        levelView = [CommonUtil createView];
        [self.view addSubview:levelView];
        
        //放提示框等，因为frame固定，所以无须放在layoutsubviews
        UILabel *tipTitleLabel = [CommonUtil createLabelWithText:@"坚持天数" andTextColor:tipTitleLabelColor andFont:[UIFont systemFontOfSize:20]];
        tipTitleLabel.frame = CGRectMake(APPCONFIG_UI_VIEW_PADDING, 0, tipTitleLabelWidth, dataViewHeight);
        [dayView addSubview:tipTitleLabel];
        
        tipTitleLabel = [CommonUtil createLabelWithText:@"金币" andTextColor:tipTitleLabelColor andFont:[UIFont systemFontOfSize:20]];
        tipTitleLabel.frame = CGRectMake(APPCONFIG_UI_VIEW_PADDING, 0, tipTitleLabelWidth, dataViewHeight);
        [coinView addSubview:tipTitleLabel];
        tipTitleLabel = [CommonUtil createLabelWithText:@"等级" andTextColor:tipTitleLabelColor andFont:[UIFont systemFontOfSize:20]];
        tipTitleLabel.frame = CGRectMake(APPCONFIG_UI_VIEW_PADDING, 0, tipTitleLabelWidth, dataViewHeight);
        [levelView addSubview:tipTitleLabel];
        
        UIImageView *leftCalendarImage = [[UIImageView alloc] init];
        leftCalendarImage.frame = CGRectMake(150, 25, 100, 50);
        leftCalendarImage.image = [UIImage imageNamed:@"CalendarIcon"];
        leftCalendarImage.contentMode = UIViewContentModeScaleAspectFill;
        [dayView addSubview:leftCalendarImage];
        
        UILabel *leftHistoryDayLabel = [CommonUtil createLabelWithText:@"10天" andTextColor:tipTitleLabelColor andFont:[UIFont boldSystemFontOfSize:30] andTextAlignment:NSTextAlignmentCenter];
        leftHistoryDayLabel.frame = CGRectMake(0, APPCONFIG_UI_VIEW_BETWEEN_PADDING + 5, leftCalendarImage.width, leftCalendarImage.height - APPCONFIG_UI_VIEW_BETWEEN_PADDING - 5);
        [leftCalendarImage addSubview:leftHistoryDayLabel];
        
        UIImageView *coinImage = [[UIImageView alloc] init];
        coinImage.image = [UIImage imageNamed:@"CoinIcon"];
        coinImage.frame = CGRectMake(150, 28, 44, 44);
        [coinView addSubview:coinImage];
        
        UILabel *coinLabel = [CommonUtil createLabelWithText:@"55" andTextColor:themeDarkOrangeColor andFont:[UIFont boldSystemFontOfSize:28]];
        coinLabel.frame = CGRectMake(0, 0, 80, 50);
        [coinLabel rightOfView:coinImage withMargin:10 sameVertical:YES];
        [coinView addSubview:coinLabel];
        
        WQProgressBar *levelProgressBar = [[WQProgressBar alloc] initWithFrame:CGRectMake(130, 25, 130, 50)];
        [levelView addSubview:levelProgressBar];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *exerciseTypeString, *exerciseCompleteString;
    NSInteger targetNum, exerciseLevel, todayNum, beforeNum;
    float   maxNum, expRatio, beforeExp, afterExp, levelExp;
    
    //保存数据
//    NSError *error;
//    [ExerciseCoreDataHelper addExerciseByType:self.exerciseType andNum:self.exerciseNum withError:&error];
//    
//    todayNum = [ExerciseCoreDataHelper getTodayNumByType:self.exerciseType withError:&error];
//    beforeNum = todayNum - self.exerciseNum;
//    
//    switch (self.exerciseType) {
//        case ExerciseTypePushUp:
//            [_ballon setBackgroundColor:pushUpColor];
//            exerciseTypeString = [NSString stringWithFormat:@"今天共完成%ld个俯卧撑", (long)todayNum];
//            
//            exerciseLevel = [[AccountCoreDataHelper getDataByName:@"pushUpLevel" withError:&error] integerValue];
//            targetNum = exerciseLevel - 1 + 10;
//            maxNum = targetNum + (exerciseLevel - 1) * 0.5 + 5;
//            expRatio = (exerciseLevel - 1) * 0.1 + 2;
//            
//            break;
//        case ExerciseTypeSitUp:
//            [_ballon setBackgroundColor:sitUpColor];
//            exerciseTypeString = [NSString stringWithFormat:@"今天共完成%ld个仰卧起坐", (long)todayNum];
//            
//            exerciseLevel = [[AccountCoreDataHelper getDataByName:@"sitUpLevel" withError:&error] integerValue];
//            targetNum = exerciseLevel - 1 + 20;
//            maxNum = targetNum + (exerciseLevel - 1) * 0.5 + 10;
//            expRatio = (exerciseLevel - 1) * 0.1 + 1;
//            
//            break;
//        case ExerciseTypeSquat:
//            [_ballon setBackgroundColor:squatColor];
//            exerciseTypeString = [NSString stringWithFormat:@"今天共完成%ld个深蹲", (long)todayNum];
//            
//            exerciseLevel = [[AccountCoreDataHelper getDataByName:@"squatLevel" withError:&error] integerValue];
//            targetNum = exerciseLevel - 1 + 20;
//            maxNum = targetNum + (exerciseLevel - 1) * 0.5 + 10;
//            expRatio = (exerciseLevel - 1) * 0.1 + 1;
//            
//            break;
//        case ExerciseTypeWalk:
//            [_ballon setBackgroundColor:walkColor];
//            exerciseTypeString = [NSString stringWithFormat:@"今天共完成%ld个步行", (long)todayNum];
//            
//            exerciseLevel = [[AccountCoreDataHelper getDataByName:@"walkLevel" withError:&error] integerValue];
//            targetNum = (exerciseLevel - 1) * 100 + 1000;
//            maxNum = targetNum + (exerciseLevel - 1) * 50 + 500;
//            expRatio = (exerciseLevel - 1) * 0.001 + 0.02;
//            
//            break;
//        default:
//            break;
//    }
    
//    //判断是否完成
//    if (todayNum > targetNum) {
//        exerciseCompleteString = @"目标完成！";
//    } else {
//        exerciseCompleteString = @"再接再厉";
//    }
//    
//    //计算经验
//    beforeExp = [[AccountCoreDataHelper getDataByName:@"exp" withError:&error] floatValue];
//    if (todayNum > maxNum) todayNum = (NSInteger)floorf(maxNum); //限制为最大值
//    if (beforeNum > maxNum) beforeNum = (NSInteger)floorf(maxNum); //限制为最大值
//    
//    afterExp = beforeExp + (todayNum - beforeNum) * expRatio;
//    levelExp = [CommonUtil getExpFromLevel:[AccountCoreDataHelper getDataByName:@"level" withError:&error]];
//    
//    if (afterExp >= levelExp) {
//        //升级啦
//    }
//    
//    //保存新经验
//    [AccountCoreDataHelper setDataByName:@"exp" andData:[NSString stringWithFormat:@"%f", afterExp] withError:&error];
//    
//    //标题
//    [_titleLabel setText:exerciseCompleteString];
//    //今天共完成
//    [_textLabel setText:exerciseTypeString];
//    
//    //等级进度条
//    _historyLevel.text = @"Lv.1";
    
    //WQProgressBar* historyProgressBar = [[WQProgressBar alloc] initWithFrame:CGRectMake(50, self.view.bounds.size.height - 63 - 50 + 13, 220, 23) fromStartRat:beforeExp/levelExp  toEndRat:afterExp/levelExp];
    //[self.view addSubview:historyProgressBar];
}

- (void)viewDidLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    //哈哈哈，这种写法是不是醉了？闪瞎狗眼，我自己都快看不懂了，但是科学啊
    navView.frame = CGRectMake(0, 0, APPCONFIG_UI_SCREEN_FWIDTH, APPCONFIG_UI_STATUSBAR_HEIGHT * 2 + APPCONFIG_UI_NAVIGATIONBAR_HEIGHT * 2);
    
    _titleLabel.frame = CGRectMake(0, APPCONFIG_UI_STATUSBAR_HEIGHT, APPCONFIG_UI_SCREEN_FWIDTH, APPCONFIG_UI_NAVIGATIONBAR_HEIGHT);
    
    _textLabel.frame = CGRectMake(APPCONFIG_UI_VIEW_PADDING, APPCONFIG_UI_STATUSBAR_HEIGHT + APPCONFIG_UI_NAVIGATIONBAR_HEIGHT, APPCONFIG_UI_SCREEN_FWIDTH - APPCONFIG_UI_VIEW_PADDING * 2, APPCONFIG_UI_NAVIGATIONBAR_HEIGHT);
    
    _completeButton.frame = CGRectMake(0, APPCONFIG_UI_SCREEN_FHEIGHT - APPCONFIG_UI_NAVIGATIONBAR_HEIGHT, APPCONFIG_UI_SCREEN_FWIDTH, APPCONFIG_UI_NAVIGATIONBAR_HEIGHT);
    
    dayView.frame = CGRectMake(APPCONFIG_UI_VIEW_PADDING, 0, APPCONFIG_UI_VIEW_FWIDTH - APPCONFIG_UI_VIEW_PADDING * 2, dataViewHeight);
    [dayView bottomOfView:navView withMargin:dataViewTopPadding];
    coinView.frame = CGRectMake(APPCONFIG_UI_VIEW_PADDING, 0, APPCONFIG_UI_VIEW_FWIDTH - APPCONFIG_UI_VIEW_PADDING * 2, dataViewHeight);
    [coinView bottomOfView:dayView withMargin:APPCONFIG_UI_VIEW_PADDING];
    levelView.frame = CGRectMake(APPCONFIG_UI_VIEW_PADDING, 0, APPCONFIG_UI_VIEW_FWIDTH - APPCONFIG_UI_VIEW_PADDING * 2, dataViewHeight);
    [levelView bottomOfView:coinView withMargin:APPCONFIG_UI_VIEW_PADDING];
}

- (void)tappedCompleteButton {
    self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CompleteTapNote" object:nil];
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
