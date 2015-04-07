//
//  ExerciseViewController.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/2/23.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "ExerciseViewController.h"
#import "SitUpViewController.h"
#import "PushUpViewController.h"
#import "SquatViewController.h"
#import "WalkViewController.h"

#import "CompleteViewController.h"

static CGFloat const ExerciseViewButtonTopPadding = 30.0f;           //开始锻炼按钮初始上边距
static CGFloat const ExerciseViewButtonWidth = 220.0f;               //开始锻炼按钮宽度
static CGFloat const ExerciseViewBallonWidth = 30.0f;                //开始锻炼按钮气球宽度
static CGFloat const ExerciseViewSmallPadding = 10.0f;               //开始锻炼按钮气球宽度

@interface ExerciseViewController ()
{
    BOOL                isPull;
    UIView              *buttonView;
    UIImageView         *arrowImage;
    
    NSDictionary        *accountDict;
    
    UIView              *sitUpMission;
    UIView              *pushUpMission;
    UIView              *squatMission;
    UIView              *walkMission;
    
    UILabel             *sitUpLabel;
    UILabel             *pushUpLabel;
    UILabel             *squatLabel;
    UILabel             *walkLabel;
}

@end

@implementation ExerciseViewController

- (void)dealloc {
    //销毁提醒
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CompleteTapNote" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //加消息提醒
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(completeVCDidTappedButon) name:@"CompleteTapNote" object:nil];
    
    self.title = @"开始锻炼";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //先创建按钮
    sitUpMission = [[UIView alloc] initWithFrame:CGRectMake(20, 80, self.view.frame.size.width - 40, 40)];
    [[sitUpMission layer] setCornerRadius:15];
    [self.view addSubview:sitUpMission];
    
    pushUpMission = [[UIView alloc] initWithFrame:CGRectMake(20, 125, self.view.frame.size.width - 40, 40)];
    [pushUpMission setBackgroundColor:themeBlueColor];
    [[pushUpMission layer] setCornerRadius:15];
    [self.view addSubview:pushUpMission];
    
    squatMission = [[UIView alloc] initWithFrame:CGRectMake(20, 170, self.view.frame.size.width - 40, 40)];
    [squatMission setBackgroundColor:themeBlueColor];
    [[squatMission layer] setCornerRadius:15];
    [self.view addSubview:squatMission];
    
    walkMission = [[UIView alloc] initWithFrame:CGRectMake(20, 215, self.view.frame.size.width - 40, 40)];
    [walkMission setBackgroundColor:themeBlueColor];
    [[walkMission layer] setCornerRadius:15];
    [self.view addSubview:walkMission];
    
    //加载按钮
    UILabel* textLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 80, 30)];
    [textLabel setText:@"日常任务:"];
    [textLabel setTextColor:tipTitleLabelColor];
    [textLabel setFont:[UIFont systemFontOfSize:18]];
    [self.view addSubview:textLabel];
    
    textLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 35, 290, 30)];
    [textLabel setText:@"请选择喜欢的运动，并完成锻炼目标"];
    [textLabel setTextColor:tipTitleLabelColor];
    [textLabel setFont:[UIFont systemFontOfSize:18]];
    [self.view addSubview:textLabel];
    
    textLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 150, 40)];
    [textLabel setText:@"仰卧起坐"];
    [textLabel setTextColor:[UIColor whiteColor]];
    [textLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [sitUpMission addSubview:textLabel];
    
    sitUpLabel = [[UILabel alloc] initWithFrame:CGRectMake(sitUpMission.frame.size.width - 100, 0, 80, 40)];
    [sitUpLabel setTextColor:[UIColor whiteColor]];
    [sitUpLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [sitUpLabel setTextAlignment:NSTextAlignmentRight];
    [sitUpMission addSubview:sitUpLabel];
    
    textLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 150, 40)];
    [textLabel setText:@"俯卧撑"];
    [textLabel setTextColor:[UIColor whiteColor]];
    [textLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [pushUpMission addSubview:textLabel];
    
    pushUpLabel = [[UILabel alloc] initWithFrame:CGRectMake(sitUpMission.frame.size.width - 100, 0, 80, 40)];
    [pushUpLabel setTextColor:[UIColor whiteColor]];
    [pushUpLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [pushUpLabel setTextAlignment:NSTextAlignmentRight];
    [pushUpMission addSubview:pushUpLabel];
    
    textLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 150, 40)];
    [textLabel setText:@"深蹲"];
    [textLabel setTextColor:[UIColor whiteColor]];
    [textLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [squatMission addSubview:textLabel];
    
    squatLabel = [[UILabel alloc] initWithFrame:CGRectMake(sitUpMission.frame.size.width - 100, 0, 80, 40)];
    [squatLabel setTextColor:[UIColor whiteColor]];
    [squatLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [squatLabel setTextAlignment:NSTextAlignmentRight];
    [squatMission addSubview:squatLabel];
    
    textLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 150, 40)];
    [textLabel setText:@"步行"];
    [textLabel setTextColor:[UIColor whiteColor]];
    [textLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [walkMission addSubview:textLabel];
    
    walkLabel = [[UILabel alloc] initWithFrame:CGRectMake(sitUpMission.frame.size.width - 100, 0, 80, 40)];
    [walkLabel setTextColor:[UIColor whiteColor]];
    [walkLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [walkLabel setTextAlignment:NSTextAlignmentRight];
    [walkMission addSubview:walkLabel];
    
    //按钮页面
    buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, self.view.frame.size.height - 64 - 49 - 80)];
    [buttonView setBackgroundColor:indexBackgroundColor];
    [buttonView setClipsToBounds:YES];
    [self.view addSubview:buttonView];
    
    //添加手势
    UIPanGestureRecognizer* gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [buttonView setUserInteractionEnabled:YES];
    [buttonView addGestureRecognizer:gesture];
    isPull = false;
    
    arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(buttonView.center.x - 12, 0, 24, 24)];
    [arrowImage setImage:[UIImage imageNamed:@"DownArrow"]];
    [buttonView addSubview:arrowImage];
    
    //放置按钮
    float buttonHeight = 0;
    if (APPCONFIG_DEVICE_OVER_IPHONE5) {
        buttonHeight = 75;
    } else {
        buttonHeight = 55;
    }
    
    [self createExerciseButtonWithFrame:CGRectMake(APPCONFIG_UI_VIEW_PADDING, ExerciseViewButtonTopPadding, ExerciseViewButtonWidth, buttonHeight) andSelector:@selector(tappedSitUpBtn) andBallonColor:sitUpColor andLabel:@"仰卧起坐"];
    [self createExerciseButtonWithFrame:CGRectMake(APPCONFIG_UI_VIEW_PADDING, ExerciseViewButtonTopPadding + ExerciseViewSmallPadding + buttonHeight, ExerciseViewButtonWidth, buttonHeight) andSelector:@selector(tappedPushUpBtn) andBallonColor:pushUpColor andLabel:@"俯卧撑"];
    [self createExerciseButtonWithFrame:CGRectMake(APPCONFIG_UI_VIEW_PADDING, ExerciseViewButtonTopPadding + ExerciseViewSmallPadding * 2 + buttonHeight * 2, ExerciseViewButtonWidth, buttonHeight) andSelector:@selector(tappedSquatBtn) andBallonColor:squatColor andLabel:@"深蹲"];
    [self createExerciseButtonWithFrame:CGRectMake(APPCONFIG_UI_VIEW_PADDING, ExerciseViewButtonTopPadding + ExerciseViewSmallPadding * 3 + buttonHeight * 3, ExerciseViewButtonWidth, buttonHeight) andSelector:@selector(tappedWalkBtn) andBallonColor:walkColor andLabel:@"步行"];
}

