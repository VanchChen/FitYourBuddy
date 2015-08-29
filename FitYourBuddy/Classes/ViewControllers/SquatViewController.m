//
//  SquatViewController.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/2/25.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "SquatViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface SquatViewController ()

@property (nonatomic, strong) CMMotionManager           *wqMotionManager;

@end

@implementation SquatViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.exerciseType = ExerciseTypeSquat;
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"深蹲"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"深蹲"];
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
            [weakSelf.wqMotionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
                
                //NSLog(@"%f %f %f", round(motion.gravity.x * 10) / 10, round(motion.gravity.y * 10 / 10), round(motion.gravity.z * 10) / 10);
                //NSLog(@"%f %f %f", motion.userAcceleration.x, motion.userAcceleration.y, motion.userAcceleration.z);
                //NSLog(@"%.1f %.1f %.1f", motion.userAcceleration.x, motion.userAcceleration.y, motion.userAcceleration.z);
                
                //            float f = motion.gravity.x, gx,gy,gz,ax,ay,az;
                //            if (f > -0.1 && f < 0.1) gx = 0; else gx = f;
                //            f = motion.gravity.y;
                //            if (f > -0.1 && f < 0.1) gy = 0; else gy = f;
                //            f = motion.gravity.z;
                //            if (f > -0.1 && f < 0.1) gz = 0; else gz = f;
                //
                //            f = fabs(motion.userAcceleration.x);
                //            if (f >= 0.1) ax = f; else ax = 0;
                //            f = fabs(motion.userAcceleration.y);
                //            if (f >= 0.1) ay = f; else ay = 0;
                //            f = fabs(motion.userAcceleration.z);
                //            if (f >= 0.1) az = f; else az = 0;
                //
                //            NSLog(@"%.1f %.1f %.1f", gx, gy, gz);
                
                //            if(fabs(motion.userAcceleration.x)>1.3f)
                //                NSLog(@"x:%.2f" ,motion.userAcceleration.x);
                //            if(fabs(motion.userAcceleration.y)>1.3f)
                //                NSLog(@"y:%.2f" ,motion.userAcceleration.y);
                //            if(fabs(motion.userAcceleration.z)>1.3f)
                //                NSLog(@"z:%.2f" ,motion.userAcceleration.z);
                
                NSLog(@"%.2f", motion.userAcceleration.x);
                
                if (!isStart && motion.userAcceleration.x < -0.5) { //
                    isStart = true;
                    weakSelf.count++;
                    [weakSelf.closedIndicator updateWithTotalBytes:weakSelf.targetNum downloadedBytes:weakSelf.count];
                }
                
                if (isStart && motion.userAcceleration.x > 0) { //
                    isStart = false;
                }
                
                
                //NSLog(@"%.1f %.1f %.1f", ax, ay, az);
                
                //double re = gx * ax + gy * ay + gz * az;
                
                //double re = motion.userAcceleration.x * motion.gravity.x + motion.userAcceleration.y * motion.gravity.y + motion.userAcceleration.z * motion.gravity.z;
                //NSLog(@"%.2f", re);
                //            if (re > 2.0f) {
                //                NSLog(@"11111");
                //            }
                //            if (re < -2.0f) {
                //                NSLog(@"22222");
                //            }
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
    completeVC.exerciseType = ExerciseTypeSquat;
    
    [self presentViewController:completeVC animated:NO completion:nil];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

@end
