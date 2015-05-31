//
//  SitUpViewController.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/2/25.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "SitUpViewController.h"
#import "WQCircleProgressBar.h"

#import "CompleteViewController.h"

@interface SitUpViewController ()
{
    NSInteger               maxExerciseNum;
    UILabel                 *recordLabel;
    
    UIButton                *soundButton;
    
    UIView                  *navBarView;
    UILabel                 *navTitleLabel;
    UIView                  *todayTargetView;
    UIView                  *maxRecordView;
    UIButton                *saveButton;
}

@property (nonatomic, assign) NSInteger                 targetNum;
@property (nonatomic, assign) NSInteger                 count;
@property (nonatomic, strong) CMMotionManager           *wqMotionManager;
@property (nonatomic, strong) WQCircleProgressBar       *closedIndicator;

@end

@implementation SitUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    self.view.backgroundColor = indexBackgroundColor;
    
    //获取3个值 单次最大记录，目标数，今天的总数
    NSError *error;
    maxExerciseNum = [ExerciseCoreDataHelper getBestNumByType:ExerciseTypePushUp withError:&error];
    NSString *maxNumString = [NSString stringFromInteger:maxExerciseNum];
    _targetNum = [CommonUtil getTargetNumFromType:ExerciseTypeSitUp andLevel:[[AccountCoreDataHelper getDataByName:@"sitUpLevel" withError:&error] integerValue]];
    NSString *targetNumString = [NSString stringFromInteger:_targetNum];
    
    //navigation bar
    navBarView = [[UIView alloc] init];
    navBarView.backgroundColor = sitUpColor;
    [self.view addSubview:navBarView];
    
    navTitleLabel = [[UILabel alloc] init];
    [navTitleLabel setText:@"仰卧起坐"];
    [navTitleLabel setTextColor:[UIColor whiteColor]];
    [navTitleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [navTitleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:navTitleLabel];
    
    //声音图标
    soundButton = [[UIButton alloc] init];
    [soundButton setImage:[UIImage imageNamed:@"SoundEnabledIcon"] forState:UIControlStateNormal];
    [soundButton setImage:[UIImage imageNamed:@"SoundDisenabledIcon"] forState:UIControlStateSelected];
    [soundButton setImage:nil forState:UIControlStateHighlighted];
    [soundButton setImage:nil forState:UIControlStateHighlighted | UIControlStateSelected];
    [soundButton addTarget:self action:@selector(tappedSoundBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:soundButton];
    
    //今日目标
    todayTargetView = [CommonUtil createViewWithFrame:CGRectMake(APPCONFIG_UI_VIEW_BETWEEN_PADDING, APPCONFIG_UI_VIEW_BETWEEN_PADDING + APPCONFIG_UI_STATUSBAR_HEIGHT + APPCONFIG_UI_NAVIGATIONBAR_HEIGHT, 120, 30) andHasBorder:NO];
    todayTargetView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:todayTargetView];
    
    UILabel* textLabel = [CommonUtil createLabelWithText:@"今日目标" andTextColor:tipTitleLabelColor andFont:[UIFont systemFontOfSize:16]];
    textLabel.frame = CGRectMake(10, 0, 70, 30);
    [todayTargetView addSubview:textLabel];
    
    textLabel = [CommonUtil createLabelWithText:targetNumString andTextColor:tipTitleLabelColor andFont:[UIFont systemFontOfSize:18] andTextAlignment:NSTextAlignmentCenter];
    textLabel.frame = CGRectMake(80, 0, 40, 30);
    [todayTargetView addSubview:textLabel];
    
    //个人记录
    maxRecordView = [CommonUtil createViewWithFrame:CGRectMake(APPCONFIG_UI_SCREEN_FWIDTH - 120 - APPCONFIG_UI_VIEW_BETWEEN_PADDING, APPCONFIG_UI_SCREEN_FHEIGHT - APPCONFIG_UI_TABBAR_HEIGHT - APPCONFIG_UI_STATUSBAR_HEIGHT - 30 - APPCONFIG_UI_VIEW_BETWEEN_PADDING, 120, 30) andHasBorder:NO];
    maxRecordView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:maxRecordView];
    
    textLabel = [CommonUtil createLabelWithText:@"个人记录" andTextColor:tipTitleLabelColor andFont:[UIFont systemFontOfSize:16]];
    textLabel.frame = CGRectMake(10, 0, 70, 30);
    [maxRecordView addSubview:textLabel];
    
    recordLabel = [CommonUtil createLabelWithText:maxNumString andTextColor:tipTitleLabelColor andFont:[UIFont systemFontOfSize:18] andTextAlignment:NSTextAlignmentCenter];
    recordLabel.frame = CGRectMake(80, 0, 40, 30);
    [maxRecordView addSubview:recordLabel];
    
    saveButton = [[UIButton alloc] initWithFrame:CGRectMake(0, APPCONFIG_UI_SCREEN_FHEIGHT - 39, APPCONFIG_UI_SCREEN_FWIDTH, 39)];
    [saveButton setBackgroundColor:sitUpColor];
    [saveButton addTarget:self action:@selector(tappedSaveBtn) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setTitle:@"保存并退出" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:saveButton];
    
    _closedIndicator = [[WQCircleProgressBar alloc]initWithFrame:CGRectMake((APPCONFIG_UI_SCREEN_FWIDTH - 220)/2, 50, 220, 220)];
    [self.view addSubview:_closedIndicator];
    
    __weak typeof(self) weakSelf = self;
    [_closedIndicator setProgressDidReadyBlock:^(WQCircleProgressBar *progressBar){
        //开启运动检测
        weakSelf.wqMotionManager = [[CMMotionManager alloc]init];
        if (weakSelf.wqMotionManager.deviceMotionAvailable) {
            weakSelf.wqMotionManager.deviceMotionUpdateInterval = 0.2;
            __block BOOL isStart = false;
            //__block CMAttitude *initialAttitude = wqMotionManager.deviceMotion.attitude;
            
            [weakSelf.wqMotionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
                //            if (initialAttitude != nil) {
                //                [motion.attitude multiplyByInverseOfAttitude:initialAttitude];
                //            }
                
                //double magnitude = [self magnitudeFromAttitude:motion.attitude];
                
                NSLog(@"%f", motion.attitude.roll);
                
                if (!isStart && motion.attitude.roll > - 1.5) {
                    isStart = true;
                    weakSelf.count++;
                    [weakSelf.closedIndicator updateWithTotalBytes:weakSelf.targetNum downloadedBytes:weakSelf.count];
                }
                
                if (isStart && motion.attitude.roll < - 2) {
                    isStart = false;
                }
            }];
            
        } else {
            NSLog(@"并没有加速计");
        }
    }];
    [_closedIndicator setStrokeColor:sitUpColor];
    [_closedIndicator loadIndicator];
    
    _count = 0;//计数器清空
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    navBarView.frame = CGRectMake(0, 0, APPCONFIG_UI_VIEW_FWIDTH, APPCONFIG_UI_NAVIGATIONBAR_HEIGHT);
    
    navTitleLabel.frame = CGRectMake((APPCONFIG_UI_SCREEN_FWIDTH - 100) / 2.0f, 0, 100, APPCONFIG_UI_NAVIGATIONBAR_HEIGHT);
    
    soundButton.frame = CGRectMake(APPCONFIG_UI_SCREEN_FWIDTH - APPCONFIG_UI_VIEW_PADDING - 30, 7, 30, 30);
    
    todayTargetView.frame = CGRectMake(APPCONFIG_UI_VIEW_BETWEEN_PADDING, APPCONFIG_UI_VIEW_BETWEEN_PADDING + APPCONFIG_UI_NAVIGATIONBAR_HEIGHT, 120, 30);
    
    _closedIndicator.frame = CGRectMake((APPCONFIG_UI_SCREEN_FWIDTH - 220)/2, 50, 220, 220);
    
    maxRecordView.frame = CGRectMake(APPCONFIG_UI_SCREEN_FWIDTH - 120 - APPCONFIG_UI_VIEW_BETWEEN_PADDING, APPCONFIG_UI_SCREEN_FHEIGHT - APPCONFIG_UI_TABBAR_HEIGHT - 30 - APPCONFIG_UI_VIEW_BETWEEN_PADDING, 120, 30);
    saveButton.frame = CGRectMake(0, APPCONFIG_UI_SCREEN_FHEIGHT - 39, APPCONFIG_UI_SCREEN_FWIDTH, 39);
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (void)tappedSaveBtn
{
    [_wqMotionManager stopDeviceMotionUpdates];
    
    CompleteViewController *completeVC = [[CompleteViewController alloc] init];
    completeVC.exerciseNum = _count;
    completeVC.exerciseType = ExerciseTypeSitUp;
    
    [self presentViewController:completeVC animated:NO completion:nil];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

- (void)tappedSoundBtn:(UIButton *)button {
    button.selected = !button.selected;
    _closedIndicator.allowSoundPlay = !button.selected;
}

- (double)magnitudeFromAttitude:(CMAttitude *)attitude
{
    return sqrt(pow(attitude.roll, 2) + pow(attitude.yaw, 2) + pow(attitude.pitch, 2));
}

@end