- (void)viewWillAppear:(BOOL)animated {
    //读取训练等级
    NSError *error;
    accountDict = [AccountCoreDataHelper getAccountDictionaryWithError:&error];
    //目标数目
    NSInteger sitUpNum = [CommonUtil getTargetNumFromType:ExerciseTypeSitUp andLevel:[accountDict[@"sitUpLevel"] integerValue]];
    NSInteger pushUpNum = [CommonUtil getTargetNumFromType:ExerciseTypePushUp andLevel:[accountDict[@"pushUpLevel"] integerValue]];
    NSInteger squatNum = [CommonUtil getTargetNumFromType:ExerciseTypeSquat andLevel:[accountDict[@"squatLevel"] integerValue]];
    NSInteger walkNum = [CommonUtil getTargetNumFromType:ExerciseTypeWalk andLevel:[accountDict[@"walkLevel"] integerValue]];
    //已完成数目
    NSInteger sitUpDoneNum = [ExerciseCoreDataHelper getTodayNumByType:ExerciseTypeSitUp withError:&error];
    NSInteger pushUpDoneNum = [ExerciseCoreDataHelper getTodayNumByType:ExerciseTypePushUp withError:&error];
    NSInteger squatDoneNum = [ExerciseCoreDataHelper getTodayNumByType:ExerciseTypeSquat withError:&error];
    NSInteger walkDoneNum = [ExerciseCoreDataHelper getTodayNumByType:ExerciseTypeWalk withError:&error];
    
    
    //计算内容
    sitUpLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)sitUpDoneNum, (long)sitUpNum];
    pushUpLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)pushUpDoneNum, (long)pushUpNum];
    squatLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)squatDoneNum, (long)squatNum];
    walkLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)walkDoneNum, (long)walkNum];
    if (sitUpDoneNum >= sitUpNum) {
        [sitUpMission setBackgroundColor:themeBlueColor];
    } else{
        [sitUpMission setBackgroundColor:startTrainTargetGreyColor];
    }
    
    if (pushUpDoneNum >= pushUpNum) {
        [pushUpMission setBackgroundColor:themeBlueColor];
    } else{
        [pushUpMission setBackgroundColor:startTrainTargetGreyColor];
    }
    
    if (squatDoneNum >= squatNum) {
        [squatMission setBackgroundColor:themeBlueColor];
    } else{
        [squatMission setBackgroundColor:startTrainTargetGreyColor];
    }
    
    if (walkDoneNum >= walkNum) {
        [walkMission setBackgroundColor:themeBlueColor];
    } else{
        [walkMission setBackgroundColor:startTrainTargetGreyColor];
    }
}

