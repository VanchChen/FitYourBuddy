//
//  CompleteViewController.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/3/15.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "CompleteViewController.h"
#import "WQProgressBar.h"

static CGFloat const dataViewHeight = 90.0f;                    //数据框的高度
static CGFloat const dataViewTopPadding = 28.0f;                //数据框的上边距
static CGFloat const dataViewLeftPadding = 30.0f;               //数据框的左边距

static CGFloat const tipTitleLabelWidth = 100.0f;               //数据框的大小
static CGFloat const arrowLeftPadding = 110.0f;                 //箭头的左边距
static CGFloat const arrowWidth = 20.0f;                        //箭头的宽度

static CGFloat const shareImageWidth = 24.0f;                   //分享按钮宽度

@interface CompleteViewController ()
{
    UIView *navView;
    
    UIView *dayView;
    UIView *coinView;
    UIView *levelView;
}

@property(nonatomic, strong) UILabel        *titleLabel;        //标题文字
@property(nonatomic, strong) UIButton       *textLabel;         //今日完成数目
@property(nonatomic, strong) UILabel        *textButtonLabel;   //完成按钮的标签框
@property(nonatomic, strong) UIImageView    *textButtonImage;   //完成按钮的图标
@property(nonatomic, strong) UILabel        *historyDayLabel;   //坚持天数
@property(nonatomic, strong) UILabel        *coinLabel;         //金币框
@property(nonatomic, strong) WQProgressBar  *levelProgressBar;  //经验框

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
        
        _textLabel = [UIButton buttonWithType:UIButtonTypeCustom];
        _textLabel.backgroundColor = [UIColor whiteColor];
        _textLabel.layer.cornerRadius = 15;
        _textLabel.layer.shadowOffset = CGSizeMake(0, 4);
        _textLabel.layer.shadowRadius = 0;
        _textLabel.layer.shadowOpacity = 1;
        _textLabel.layer.shadowColor = startTrainTargetGreyColor.CGColor;
        [navView addSubview:_textLabel];
        
        _textButtonLabel = [[UILabel alloc] init];
        _textButtonLabel.textColor = themeDeepBlueColor;
        _textButtonLabel.font = [UIFont boldSystemFontOfSize:16];
        _textButtonLabel.textAlignment = NSTextAlignmentCenter;
        [_textLabel addSubview:_textButtonLabel];
        
        _textButtonImage = [[UIImageView alloc] init];
        _textButtonImage.image = [UIImage imageNamed:@"ShareBlueIcon"];
        [_textLabel addSubview:_textButtonImage];
        
        _completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_completeButton setBackgroundColor:themePureBlueColor];
        [_completeButton addTarget:self action:@selector(tappedCompleteButton) forControlEvents:UIControlEventTouchUpInside];
        [_completeButton setTitle:@"完成锻炼" forState:UIControlStateNormal];
        [_completeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _completeButton.layer.cornerRadius = 15;
        _completeButton.layer.shadowOffset = CGSizeMake(0, 4);
        _completeButton.layer.shadowRadius = 0;
        _completeButton.layer.shadowOpacity = 1;
        _completeButton.layer.shadowColor = shadowBlueColor.CGColor;
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
        leftCalendarImage.frame = CGRectMake(120, (dataViewHeight - LevelIconWidth) / 2.0, LevelIconWidth, LevelIconWidth);
        leftCalendarImage.image = [UIImage imageNamed:@"CalendarIcon"];
        [dayView addSubview:leftCalendarImage];
        
        _historyDayLabel = [CommonUtil createLabelWithText:@"10" andTextColor:themeRedColor andFont:[UIFont boldSystemFontOfSize:24]];
        _historyDayLabel.frame = CGRectMake(0, 0, 60, 50);
        _historyDayLabel.textAlignment = NSTextAlignmentCenter;
        [_historyDayLabel rightOfView:leftCalendarImage withMargin:0 sameVertical:YES];
        [dayView addSubview:_historyDayLabel];
        
        UIImageView *coinImage = [[UIImageView alloc] init];
        coinImage.image = [UIImage imageNamed:@"CoinIcon"];
        coinImage.frame = CGRectMake(120, (dataViewHeight - LevelIconWidth) / 2.0, LevelIconWidth, LevelIconWidth);
        [coinView addSubview:coinImage];
        
        _coinLabel = [CommonUtil createLabelWithText:@"55" andTextColor:themeDarkOrangeColor andFont:[UIFont boldSystemFontOfSize:24]];
        _coinLabel.frame = CGRectMake(0, 0, 60, 50);
        _coinLabel.textAlignment = NSTextAlignmentCenter;
        [_coinLabel rightOfView:coinImage withMargin:0 sameVertical:YES];
        [coinView addSubview:_coinLabel];
        
        _levelProgressBar = [[WQProgressBar alloc] initWithFrame:CGRectMake(120, (dataViewHeight - LevelIconWidth) / 2.0, 130, LevelIconWidth)];
        [_levelProgressBar simpleVersion];
        [_levelProgressBar loadLevelAndExp];
        [levelView addSubview:_levelProgressBar];
    }
    return self;
}

