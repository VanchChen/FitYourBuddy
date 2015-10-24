//
//  WorkOutViewController.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/7/5.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "WorkOutViewController.h"
#import "tutorialView.h"

@interface WorkOutViewController () <UIGestureRecognizerDelegate>

@property(nonatomic, strong)tutorialView *tutView;

@end

@implementation WorkOutViewController {
    NSDate *longPressStartTime;
    CGFloat timeInterval;
}

#pragma mark - Life Circle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //防止设备锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.exerciseType = ExerciseTypePushUp; //默认俯卧撑
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //获取3个值 单次最大记录，目标数，今天的总数
    _maxExerciseNum = [ExerciseCoreDataHelper getBestNumByType:self.exerciseType withError:nil];
    NSString *maxNumString = [NSString stringFromInteger:_maxExerciseNum];
    
    //navigation bar
    _navBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPCONFIG_UI_VIEW_FWIDTH, APPCONFIG_UI_STATUSBAR_HEIGHT + APPCONFIG_UI_NAVIGATIONBAR_HEIGHT)];
    [self.view addSubview:_navBarView];
    
    _titleLabel = [CommonUtil createLabelWithText:@"俯卧撑" andTextColor:[UIColor whiteColor] andFont:[UIFont boldSystemFontOfSize:20] andTextAlignment:NSTextAlignmentCenter];
    _titleLabel.frame = CGRectMake((APPCONFIG_UI_SCREEN_FWIDTH - 100.f) / 2.f, APPCONFIG_UI_STATUSBAR_HEIGHT, 100, APPCONFIG_UI_NAVIGATIONBAR_HEIGHT);
    [self.view addSubview:_titleLabel];
    
    _tutBtn = [[UIButton alloc]initWithFrame:CGRectMake(APPCONFIG_UI_VIEW_BETWEEN_PADDING, 0, 50, APPCONFIG_UI_NAVIGATIONBAR_HEIGHT)];
    [_tutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_tutBtn setTitle:@"教程" forState:UIControlStateNormal];
    [_tutBtn addTarget:self action:@selector(showTutorial) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_tutBtn];
    
    //声音图标
    _soundButton = [[UIButton alloc] init];
    _soundButton.frame = CGRectMake(APPCONFIG_UI_SCREEN_FWIDTH - APPCONFIG_UI_VIEW_BETWEEN_PADDING - 30, 25, 30, 30);
    [_soundButton setImage:[UIImage imageNamed:@"SoundEnabledIcon"] forState:UIControlStateNormal];
    [_soundButton setImage:[UIImage imageNamed:@"SoundDisenabledIcon"] forState:UIControlStateSelected];
    [_soundButton setImage:nil forState:UIControlStateHighlighted];
    [_soundButton setImage:nil forState:UIControlStateHighlighted | UIControlStateSelected];
    [_soundButton addTarget:self action:@selector(tappedSoundBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_soundButton];
    
    //今日目标
    _todayTargetView = [CommonUtil createViewWithFrame:CGRectMake(APPCONFIG_UI_VIEW_BETWEEN_PADDING, APPCONFIG_UI_VIEW_BETWEEN_PADDING + APPCONFIG_UI_STATUSBAR_HEIGHT + APPCONFIG_UI_NAVIGATIONBAR_HEIGHT, 120, 30) andHasBorder:NO];
    _todayTargetView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_todayTargetView];
    
    UILabel* textLabel = [CommonUtil createLabelWithText:@"今日目标" andTextColor:tipTitleLabelColor andFont:[UIFont systemFontOfSize:16]];
    textLabel.frame = CGRectMake(10, 0, 70, 30);
    [_todayTargetView addSubview:textLabel];
    
    UILabel* targetLabel = [CommonUtil createLabelWithText:@"" andTextColor:tipTitleLabelColor andFont:[UIFont systemFontOfSize:18] andTextAlignment:NSTextAlignmentCenter];
    targetLabel.frame = CGRectMake(80, 0, 40, 30);
    [_todayTargetView addSubview:targetLabel];
    
    //个人记录
    _maxRecordView = [CommonUtil createViewWithFrame:CGRectMake(APPCONFIG_UI_SCREEN_FWIDTH - 120 - APPCONFIG_UI_VIEW_BETWEEN_PADDING, APPCONFIG_UI_SCREEN_FHEIGHT - APPCONFIG_UI_TABBAR_HEIGHT - APPCONFIG_UI_STATUSBAR_HEIGHT - 30 - APPCONFIG_UI_VIEW_BETWEEN_PADDING, 120, 30) andHasBorder:NO];
    _maxRecordView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_maxRecordView];
    
    textLabel = [CommonUtil createLabelWithText:@"个人记录" andTextColor:tipTitleLabelColor andFont:[UIFont systemFontOfSize:16]];
    textLabel.frame = CGRectMake(10, 0, 70, 30);
    [_maxRecordView addSubview:textLabel];
    
    _recordLabel = [CommonUtil createLabelWithText:maxNumString andTextColor:tipTitleLabelColor andFont:[UIFont systemFontOfSize:18] andTextAlignment:NSTextAlignmentCenter];
    _recordLabel.frame = CGRectMake(80, 0, 40, 30);
    [_maxRecordView addSubview:_recordLabel];
    
    _saveButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 63, self.view.bounds.size.width, 63)];
    [_saveButton setTitle:@"长 按 退 出" forState:UIControlStateNormal];
    [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:_saveButton];
    
    float progressOriginY, progressWidth;
    if (self.view.width > self.view.height) {
        if (APPCONFIG_UI_SCREEN_FWIDTH >= 568.0f) {
            progressOriginY = 140;
            progressWidth = 280;
        } else {
            progressOriginY = 120;
            progressWidth = 240;
        }
    } else if (APPCONFIG_DEVICE_OVER_IPHONE5) {
        progressOriginY = 140;
        progressWidth = 280;
    } else {
        progressOriginY = 120;
        progressWidth = 240;
    }
    _closedIndicator = [[WQCircleProgressBar alloc]initWithFrame:CGRectMake((self.view.bounds.size.width - progressWidth)/2, progressOriginY, progressWidth, progressWidth)];
    [self.view addSubview:_closedIndicator];
    
    //setting
    switch (self.exerciseType) {
        case ExerciseTypeSitUp: {
            _titleLabel.text = @"仰卧起坐";
            _navBarView.backgroundColor = sitUpColor;
            [_closedIndicator setStrokeColor:sitUpColor];
            [_saveButton setBackgroundColor:sitUpColor];
            _targetNum = [CommonUtil getTargetNumFromType:self.exerciseType andLevel:[[AccountCoreDataHelper getDataByName:@"sitUpLevel" withError:nil] integerValue]];
            break;
        }
        case ExerciseTypePushUp: {
            _titleLabel.text = @"俯卧撑";
            _navBarView.backgroundColor = pushUpColor;
            [_closedIndicator setStrokeColor:pushUpColor];
            [_saveButton setBackgroundColor:pushUpColor];
            _targetNum = [CommonUtil getTargetNumFromType:self.exerciseType andLevel:[[AccountCoreDataHelper getDataByName:@"pushUpLevel" withError:nil] integerValue]];
            break;
        }
        case ExerciseTypeSquat: {
            _titleLabel.text = @"深蹲";
            _navBarView.backgroundColor = squatColor;
            [_closedIndicator setStrokeColor:squatColor];
            [_saveButton setBackgroundColor:squatColor];
            _targetNum = [CommonUtil getTargetNumFromType:self.exerciseType andLevel:[[AccountCoreDataHelper getDataByName:@"squatLevel" withError:nil] integerValue]];
            break;
        }
        case ExerciseTypeWalk: {
            _titleLabel.text = @"步行";
            _navBarView.backgroundColor = walkColor;
            [_closedIndicator setStrokeColor:walkColor];
            [_saveButton setBackgroundColor:walkColor];
            _targetNum = [CommonUtil getTargetNumFromType:self.exerciseType andLevel:[[AccountCoreDataHelper getDataByName:@"walkLevel" withError:nil] integerValue]];
            break;
        }
        default: {
            break;
        }
    }
    targetLabel.text = [NSString stringFromInteger:_targetNum];
    
    //载入声音设置
    BOOL sound = [[NSUserDefaults standardUserDefaults] boolForKey:@"SoundForWorkOut"];
    if (sound) {
        [_soundButton setSelected:YES];
        _closedIndicator.allowSoundPlay = NO;
    }
    
    //检查教程
    [self checkTutorial];

}

