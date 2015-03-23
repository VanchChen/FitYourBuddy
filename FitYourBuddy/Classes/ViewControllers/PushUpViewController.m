//
//  PushUpViewController.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/2/24.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "PushUpViewController.h"
#import "WQCircleProgressBar.h"
#import "SoundTool.h"

#import "CompleteViewController.h"

@interface PushUpViewController ()
{
    UIDevice                *device;
    UILabel                 *progressLabel;
    WQCircleProgressBar     *closedIndicator;
    
    NSInteger               count;
    
    NSArray                 *soundArray;
    NSUInteger              soundIndex;
}

@end

@implementation PushUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = themeBlueColor;
    
    //获取3个值 单次最大记录，目标数，今天的总数
    NSError *error;
    NSInteger maxExerciseNum = [ExerciseCoreDataHelper getBestNumByType:ExerciseTypePushUp withError:&error];
    NSString *maxNumString = [NSString stringWithFormat:@"%ld", (long)maxExerciseNum];
    NSInteger targetNum = [[AccountCoreDataHelper getDataByName:@"pushUpLevel" withError:&error] integerValue] - 1 + 10;
    NSString *targetNumString = [NSString stringWithFormat:@"%ld", (long)targetNum];
    
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 15, 100, 44)];
    [titleLabel setText:@"俯卧撑"];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [self.view addSubview:titleLabel];
    
    UIView* ballon = [[UIView alloc] initWithFrame:CGRectMake(110, 15 + 10, 24, 24)];
    [ballon setBackgroundColor:pushUpColor];
    [[ballon layer] setCornerRadius:12];
    [self.view addSubview:ballon];
    
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, 63, self.view.bounds.size.width, 1)];
    [line setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:line];
    
    UILabel* textLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 64 + 5, 80, 30)];
    [textLabel setText:@"今日目标"];
    [textLabel setTextColor:[UIColor whiteColor]];
    [textLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [self.view addSubview:textLabel];
    
    textLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 64 + 5, 50, 30)];
    [textLabel setTextColor:themeRedColor];
    [textLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [textLabel setText:targetNumString];
    [self.view addSubview:textLabel];
    
    textLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 120, self.view.bounds.size.height - 64 - 40, 80, 40)];
    [textLabel setText:@"个人记录"];
    [textLabel setTextColor:[UIColor whiteColor]];
    [textLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [self.view addSubview:textLabel];
    
    textLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 40, self.view.bounds.size.height - 64 - 40, 40, 40)];
    [textLabel setTextColor:[UIColor whiteColor]];
    [textLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [textLabel setText:maxNumString];
    [self.view addSubview:textLabel];
    
    line = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 64, self.view.bounds.size.width, 1)];
    [line setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:line];
    
    UIButton* saveButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 63, self.view.bounds.size.width, 63)];
    [saveButton setBackgroundColor:saveButtonGreyColor];
    [saveButton addTarget:self action:@selector(tappedSaveBtn) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setTitle:@"保存并退出" forState:UIControlStateNormal];
    [saveButton setTitleColor:saveTextGreyColor forState:UIControlStateNormal];
    [self.view addSubview:saveButton];
    
    float progressOriginY, progressWidth;
    if (APPCONFIG_DEVICE_OVER_IPHONE5) {
        progressOriginY = 140;
        progressWidth = 280;
    } else {
        progressOriginY = 120;
        progressWidth = 240;
    }
    
    closedIndicator = [[WQCircleProgressBar alloc]initWithFrame:CGRectMake((self.view.bounds.size.width - progressWidth)/2, progressOriginY, progressWidth, progressWidth) type:ClosedIndicator];
    [closedIndicator setBackgroundColor:[UIColor clearColor]];
    [closedIndicator setFillColor:themeRedColor];
    [closedIndicator setStrokeColor:themeRedColor];
    [self.view addSubview:closedIndicator];
    [closedIndicator loadIndicator];
    
    progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 80)];
    [progressLabel setTextColor:[UIColor whiteColor]];
    [progressLabel setFont:[UIFont boldSystemFontOfSize:80]];
    [progressLabel setTextAlignment:NSTextAlignmentCenter];
    [progressLabel setText:@"0"];
    [progressLabel setCenter:closedIndicator.center];
    [self.view addSubview:progressLabel];
    
    textLabel = [[UILabel alloc] initWithFrame:CGRectMake(progressLabel.frame.origin.x, progressLabel.frame.origin.y - 30, 100, 30)];
    [textLabel setText:@"已完成"];
    [textLabel setTextColor:[UIColor whiteColor]];
    [textLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [textLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:textLabel];
    
    soundArray = [[NSArray alloc] initWithObjects:@"c4",@"c4",@"g4",@"g4",@"a4",@"a4",@"g4",@"",@"f4",@"f4",@"e4",@"e4",@"d4",@"d4",@"c4",@"", nil];
    soundIndex = 0;
    
    //开启距离监测传感器
    device = [UIDevice currentDevice];
    device.proximityMonitoringEnabled = true;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(proximitySensorChange) name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
    count = 0;//计数器清空
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)proximitySensorChange
{
    if (device.proximityState) {
        count++;
        [closedIndicator updateWithTotalBytes:20 downloadedBytes:count];
        [progressLabel setText:[NSString stringWithFormat:@"%ld", (long)count]];
        
        //播放声音
        [SoundTool playsound:[soundArray objectAtIndex:soundIndex]];
        soundIndex ++;
        if (soundIndex == [soundArray count]) soundIndex = 0;
    }
}

- (void)tappedSaveBtn
{
    device.proximityMonitoringEnabled = false;
    
    CompleteViewController *completeVC = [[CompleteViewController alloc] init];
    completeVC.exerciseNum = count;
    completeVC.exerciseType = ExerciseTypePushUp;
    
    [self presentViewController:completeVC animated:NO completion:nil];
}


@end
