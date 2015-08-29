//
//  SitUpViewController.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/2/25.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "SitUpViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface SitUpViewController ()

@property (nonatomic, strong) CMMotionManager           *wqMotionManager;

@end

@implementation SitUpViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.exerciseType = ExerciseTypeSitUp;
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"仰卧起坐"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"仰卧起坐"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
    __weak typeof(self) weakSelf = self;
    [self.closedIndicator setProgressDidReadyBlock:^(WQCircleProgressBar *progressBar){
        [weakSelf addPanGesture];
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
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    //针对低版本宽高不分的处理
    CGFloat realWidth, realHeight;
    if (self.view.width > self.view.height) {
        realWidth = APPCONFIG_UI_VIEW_FWIDTH;
        realHeight = APPCONFIG_UI_SCREEN_FHEIGHT;
    } else {
        realWidth = APPCONFIG_UI_SCREEN_FHEIGHT;
        realHeight = APPCONFIG_UI_VIEW_FWIDTH;
    }
    
    self.navBarView.frame = CGRectMake(0, 0, realWidth, APPCONFIG_UI_NAVIGATIONBAR_HEIGHT);
    
    self.titleLabel.frame = CGRectMake((realWidth - 100) / 2.0f, 0, 100, APPCONFIG_UI_NAVIGATIONBAR_HEIGHT);
    
    self.soundButton.frame = CGRectMake(realWidth - APPCONFIG_UI_VIEW_PADDING - 30, 7, 30, 30);
    
    self.todayTargetView.frame = CGRectMake(APPCONFIG_UI_VIEW_BETWEEN_PADDING, APPCONFIG_UI_VIEW_BETWEEN_PADDING + APPCONFIG_UI_NAVIGATIONBAR_HEIGHT, 120, 30);
    
    [self.closedIndicator changeFrame:CGRectMake((realWidth - 220)/2, 50, 220, 220)];
    
    self.maxRecordView.frame = CGRectMake(realWidth - 120 - APPCONFIG_UI_VIEW_BETWEEN_PADDING, realHeight - APPCONFIG_UI_TABBAR_HEIGHT - 30 - APPCONFIG_UI_VIEW_BETWEEN_PADDING, 120, 30);
    self.saveButton.frame = CGRectMake(0, realHeight - 39, realWidth, 39);
    self.coverView.frame = self.view.bounds;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (void)tappedSaveBtn
{
    [_wqMotionManager stopDeviceMotionUpdates];
    
    CompleteViewController *completeVC = [[CompleteViewController alloc] init];
    completeVC.exerciseNum = self.count;
    completeVC.exerciseType = ExerciseTypeSitUp;
    
    [self presentViewController:completeVC animated:NO completion:nil];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

- (double)magnitudeFromAttitude:(CMAttitude *)attitude
{
    return sqrt(pow(attitude.roll, 2) + pow(attitude.yaw, 2) + pow(attitude.pitch, 2));
}

@end