- (void)viewDidLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    //哈哈哈，这种写法是不是醉了？闪瞎狗眼，我自己都快看不懂了，但是科学啊
    navView.frame = CGRectMake(0, 0, APPCONFIG_UI_SCREEN_FWIDTH, APPCONFIG_UI_STATUSBAR_HEIGHT * 2 + APPCONFIG_UI_NAVIGATIONBAR_HEIGHT * 2);
    
    _titleLabel.frame = CGRectMake(0, APPCONFIG_UI_STATUSBAR_HEIGHT, APPCONFIG_UI_SCREEN_FWIDTH, APPCONFIG_UI_NAVIGATIONBAR_HEIGHT);
    
    _textLabel.frame = CGRectMake(APPCONFIG_UI_VIEW_PADDING, APPCONFIG_UI_STATUSBAR_HEIGHT + APPCONFIG_UI_NAVIGATIONBAR_HEIGHT, APPCONFIG_UI_SCREEN_FWIDTH - APPCONFIG_UI_VIEW_PADDING * 2, APPCONFIG_UI_NAVIGATIONBAR_HEIGHT);
    _textButtonLabel.frame = CGRectMake(APPCONFIG_UI_VIEW_PADDING, 0, _textLabel.width - shareImageWidth - APPCONFIG_UI_VIEW_PADDING * 2, _textLabel.height);
    _textButtonImage.frame = CGRectMake(APPCONFIG_UI_VIEW_PADDING + _textButtonLabel.width, (_textLabel.height - shareImageWidth) / 2.0f, shareImageWidth, shareImageWidth);
    
    _completeButton.frame = CGRectMake(APPCONFIG_UI_VIEW_PADDING, APPCONFIG_UI_SCREEN_FHEIGHT - APPCONFIG_UI_NAVIGATIONBAR_HEIGHT - APPCONFIG_UI_VIEW_PADDING, APPCONFIG_UI_SCREEN_FWIDTH - APPCONFIG_UI_VIEW_PADDING * 2, APPCONFIG_UI_NAVIGATIONBAR_HEIGHT);
    
    dayView.frame = CGRectMake(dataViewLeftPadding, 0, APPCONFIG_UI_VIEW_FWIDTH - dataViewLeftPadding * 2, dataViewHeight);
    [dayView bottomOfView:navView withMargin:dataViewTopPadding];
    coinView.frame = CGRectMake(dataViewLeftPadding, 0, APPCONFIG_UI_VIEW_FWIDTH - dataViewLeftPadding * 2, dataViewHeight);
    [coinView bottomOfView:dayView withMargin:APPCONFIG_UI_VIEW_PADDING];
    levelView.frame = CGRectMake(dataViewLeftPadding, 0, APPCONFIG_UI_VIEW_FWIDTH - dataViewLeftPadding * 2, dataViewHeight);
    [levelView bottomOfView:coinView withMargin:APPCONFIG_UI_VIEW_PADDING];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //各种乱七八糟的计算
    NSString *exerciseTypeString, *exerciseCompleteString, *exerciseDayString;
    NSInteger maxNum ,targetNum, exerciseLevel, todayNum, beforeNum, beforeTotalNum, afterTotalNum, beforeCoinNum, afterCoinNum;
    float expRatio, beforeExp, afterExp, levelExp;
    BOOL needCover = NO;
    NSError *error;
    NSDictionary *dict = [AccountCoreDataHelper getAccountDictionaryWithError:&error];
    beforeTotalNum = [dict[@"count"] integerValue];
    afterTotalNum = beforeTotalNum;
    beforeCoinNum = [dict[@"coin"] integerValue];
    afterCoinNum = beforeCoinNum;
    
    if (self.exerciseNum > 0) {
        //保存数据
        [ExerciseCoreDataHelper addExerciseByType:self.exerciseType andNum:self.exerciseNum withError:&error];
    }
    
    todayNum = [ExerciseCoreDataHelper getTodayNumByType:self.exerciseType withError:&error];
    beforeNum = todayNum - self.exerciseNum;
    
    switch (self.exerciseType) {
        case ExerciseTypePushUp:
            exerciseTypeString = [NSString stringWithFormat:@"今天共完成%ld个俯卧撑", (long)todayNum];
            
            exerciseLevel = [dict[@"pushUpLevel"] integerValue];
            targetNum = [CommonUtil getTargetNumFromType:self.exerciseType andLevel:exerciseLevel];
            maxNum = targetNum + (exerciseLevel - 1) * 0.5 + 5;
            expRatio = (exerciseLevel - 1) * 0.1 + 2;
            
            break;
        case ExerciseTypeSitUp:
            exerciseTypeString = [NSString stringWithFormat:@"今天共完成%ld个仰卧起坐", (long)todayNum];
            
            exerciseLevel = [dict[@"sitUpLevel"] integerValue];
            targetNum = [CommonUtil getTargetNumFromType:self.exerciseType andLevel:exerciseLevel];
            maxNum = targetNum + (exerciseLevel - 1) * 0.5 + 10;
            expRatio = (exerciseLevel - 1) * 0.1 + 1;
            
            break;
        case ExerciseTypeSquat:
            exerciseTypeString = [NSString stringWithFormat:@"今天共完成%ld个深蹲", (long)todayNum];
            
            exerciseLevel = [dict[@"squatLevel"] integerValue];
            targetNum = [CommonUtil getTargetNumFromType:self.exerciseType andLevel:exerciseLevel];
            maxNum = targetNum + (exerciseLevel - 1) * 0.5 + 10;
            expRatio = (exerciseLevel - 1) * 0.1 + 1;
            
            break;
        case ExerciseTypeWalk:
            exerciseTypeString = [NSString stringWithFormat:@"今天共完成%ld个步行", (long)todayNum];
            
            exerciseLevel = [dict[@"walkLevel"] integerValue];
            targetNum = [CommonUtil getTargetNumFromType:self.exerciseType andLevel:exerciseLevel];
            maxNum = targetNum + (exerciseLevel - 1) * 50 + 500;
            expRatio = (exerciseLevel - 1) * 0.001 + 0.02;
            
            break;
        default:
            break;
    }
    
    //判断是否完成
    if (todayNum >= targetNum) {
        exerciseCompleteString = @"目标完成！";
        NSString *date = dict[@"date"];
        NSString *today = [[NSString today] substringToIndex:10];
        if (date.length == 0) {
            needCover = YES;
        } else {
            date = [date substringToIndex:10];
            if (![date isEqualToString:today]) {
                needCover = YES;
            }
        }
        if (needCover) {
            afterTotalNum ++;
            afterCoinNum += afterTotalNum;
            [AccountCoreDataHelper setDataByName:@"count" andData:[NSString stringFromInteger:afterTotalNum] withError:&error];
            [AccountCoreDataHelper setDataByName:@"coin" andData:[NSString stringFromInteger:afterCoinNum] withError:&error];
            [AccountCoreDataHelper setDataByName:@"date" andData:[NSString today] withError:&error];
        }
    } else {
        exerciseCompleteString = @"再接再厉";
    }
    
    //取锻炼天数
    exerciseDayString = [NSString stringWithFormat:@"%ld", (long)afterTotalNum];
    
    //赋标签框
    _titleLabel.text = exerciseCompleteString;
    _textButtonLabel.text = exerciseTypeString;
    _historyDayLabel.text = exerciseDayString;
    _coinLabel.text = [NSString stringFromInteger:afterCoinNum];

    //计算经验
    beforeExp = [dict[@"exp"] floatValue];
    if (todayNum > maxNum) todayNum = maxNum; //限制为最大值
    if (beforeNum > maxNum) beforeNum = maxNum; //限制为最大值

    afterExp = beforeExp + (todayNum - beforeNum) * expRatio;
    levelExp = [CommonUtil getExpFromLevel:dict[@"level"]];

    if (afterExp >= levelExp) {
        //升级啦
        NSInteger level = [dict[@"level"] integerValue] + 1;
        [AccountCoreDataHelper setDataByName:@"level" andData:[NSString stringFromInteger:level] withError:&error];
        
        afterExp = afterExp - levelExp;
    }

    //保存新经验
    [AccountCoreDataHelper setDataByName:@"exp" andData:[NSString stringWithFormat:@"%f", afterExp] withError:&error];
    //重载经验条
    [_levelProgressBar loadLevelAndExp];
}


- (void)tappedCompleteButton {
    self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CompleteTapNote" object:nil];
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
