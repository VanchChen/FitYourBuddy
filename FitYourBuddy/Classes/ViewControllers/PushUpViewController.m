//
//  PushUpViewController.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/2/24.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "PushUpViewController.h"
#import "WQCircleProgressBar.h"

#import "CompleteViewController.h"

@interface PushUpViewController ()
{
    WQCircleProgressBar     *closedIndicator;
    
    NSInteger               count;
    NSInteger               targetNum;
    NSInteger               maxExerciseNum;
    UILabel                 *recordLabel;
    
    UIButton                *soundButton;
}

@property (nonatomic, strong) UIDevice *device;

@end

@implementation PushUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = indexBackgroundColor;
    
    //获取3个值 单次最大记录，目标数，今天的总数
    NSError *error;
    maxExerciseNum = [ExerciseCoreDataHelper getBestNumByType:ExerciseTypePushUp withError:&error];
    NSString *maxNumString = [NSString stringFromInteger:maxExerciseNum];
    targetNum = [CommonUtil getTargetNumFromType:ExerciseTypePushUp andLevel:[[AccountCoreDataHelper getDataByName:@"pushUpLevel" withError:&error] integerValue]];
    NSString *targetNumString = [NSString stringFromInteger:targetNum];
    
    //navigation bar
    UIView *navBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPCONFIG_UI_VIEW_FWIDTH, APPCONFIG_UI_STATUSBAR_HEIGHT + APPCONFIG_UI_NAVIGATIONBAR_HEIGHT)];
    navBarView.backgroundColor = pushUpColor;
    [self.view addSubview:navBarView];
    
    UILabel* titleLabel = [CommonUtil createLabelWithText:@"俯卧撑" andTextColor:[UIColor whiteColor] andFont:[UIFont boldSystemFontOfSize:20] andTextAlignment:NSTextAlignmentCenter];
    titleLabel.frame = CGRectMake((APPCONFIG_UI_SCREEN_FWIDTH - 100.f) / 2.f, APPCONFIG_UI_STATUSBAR_HEIGHT, 100, APPCONFIG_UI_NAVIGATIONBAR_HEIGHT);
    [self.view addSubview:titleLabel];
    
    //声音图标
    soundButton = [[UIButton alloc] init];
    soundButton.frame = CGRectMake(APPCONFIG_UI_SCREEN_FWIDTH - APPCONFIG_UI_VIEW_BETWEEN_PADDING - 30, 25, 30, 30);
    [soundButton setImage:[UIImage imageNamed:@"SoundEnabledIcon"] forState:UIControlStateNormal];
    [soundButton setImage:[UIImage imageNamed:@"SoundDisenabledIcon"] forState:UIControlStateSelected];
    [soundButton setImage:nil forState:UIControlStateHighlighted];
    [soundButton setImage:nil forState:UIControlStateHighlighted | UIControlStateSelected];
    [soundButton addTarget:self action:@selector(tappedSoundBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:soundButton];
    
    //今日目标
    UIView *todayTargetView = [CommonUtil createViewWithFrame:CGRectMake(APPCONFIG_UI_VIEW_BETWEEN_PADDING, APPCONFIG_UI_VIEW_BETWEEN_PADDING + APPCONFIG_UI_STATUSBAR_HEIGHT + APPCONFIG_UI_NAVIGATIONBAR_HEIGHT, 120, 30) andHasBorder:NO];
    todayTargetView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:todayTargetView];
    
    UILabel* textLabel = [CommonUtil createLabelWithText:@"今日目标" andTextColor:tipTitleLabelColor andFont:[UIFont systemFontOfSize:16]];
    textLabel.frame = CGRectMake(10, 0, 70, 30);
    [todayTargetView addSubview:textLabel];
    
    textLabel = [CommonUtil createLabelWithText:targetNumString andTextColor:tipTitleLabelColor andFont:[UIFont systemFontOfSize:18] andTextAlignment:NSTextAlignmentCenter];
    textLabel.frame = CGRectMake(80, 0, 40, 30);
    [todayTargetView addSubview:textLabel];
    
    //个人记录
    UIView *maxRecordView = [CommonUtil createViewWithFrame:CGRectMake(APPCONFIG_UI_SCREEN_FWIDTH - 120 - APPCONFIG_UI_VIEW_BETWEEN_PADDING, APPCONFIG_UI_SCREEN_FHEIGHT - APPCONFIG_UI_TABBAR_HEIGHT - APPCONFIG_UI_STATUSBAR_HEIGHT - 30 - APPCONFIG_UI_VIEW_BETWEEN_PADDING, 120, 30) andHasBorder:NO];
    maxRecordView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:maxRecordView];
    
    textLabel = [CommonUtil createLabelWithText:@"个人记录" andTextColor:tipTitleLabelColor andFont:[UIFont systemFontOfSize:16]];
    textLabel.frame = CGRectMake(10, 0, 70, 30);
    [maxRecordView addSubview:textLabel];
    
    recordLabel = [CommonUtil createLabelWithText:maxNumString andTextColor:tipTitleLabelColor andFont:[UIFont systemFontOfSize:18] andTextAlignment:NSTextAlignmentCenter];
    recordLabel.frame = CGRectMake(80, 0, 40, 30);
    [maxRecordView addSubview:recordLabel];
    
    UIButton* saveButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 63, self.view.bounds.size.width, 63)];
    [saveButton setBackgroundColor:pushUpColor];
    [saveButton addTarget:self action:@selector(tappedSaveBtn) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setTitle:@"保存并退出>" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:saveButton];
    
    float progressOriginY, progressWidth;
    if (APPCONFIG_DEVICE_OVER_IPHONE5) {
        progressOriginY = 140;
        progressWidth = 280;
    } else {
        progressOriginY = 120;
        progressWidth = 240;
    }
    
    closedIndicator = [[WQCircleProgressBar alloc]initWithFrame:CGRectMake((self.view.bounds.size.width - progressWidth)/2, progressOriginY, progressWidth, progressWidth)];
    [self.view addSubview:closedIndicator];
    
    __weak typeof(self) weakSelf = self;
    [closedIndicator setProgressDidReadyBlock:^(WQCircleProgressBar *progressBar){
        //开启距离监测传感器
        weakSelf.device = [UIDevice currentDevice];
        weakSelf.device.proximityMonitoringEnabled = true;
        [[NSNotificationCenter defaultCenter] addObserver:weakSelf selector:@selector(proximitySensorChange) name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
    }];
    [closedIndicator setStrokeColor:pushUpColor];
    [closedIndicator loadIndicator];
    
    
    count = 0;//计数器清空
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)proximitySensorChange
{
    if (_device.proximityState) {
        count++;
        [closedIndicator updateWithTotalBytes:targetNum downloadedBytes:count];
        
        if (count > maxExerciseNum) {
            maxExerciseNum = count;
            recordLabel.text = [NSString stringFromInteger:maxExerciseNum];
        }
    }
}

- (void)tappedSaveBtn
{
    _device.proximityMonitoringEnabled = false;
    
    CompleteViewController *completeVC = [[CompleteViewController alloc] init];
    completeVC.exerciseNum = count;
    completeVC.exerciseType = ExerciseTypePushUp;
    
    [self presentViewController:completeVC animated:NO completion:nil];
}

- (void)tappedSoundBtn:(UIButton *)button {
    button.selected = !button.selected;
    closedIndicator.allowSoundPlay = !button.selected;
}


@end
