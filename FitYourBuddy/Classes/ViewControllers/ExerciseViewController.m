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

#import "DebugViewController.h"

//static CGFloat const ExerciseViewButtonTopPadding = 30.0f;           //开始锻炼按钮初始上边距
//static CGFloat const ExerciseViewButtonWidth = 220.0f;               //开始锻炼按钮宽度
static CGFloat const ExerciseViewBallonWidth = 30.0f;                //开始锻炼按钮气球宽度
//static CGFloat const ExerciseViewSmallPadding = 10.0f;               //开始锻炼按钮气球宽度

static CGFloat const ExerciseCheckImageViewWidth = 40.0f;            //开始锻炼打勾宽度
static CGFloat const ExerciseCheckImageViewLeftPadding = 15.0f;      //开始锻炼打勾左边距

static CGFloat const ExerciseBtnBetweenPadding = 30.0f;             //新界面按钮间距

@interface ExerciseButton : UIButton

@property (nonatomic, assign) ExerciseType  exerciseType;
@property (nonatomic, strong) UILabel       *tintLabel;
@property (nonatomic, strong) UIImageView   *btnImageView;
@property (nonatomic, strong) UILabel       *numLabel;

/**
 *  更新目标栏
 *
 *  @param targetNum   目标数
 *  @param completeNum 完成数
 */
- (void)updateTargetNum:(NSInteger)targetNum CompleteNum:(NSInteger)completeNum;

- (instancetype)initWithFrame:(CGRect)frame exerciseType:(ExerciseType)exerciseType;

@end

@implementation ExerciseButton

- (instancetype)initWithFrame:(CGRect)frame exerciseType:(ExerciseType)exerciseType {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10.0f;
        //self.layer.masksToBounds = YES;
        self.layer.shadowOffset = CGSizeMake(0, 4);
        self.layer.shadowRadius = 0;
        self.layer.shadowOpacity = 1;
        self.layer.shadowColor = startTrainTargetGreyColor.CGColor;
        
        self.exerciseType = exerciseType;
        
        _tintLabel = [CommonUtil createLabelWithText:@"" andTextColor:tipTitleLabelColor andFont:[UIFont systemFontOfSize:16.0f] andTextAlignment:NSTextAlignmentCenter];
        _tintLabel.frame = CGRectMake(0, APPCONFIG_UI_VIEW_PADDING, self.width, 20);
        [self addSubview:_tintLabel];
        
        CGFloat btnImageWidth = frame.size.width - APPCONFIG_UI_VIEW_PADDING * 2;
        if (!APPCONFIG_DEVICE_OVER_IPHONE5) {
            btnImageWidth -= APPCONFIG_UI_VIEW_PADDING * 2;
        }
        
        _btnImageView = [[UIImageView alloc] init];
        _btnImageView.frame = CGRectMake(0, 0, btnImageWidth, btnImageWidth);
        _btnImageView.center = CGPointMake(self.width / 2.0f, self.height / 2.0f);
        [self addSubview:_btnImageView];
        
        _numLabel = [CommonUtil createLabelWithText:@"" andTextColor:themeGreyColor andFont:[UIFont systemFontOfSize:16.0f] andTextAlignment:NSTextAlignmentCenter];
        _numLabel.frame = CGRectMake(0, 0, self.width, 20);
        [_numLabel bottomOfView:_btnImageView withMargin:APPCONFIG_UI_VIEW_BETWEEN_PADDING sameHorizontal:YES];
        [self addSubview:_numLabel];
        
        _btnImageView.image = [UIImage imageWithExerciseType:_exerciseType];
        switch (_exerciseType) {
            case ExerciseTypeSitUp: {
                _tintLabel.text = @"仰卧起坐";
                break;
            }
            case ExerciseTypePushUp: {
                _tintLabel.text = @"俯卧撑";
                break;
            }
            case ExerciseTypeSquat: {
                _tintLabel.text = @"深蹲";
                break;
            }
            case ExerciseTypeWalk: {
                _tintLabel.text = @"步行";
                break;
            }
            default: {
                break;
            }
        }
    }
    return self;
}

- (void)layoutSubviews {
    
}

- (void)updateTargetNum:(NSInteger)targetNum CompleteNum:(NSInteger)completeNum {
    _numLabel.text = [NSString stringWithFormat:@"%ld / %ld", (long)completeNum, (long)targetNum];
    if (completeNum < targetNum) {
        _numLabel.textColor = themeGreyColor;
    } else {
        switch (_exerciseType) {
            case ExerciseTypeSitUp: {
                _numLabel.textColor = sitUpColor;
                break;
            }
            case ExerciseTypePushUp: {
                _numLabel.textColor = pushUpColor;
                break;
            }
            case ExerciseTypeSquat: {
                _numLabel.textColor = squatColor;
                break;
            }
            case ExerciseTypeWalk: {
                _numLabel.textColor = walkColor;
                break;
            }
            default: {
                break;
            }
        }
    }
}

