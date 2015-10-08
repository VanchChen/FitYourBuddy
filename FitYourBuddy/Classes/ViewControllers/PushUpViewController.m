//
//  PushUpViewController.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/2/24.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "PushUpViewController.h"

@interface PushUpViewController ()

@property (nonatomic, strong) UIDevice      *device;

@end

@implementation PushUpViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.exerciseType = ExerciseTypePushUp;
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"俯卧撑"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"俯卧撑"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tutBtn setMinY:APPCONFIG_UI_STATUSBAR_HEIGHT];
    
    __weak typeof(self) weakSelf = self;
    [self.closedIndicator setProgressDidReadyBlock:^(WQCircleProgressBar *progressBar){
        [weakSelf addPanGesture];
        //开启距离监测传感器
        weakSelf.device = [UIDevice currentDevice];
        weakSelf.device.proximityMonitoringEnabled = true;
        [[NSNotificationCenter defaultCenter] addObserver:weakSelf selector:@selector(proximitySensorChange) name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
    }];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)proximitySensorChange
{
    if (_device.proximityState) {
        self.count++;
        [self.closedIndicator updateWithTotalBytes:self.targetNum downloadedBytes:self.count];
        
        if (self.count > self.maxExerciseNum) {
            self.maxExerciseNum = self.count;
            self.recordLabel.text = [NSString stringFromInteger:self.maxExerciseNum];
        }
    }
}

- (void)tappedSaveBtn
{
    _device.proximityMonitoringEnabled = false;
    
    CompleteViewController *completeVC = [[CompleteViewController alloc] init];
    completeVC.exerciseNum = self.count;
    completeVC.exerciseType = ExerciseTypePushUp;
    
    [self presentViewController:completeVC animated:NO completion:nil];
}

@end
