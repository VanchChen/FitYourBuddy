//
//  SitUpViewController.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/2/25.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "SitUpViewController.h"
#import "WQCircleProgressBar.h"
#import "SoundTool.h"

#import "CompleteViewController.h"

@interface SitUpViewController ()
{
    NSInteger               count;
    NSInteger               targetNum;
    NSInteger               maxExerciseNum;
    UILabel                 *recordLabel;
    
    UILabel                 *progressLabel;
    WQCircleProgressBar     *closedIndicator;
    CMMotionManager         *wqMotionManager;
    
    UIButton                *soundButton;
    
    NSArray                 *soundArray;
    NSUInteger              soundIndex;
    
    
    UIView                  *navBarView;
    UILabel                 *navTitleLabel;
    UIView                  *todayTargetView;
    UIView                  *maxRecordView;
    UIButton                *saveButton;
    UILabel                 *completeLabel;
}

@end

@implementation SitUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    self.view.backgroundColor = indexBackgroundColor;
    
    //获取3个值 单次最大记录，目标数，今天的总数
    NSError *error;
    maxExerciseNum = [ExerciseCoreDataHelper getBestNumByType:ExerciseTypePushUp withError:&error];
    NSString *maxNumString = [NSString getFromInteger:maxExerciseNum];
    targetNum = [[AccountCoreDataHelper getDataByName:@"pushUpLevel" withError:&error] integerValue] - 1 + 10;
    NSString *targetNumString = [NSString getFromInteger:targetNum];
    
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
    [soundButton setImage:nil forState:UIControlStateHighlighted];
    [soundButton setImage:[UIImage imageNamed:@"SoundDisenabledIcon"] forState:UIControlStateSelected];
    [soundButton addTarget:self action:@selector(tappedSoundBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:soundButton];
    
    //今日目标
    todayTargetView = [CommonUtil createViewWithFrame:CGRectMake(APPCONFIG_UI_VIEW_BETWEEN_PADDING, APPCONFIG_UI_VIEW_BETWEEN_PADDING + APPCONFIG_UI_STATUSBAR_HEIGHT + APPCONFIG_UI_NAVIGATIONBAR_HEIGHT, 120, 30) andHasBorder:NO];
    [self.view addSubview:todayTargetView];
    
    UILabel* textLabel = [CommonUtil createLabelWithText:@"今日目标" andTextColor:tipTitleLabelColor andFont:[UIFont systemFontOfSize:16]];
    textLabel.frame = CGRectMake(10, 0, 70, 30);
    [todayTargetView addSubview:textLabel];
    
    textLabel = [CommonUtil createLabelWithText:targetNumString andTextColor:tipTitleLabelColor andFont:[UIFont systemFontOfSize:18] andTextAlignment:NSTextAlignmentCenter];
    textLabel.frame = CGRectMake(80, 0, 40, 30);
    [todayTargetView addSubview:textLabel];
    
    //个人记录
    maxRecordView = [CommonUtil createViewWithFrame:CGRectMake(APPCONFIG_UI_SCREEN_FWIDTH - 120 - APPCONFIG_UI_VIEW_BETWEEN_PADDING, APPCONFIG_UI_SCREEN_FHEIGHT - APPCONFIG_UI_TABBAR_HEIGHT - APPCONFIG_UI_STATUSBAR_HEIGHT - 30 - APPCONFIG_UI_VIEW_BETWEEN_PADDING, 120, 30) andHasBorder:NO];
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
    
    closedIndicator = [[WQCircleProgressBar alloc]initWithFrame:CGRectMake((APPCONFIG_UI_SCREEN_FWIDTH - 220)/2, 50, 220, 220) type:ClosedIndicator];
    [closedIndicator setBackgroundColor:[UIColor clearColor]];
    [closedIndicator setFillColor:sitUpColor];
    [closedIndicator setStrokeColor:sitUpColor];
    [self.view addSubview:closedIndicator];
    [closedIndicator loadIndicator];
    
    progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 80)];
    [progressLabel setTextColor:tipTitleLabelColor];
    [progressLabel setFont:[UIFont boldSystemFontOfSize:60]];
    [progressLabel setTextAlignment:NSTextAlignmentCenter];
    [progressLabel setText:@"0"];
    [progressLabel setCenter:closedIndicator.center];
    [self.view addSubview:progressLabel];
    
    completeLabel = [[UILabel alloc] initWithFrame:CGRectMake(progressLabel.frame.origin.x, progressLabel.frame.origin.y - 20, 100, 30)];
    [completeLabel setText:@"已完成"];
    [completeLabel setTextColor:tipTitleLabelColor];
    [completeLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [completeLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:completeLabel];
    
    soundArray = [[NSArray alloc] initWithObjects:@"c4",@"d4",@"e4",@"g4",@"a4",@"c5",@"a4",@"g4",@"e4",@"d4", nil];
    soundIndex = 0;
    
    //开启运动检测
    count = 0;//计数器清空
    wqMotionManager = [[CMMotionManager alloc]init];
    if (wqMotionManager.deviceMotionAvailable) {
        wqMotionManager.deviceMotionUpdateInterval = 0.2;
        __block BOOL isStart = false;
        //__block CMAttitude *initialAttitude = wqMotionManager.deviceMotion.attitude;
        
        
        [wqMotionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
//            if (initialAttitude != nil) {
//                [motion.attitude multiplyByInverseOfAttitude:initialAttitude];
//            }
            
            //double magnitude = [self magnitudeFromAttitude:motion.attitude];
            
            NSLog(@"%f", motion.attitude.roll);
            
            if (!isStart && motion.attitude.roll > - 1.5) {
                isStart = true;
                count++;
                [progressLabel setText:[NSString stringWithFormat:@"%ld", (long)count]];
                [closedIndicator updateWithTotalBytes:20 downloadedBytes:count];
                
                //播放声音
                if (!soundButton.selected) {
                    [SoundTool playsound:[soundArray objectAtIndex:soundIndex]];
                    soundIndex ++;
                    if (soundIndex == [soundArray count]) soundIndex = 0;
                }
                
            }
            
            if (isStart && motion.attitude.roll < - 2) {
                isStart = false;
            }
        }];
        
    } else {
        NSLog(@"并没有加速计");
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    navBarView.frame = CGRectMake(0, 0, APPCONFIG_UI_VIEW_FWIDTH, APPCONFIG_UI_NAVIGATIONBAR_HEIGHT);
    
    navTitleLabel.frame = CGRectMake((APPCONFIG_UI_SCREEN_FWIDTH - 100) / 2.0f, 0, 100, APPCONFIG_UI_NAVIGATIONBAR_HEIGHT);
    
    soundButton.frame = CGRectMake(APPCONFIG_UI_SCREEN_FWIDTH - APPCONFIG_UI_VIEW_PADDING - 30, 7, 30, 30);
    
    todayTargetView.frame = CGRectMake(APPCONFIG_UI_VIEW_BETWEEN_PADDING, APPCONFIG_UI_VIEW_BETWEEN_PADDING + APPCONFIG_UI_NAVIGATIONBAR_HEIGHT, 120, 30);
    
    closedIndicator.frame = CGRectMake((APPCONFIG_UI_SCREEN_FWIDTH - 220)/2, 50, 220, 220);

    progressLabel.center = closedIndicator.center;
    [completeLabel topOfView:progressLabel withMargin:-10];
    completeLabel.center = CGPointMake(progressLabel.center.x, completeLabel.center.y);
    
    maxRecordView.frame = CGRectMake(APPCONFIG_UI_SCREEN_FWIDTH - 120 - APPCONFIG_UI_VIEW_BETWEEN_PADDING, APPCONFIG_UI_SCREEN_FHEIGHT - APPCONFIG_UI_TABBAR_HEIGHT - 30 - APPCONFIG_UI_VIEW_BETWEEN_PADDING, 120, 30);
    saveButton.frame = CGRectMake(0, APPCONFIG_UI_SCREEN_FHEIGHT - 39, APPCONFIG_UI_SCREEN_FWIDTH, 39);}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (void)tappedSaveBtn
{
    [wqMotionManager stopDeviceMotionUpdates];
    
    CompleteViewController *completeVC = [[CompleteViewController alloc] init];
    completeVC.exerciseNum = count;
    completeVC.exerciseType = ExerciseTypeSitUp;
    
    [self presentViewController:completeVC animated:NO completion:nil];
}

- (void)tappedSoundBtn:(UIButton *)button {
    button.selected = !button.selected;
}

- (double)magnitudeFromAttitude:(CMAttitude *)attitude
{
    return sqrt(pow(attitude.roll, 2) + pow(attitude.yaw, 2) + pow(attitude.pitch, 2));
}

@end
