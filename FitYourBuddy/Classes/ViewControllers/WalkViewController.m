//
//  WalkViewController.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/2/25.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "WalkViewController.h"
#import "EBStepManager.h"

@interface WalkViewController ()

@end

@implementation WalkViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.exerciseType = ExerciseTypeWalk;
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"步行"];
    
    //[[EBStepManager sharedManager] stopStepCounting];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"步行"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.soundButton.hidden = YES;
    
    __weak typeof(self) weakSelf = self;
    [self.closedIndicator setProgressDidReadyBlock:^(WQCircleProgressBar *progressBar){
        progressBar.allowSoundPlay = NO;
        [weakSelf addPanGesture];
        //开启运动检测
        [[EBStepManager sharedManager] startStepCounting:^(NSInteger numberOfSteps,
                                                           NSDate *timestamp,
                                                           NSError *error) {
            if (error) {
                NSLog(@"error: %@", error);
            }else {
                weakSelf.count = numberOfSteps;
                [progressBar updateWithTotalBytes:weakSelf.targetNum downloadedBytes:numberOfSteps];
            }
        }];
    }];
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)tappedSaveBtn
{
    [[EBStepManager sharedManager] stopStepCounting];
    
    CompleteViewController *completeVC = [[CompleteViewController alloc] init];
    if (self.count > 100000 || self.count < 0) {
        self.count = 0;
    }
    completeVC.exerciseNum = self.count;
    completeVC.exerciseType = ExerciseTypeWalk;
    
    [self presentViewController:completeVC animated:NO completion:nil];
}

@end