#pragma mark - Class Extention
- (void)tappedSitUpBtn {
    SitUpViewController *sitUpVC = [[SitUpViewController alloc] init];
    [self presentViewController:sitUpVC animated:YES completion:nil];
}

- (void)tappedPushUpBtn {
    PushUpViewController* newView = [[PushUpViewController alloc] init];
    [self presentViewController:newView animated:YES completion:nil];
}

- (void)tappedSquatBtn {
    SquatViewController* newView = [[SquatViewController alloc] init];
    [self presentViewController:newView animated:YES completion:nil];
}

- (void)tappedWalkBtn {
    WalkViewController* newView = [[WalkViewController alloc] init];
    [self presentViewController:newView animated:YES completion:nil];
}

// 创建按钮
- (void)createExerciseButtonWithFrame:(CGRect)frame andSelector:(SEL)action andBallonColor:(UIColor *)color andLabel:(NSString *)label {
    UIButton* tmpButton = [[UIButton alloc] initWithFrame:frame];
    [tmpButton setBackgroundColor:[UIColor whiteColor]];
    [tmpButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    tmpButton.layer.cornerRadius = 15;
    tmpButton.layer.borderWidth = 1;
    tmpButton.layer.borderColor = themeGreyColor.CGColor;
    [buttonView addSubview:tmpButton];
    
    UIView* tmpBallon = [[UIView alloc] initWithFrame:CGRectMake(APPCONFIG_UI_VIEW_PADDING, (frame.size.height - ExerciseViewBallonWidth) / 2, ExerciseViewBallonWidth, ExerciseViewBallonWidth)];
    [tmpBallon setBackgroundColor:color];
    tmpBallon.layer.cornerRadius = 15;
    [tmpButton addSubview:tmpBallon];
    
    UILabel* tmpLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(tmpBallon.frame) + APPCONFIG_UI_VIEW_PADDING, 0, CGRectGetMaxX(frame) - CGRectGetMaxX(tmpBallon.frame) - APPCONFIG_UI_VIEW_PADDING, CGRectGetHeight(frame))];
    [tmpLabel setTextColor:tipTitleLabelColor];
    [tmpLabel setFont:[UIFont systemFontOfSize:24]];
    [tmpLabel setText:label];
    [tmpButton addSubview:tmpLabel];
}

#pragma mark - Gesture Delegate
- (void)handlePan: (UIPanGestureRecognizer *)rec{
    float y = [rec translationInView:self.view].y;
    float speed = [rec velocityInView:self.view].y;
    
    if (([rec state] == UIGestureRecognizerStateEnded) || ([rec state] == UIGestureRecognizerStateCancelled)) {
        float totleHeight = 90;
        if (isPull) {
            if (-y < totleHeight && - speed < 1000.f) {
                [UIView animateWithDuration:0.2f animations:^{
                    buttonView.frame = CGRectMake(0, 265, self.view.frame.size.width, self.view.frame.size.height - 49 - 265);
                }];
            } else {
                isPull = false;
                [arrowImage setImage:[UIImage imageNamed:@"DownArrow"]];
                [UIView animateWithDuration:0.2f animations:^{
                    buttonView.frame = CGRectMake(0, 80, self.view.frame.size.width, self.view.frame.size.height - 49 - 80);
                }];
            }
        } else {
            if (y < totleHeight && speed < 1000.f) {
                [UIView animateWithDuration:0.2f animations:^{
                    buttonView.frame = CGRectMake(0, 80, self.view.frame.size.width, self.view.frame.size.height - 49 - 80);
                }];
            } else {
                isPull = true;
                [arrowImage setImage:[UIImage imageNamed:@"UpArrow"]];
                [UIView animateWithDuration:0.2f animations:^{
                    buttonView.frame = CGRectMake(0, 265, self.view.frame.size.width, self.view.frame.size.height - 49 - 265);
                }];
            }
        }
        
        
    } else if (isPull) {
        if (y <= 20 && y >= -220) {
            buttonView.frame = CGRectMake(0, 265 + y, self.view.frame.size.width, self.view.frame.size.height - 49 - 265 - y);
        }
    } else {
        if (y >= -20 && y <= 220) {
            buttonView.frame = CGRectMake(0, 80 + y, self.view.frame.size.width, self.view.frame.size.height - 49 - 80 - y);
        }
    }
}

#pragma mark - Complete View Delegate

- (void)completeVCDidTappedButon
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end