@end

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
    
    UIImageView         *sitUpCheck;
    UIImageView         *pushUpCheck;
    UIImageView         *squatCheck;
    UIImageView         *walkCheck;
}

@property(nonatomic, strong) ExerciseButton *sitUpBtn;
@property(nonatomic, strong) ExerciseButton *pushUpBtn;
@property(nonatomic, strong) ExerciseButton *squatBtn;
@property(nonatomic, strong) ExerciseButton *walkBtn;

@property(nonatomic, assign) NSInteger debugCount;

@end

@implementation ExerciseViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"开始锻炼"];
}

- (void)dealloc {
    //销毁提醒
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CompleteTapNote" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
    
    [self initButton];
}

- (void)initNav {
    //加消息提醒
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(completeVCDidTappedButon) name:@"CompleteTapNote" object:nil];
    
    self.title = @"开始锻炼";
    
    //暗门入口
    self.debugCount = 0;
    UIButton *debugButton = [UIButton buttonWithType:UIButtonTypeCustom];
    debugButton.frame = CGRectMake(0, 0, 30, 30);
    debugButton.backgroundColor = [UIColor clearColor];
    [debugButton addTarget:self action:@selector(tappedDebugButton) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:debugButton];
}

- (void)initButton {
    CGFloat btnWidth = (self.view.width - APPCONFIG_UI_VIEW_PADDING * 3) / 2.0f;
    CGFloat btnHeight = (APPCONFIG_UI_SCREEN_VHEIGHT - ExerciseBtnBetweenPadding * 3) / 2.0f;
    
    _sitUpBtn = [[ExerciseButton alloc] initWithFrame:CGRectMake(APPCONFIG_UI_VIEW_PADDING, ExerciseBtnBetweenPadding, btnWidth, btnHeight) exerciseType:ExerciseTypeSitUp];
    [_sitUpBtn addTarget:self action:@selector(tappedSitUpBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sitUpBtn];
    
    _pushUpBtn = [[ExerciseButton alloc] initWithFrame:CGRectMake(APPCONFIG_UI_VIEW_PADDING * 2 + btnWidth, ExerciseBtnBetweenPadding, btnWidth, btnHeight) exerciseType:ExerciseTypePushUp];
    [_pushUpBtn addTarget:self action:@selector(tappedPushUpBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_pushUpBtn];
    
    _squatBtn = [[ExerciseButton alloc] initWithFrame:CGRectMake(APPCONFIG_UI_VIEW_PADDING, ExerciseBtnBetweenPadding * 2 + btnHeight, btnWidth, btnHeight) exerciseType:ExerciseTypeSquat];
    [_squatBtn addTarget:self action:@selector(tappedSquatBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_squatBtn];
    
    _walkBtn = [[ExerciseButton alloc] initWithFrame:CGRectMake(APPCONFIG_UI_VIEW_PADDING * 2 + btnWidth, ExerciseBtnBetweenPadding * 2 + btnHeight, btnWidth, btnHeight) exerciseType:ExerciseTypeWalk];
    [_walkBtn addTarget:self action:@selector(tappedWalkBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_walkBtn];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"开始锻炼"];
    
    //重置暗门阀值
    self.debugCount = 0;
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
    
    [_sitUpBtn updateTargetNum:sitUpNum CompleteNum:sitUpDoneNum];
    [_pushUpBtn updateTargetNum:pushUpNum CompleteNum:pushUpDoneNum];
    [_squatBtn updateTargetNum:squatNum CompleteNum:squatDoneNum];
    [_walkBtn updateTargetNum:walkNum CompleteNum:walkDoneNum];
    
    //计算内容
//    sitUpLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)sitUpDoneNum, (long)sitUpNum];
//    pushUpLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)pushUpDoneNum, (long)pushUpNum];
//    squatLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)squatDoneNum, (long)squatNum];
//    walkLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)walkDoneNum, (long)walkNum];
//    if (sitUpDoneNum >= sitUpNum) {
//        [sitUpMission setBackgroundColor:themeBlueColor];
//        [sitUpCheck setHidden:NO];
//    } else{
//        [sitUpMission setBackgroundColor:startTrainTargetGreyColor];
//        [sitUpCheck setHidden:YES];
//    }
//    
//    if (pushUpDoneNum >= pushUpNum) {
//        [pushUpMission setBackgroundColor:themeBlueColor];
//        [pushUpCheck setHidden:NO];
//    } else{
//        [pushUpMission setBackgroundColor:startTrainTargetGreyColor];
//        [pushUpCheck setHidden:YES];
//    }
//    
//    if (squatDoneNum >= squatNum) {
//        [squatMission setBackgroundColor:themeBlueColor];
//        [squatCheck setHidden:NO];
//    } else{
//        [squatMission setBackgroundColor:startTrainTargetGreyColor];
//        [squatCheck setHidden:YES];
//    }
//    
//    if (walkDoneNum >= walkNum) {
//        [walkMission setBackgroundColor:themeBlueColor];
//        [walkCheck setHidden:NO];
//    } else{
//        [walkMission setBackgroundColor:startTrainTargetGreyColor];
//        [walkCheck setHidden:YES];
//    }
}

#pragma mark - Something Used Before
//先创建按钮
//    sitUpMission = [[UIView alloc] initWithFrame:CGRectMake(20, 80, self.view.frame.size.width - 40, 40)];
//    [[sitUpMission layer] setCornerRadius:15];
//    [self.view addSubview:sitUpMission];
//
//    pushUpMission = [[UIView alloc] initWithFrame:CGRectMake(20, 125, self.view.frame.size.width - 40, 40)];
//    [pushUpMission setBackgroundColor:themeBlueColor];
//    [[pushUpMission layer] setCornerRadius:15];
//    [self.view addSubview:pushUpMission];
//
//    squatMission = [[UIView alloc] initWithFrame:CGRectMake(20, 170, self.view.frame.size.width - 40, 40)];
//    [squatMission setBackgroundColor:themeBlueColor];
//    [[squatMission layer] setCornerRadius:15];
//    [self.view addSubview:squatMission];
//
//    walkMission = [[UIView alloc] initWithFrame:CGRectMake(20, 215, self.view.frame.size.width - 40, 40)];
//    [walkMission setBackgroundColor:themeBlueColor];
//    [[walkMission layer] setCornerRadius:15];
//    [self.view addSubview:walkMission];

//加载按钮
//    UILabel* textLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 80, 30)];
//    [textLabel setText:@"日常任务:"];
//    [textLabel setTextColor:tipTitleLabelColor];
//    [textLabel setFont:[UIFont systemFontOfSize:18]];
//    [self.view addSubview:textLabel];
//
//    textLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 35, 290, 30)];
//    [textLabel setText:@"请选择喜欢的运动，并完成锻炼目标"];
//    [textLabel setTextColor:tipTitleLabelColor];
//    [textLabel setFont:[UIFont systemFontOfSize:18]];
//    [self.view addSubview:textLabel];
//
//    textLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 150, 40)];
//    [textLabel setText:@"仰卧起坐"];
//    [textLabel setTextColor:[UIColor whiteColor]];
//    [textLabel setFont:[UIFont boldSystemFontOfSize:16]];
//    [sitUpMission addSubview:textLabel];
//
//    sitUpLabel = [[UILabel alloc] initWithFrame:CGRectMake(sitUpMission.frame.size.width - 100, 0, 80, 40)];
//    [sitUpLabel setTextColor:[UIColor whiteColor]];
//    [sitUpLabel setFont:[UIFont boldSystemFontOfSize:16]];
//    [sitUpLabel setTextAlignment:NSTextAlignmentRight];
//    [sitUpMission addSubview:sitUpLabel];
//
//    textLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 150, 40)];
//    [textLabel setText:@"俯卧撑"];
//    [textLabel setTextColor:[UIColor whiteColor]];
//    [textLabel setFont:[UIFont boldSystemFontOfSize:16]];
//    [pushUpMission addSubview:textLabel];
//
//    pushUpLabel = [[UILabel alloc] initWithFrame:CGRectMake(sitUpMission.frame.size.width - 100, 0, 80, 40)];
//    [pushUpLabel setTextColor:[UIColor whiteColor]];
//    [pushUpLabel setFont:[UIFont boldSystemFontOfSize:16]];
//    [pushUpLabel setTextAlignment:NSTextAlignmentRight];
//    [pushUpMission addSubview:pushUpLabel];
//
//    textLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 150, 40)];
//    [textLabel setText:@"深蹲"];
//    [textLabel setTextColor:[UIColor whiteColor]];
//    [textLabel setFont:[UIFont boldSystemFontOfSize:16]];
//    [squatMission addSubview:textLabel];
//
//    squatLabel = [[UILabel alloc] initWithFrame:CGRectMake(sitUpMission.frame.size.width - 100, 0, 80, 40)];
//    [squatLabel setTextColor:[UIColor whiteColor]];
//    [squatLabel setFont:[UIFont boldSystemFontOfSize:16]];
//    [squatLabel setTextAlignment:NSTextAlignmentRight];
//    [squatMission addSubview:squatLabel];
//
//    textLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 150, 40)];
//    [textLabel setText:@"步行"];
//    [textLabel setTextColor:[UIColor whiteColor]];
//    [textLabel setFont:[UIFont boldSystemFontOfSize:16]];
//    [walkMission addSubview:textLabel];
//
//    walkLabel = [[UILabel alloc] initWithFrame:CGRectMake(sitUpMission.frame.size.width - 100, 0, 80, 40)];
//    [walkLabel setTextColor:[UIColor whiteColor]];
//    [walkLabel setFont:[UIFont boldSystemFontOfSize:16]];
//    [walkLabel setTextAlignment:NSTextAlignmentRight];
//    [walkMission addSubview:walkLabel];

//按钮页面
//    buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, self.view.frame.size.height - 64 - 49 - 80)];
//    [buttonView setBackgroundColor:indexBackgroundColor];
//    [buttonView setClipsToBounds:YES];
//    [self.view addSubview:buttonView];

//添加手势
//    UIPanGestureRecognizer* gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
//    [buttonView setUserInteractionEnabled:YES];
//    [buttonView addGestureRecognizer:gesture];
//    isPull = false;

//    arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(buttonView.center.x - 12, 0, 24, 24)];
//    [arrowImage setImage:[UIImage imageNamed:@"DownArrow"]];
//    [buttonView addSubview:arrowImage];

//放置按钮
//    float buttonHeight = 0;
//    if (APPCONFIG_DEVICE_OVER_IPHONE5) {
//        buttonHeight = 75;
//    } else {
//        buttonHeight = 55;
//    }
//
//    //放按钮和勾
//    [self createExerciseButtonWithFrame:CGRectMake(APPCONFIG_UI_VIEW_PADDING, ExerciseViewButtonTopPadding, ExerciseViewButtonWidth, buttonHeight) andType:ExerciseTypeSitUp];
//    [self createExerciseButtonWithFrame:CGRectMake(APPCONFIG_UI_VIEW_PADDING, ExerciseViewButtonTopPadding + ExerciseViewSmallPadding + buttonHeight, ExerciseViewButtonWidth, buttonHeight) andType:ExerciseTypePushUp];
//    [self createExerciseButtonWithFrame:CGRectMake(APPCONFIG_UI_VIEW_PADDING, ExerciseViewButtonTopPadding + ExerciseViewSmallPadding * 2 + buttonHeight * 2, ExerciseViewButtonWidth, buttonHeight) andType:ExerciseTypeSquat];
//    [self createExerciseButtonWithFrame:CGRectMake(APPCONFIG_UI_VIEW_PADDING, ExerciseViewButtonTopPadding + ExerciseViewSmallPadding * 3 + buttonHeight * 3, ExerciseViewButtonWidth, buttonHeight) andType:ExerciseTypeWalk];

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
- (void)createExerciseButtonWithFrame:(CGRect)frame andType:(ExerciseType)type {
    SEL action;
    UIColor *color;
    NSString *label;
    switch (type) {
        case ExerciseTypeSitUp:
            action = @selector(tappedSitUpBtn);
            color = sitUpColor;
            label = @"仰卧起坐";
            break;
        case ExerciseTypePushUp:
            action = @selector(tappedPushUpBtn);
            color = pushUpColor;
            label = @"俯卧撑";
            break;
        case ExerciseTypeSquat:
            action = @selector(tappedSquatBtn);
            color = squatColor;
            label = @"深蹲";
            break;
        case ExerciseTypeWalk:
            action = @selector(tappedWalkBtn);
            color = walkColor;
            label = @"步行";
            break;
        default:
            action = nil;
            color = nil;
            label = nil;
            break;
    }
    
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
    
    UIImageView *checkView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ExerciseCheckImageViewWidth, ExerciseCheckImageViewWidth)];
    [checkView setHidden:YES];
    [checkView setImage:[UIImage imageNamed:@"ExerciseCheckIcon"]];
    [checkView rightOfView:tmpButton withMargin:ExerciseCheckImageViewLeftPadding sameVertical:YES];
    [buttonView addSubview:checkView];
    
    switch (type) {
        case ExerciseTypePushUp:
            pushUpCheck = checkView;
            break;
        case ExerciseTypeSitUp:
            sitUpCheck = checkView;
            break;
        case ExerciseTypeSquat:
            squatCheck = checkView;
            break;
        case ExerciseTypeWalk:
            walkCheck = checkView;
            break;
        default:
            break;
    }
}

//进入里世界
- (void)tappedDebugButton {
    self.debugCount++;
    if (_debugCount > 10) {
        DebugViewController *debugVC = [[DebugViewController alloc] init];
        [debugVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:debugVC animated:YES];
    }
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