#pragma mark - tutorial method

- (void)checkTutorial {
    //------------------------教程相关------------------------
    if (self.exerciseType == ExerciseTypeWalk) {
        [self startCount];
        return;
    }
    _tutView = [[tutorialView alloc]initWithExerciseType:self.exerciseType complete:^(tutorialView *view){
        view.hidden = YES;
    }];
    _tutView.hidden = YES;
    [self.view addSubview:_tutView];
    //查看特定锻炼是否已运行过
    NSString *hasLaunchedOnce = [NSString string];
    switch (self.exerciseType) {
        case ExerciseTypePushUp:
            hasLaunchedOnce = @"PushUpHasLaunchedOnce";
            break;
        case ExerciseTypeSitUp:
            hasLaunchedOnce = @"SitUpHasLaunchedOnce";
            break;
        case ExerciseTypeSquat:
            hasLaunchedOnce = @"SquatHasLaunchedOnce";
            break;
        case ExerciseTypeWalk:
            [self startCount];
            return;
            break;
        default:
            break;
    }
    BOOL hasLaunch = [[NSUserDefaults standardUserDefaults] boolForKey:hasLaunchedOnce];
    if (hasLaunch) {
        //已运行过，正常启动
        [self startCount];
    } else {
        //未运行过，看教程先
        tutorialView *tuView = [[tutorialView alloc]initWithExerciseType:self.exerciseType complete:^(tutorialView *view){
            [view removeFromSuperview];
            [self startCount];
        }];
        [self.view addSubview:tuView];
    }
}

- (void)showTutorial {
//    tutorialView *tutView = [[tutorialView alloc]initWithExerciseType:self.exerciseType complete:^(tutorialView *view){
//        [view removeFromSuperview];
//    }];
//    [self.view addSubview:tutView];
    _tutView.hidden = NO;
}

- (void)startCount {
    [_closedIndicator loadIndicator];
    
    _count = 0;//计数器清空
    //添加覆盖view
    _coverView = [[UIView alloc] initWithFrame:self.view.bounds];
    _coverView.backgroundColor = [UIColor blackColor];
    _coverView.alpha = 0;
    [self.view addSubview:_coverView];
}

#pragma mark - click method
- (void)tappedSoundBtn:(UIButton *)button {
    button.selected = !button.selected;
    _closedIndicator.allowSoundPlay = !button.selected;
    [[NSUserDefaults standardUserDefaults] setBool:button.selected forKey:@"SoundForWorkOut"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)tappedSaveBtn {
    
}

#pragma mark - pan gesture
- (void)addPanGesture {
    //开启手势
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    longPressGesture.minimumPressDuration = 0.1f;
    longPressGesture.delegate = self;
    [self.saveButton addGestureRecognizer:longPressGesture];
}

- (void)handleGesture:(UILongPressGestureRecognizer *)longPressGesture {
    if (longPressGesture.state == UIGestureRecognizerStateBegan) {
        NSLog(@"start");
        //longPressStartTime = [NSDate date];
        timeInterval = 0;
        [self performSelector:@selector(fadeOutView) withObject:nil afterDelay:0.03f];
    } else if (longPressGesture.state == UIGestureRecognizerStateChanged) {
        NSLog(@"changed");
    } else if (longPressGesture.state == UIGestureRecognizerStateEnded) {
        NSLog(@"end");
        
        _coverView.alpha = 0;
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(fadeOutView) object:nil];
    }
    
//    CGFloat translatedX = [panGesture translationInView:self.view].x;
//    if (panGesture.state == UIGestureRecognizerStateChanged) {
//        if (translatedX > 100) {
//            translatedX = 100;
//        }
//        if (translatedX < 0) {
//            translatedX = 0;
//        }
//        _coverView.alpha = translatedX / 200.0f;
//    } else if (panGesture.state == UIGestureRecognizerStateEnded) {
//        _coverView.alpha = 0;
//        if (translatedX >= 100) {
//            [self tappedSaveBtn];
//        }
//    }
}

- (void)fadeOutView {
    timeInterval += 0.03f;
    if (timeInterval > 0.5f) {
        [self tappedSaveBtn];
    } else {
        _coverView.alpha = (timeInterval / 0.5f) * 0.8f;
        [self performSelector:@selector(fadeOutView) withObject:nil afterDelay:0.03f];
    }
}

@end
