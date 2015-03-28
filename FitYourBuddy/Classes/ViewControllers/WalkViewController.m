//
//  WalkViewController.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/2/25.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "WalkViewController.h"
#import "WQCircleProgressBar.h"
//#import "SoundTool.h"
#import "EBStepManager.h"

#import "CompleteViewController.h"

@interface WalkViewController ()
{
    UILabel                 *progressLabel;
    WQCircleProgressBar     *closedIndicator;
    
    
    NSInteger               targetNum;
    NSInteger               maxExerciseNum;
    UILabel                 *recordLabel;
    
    //UIButton                *soundButton;
    //NSArray                 *soundArray;
    //NSUInteger              soundIndex;
}

@end

@implementation WalkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = indexBackgroundColor;
    
    //获取3个值 单次最大记录，目标数，今天的总数
    NSError *error;
    maxExerciseNum = [ExerciseCoreDataHelper getBestNumByType:ExerciseTypeWalk withError:&error];
    NSString *maxNumString = [NSString getFromInteger:maxExerciseNum];
    targetNum = ([[AccountCoreDataHelper getDataByName:@"walkLevel" withError:&error] integerValue] - 1) * 100 + 1000;
    NSString *targetNumString = [NSString getFromInteger:targetNum];
    
    //navigation bar
    UIView *navBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPCONFIG_UI_VIEW_FWIDTH, APPCONFIG_UI_STATUSBAR_HEIGHT + APPCONFIG_UI_NAVIGATIONBAR_HEIGHT)];
    navBarView.backgroundColor = walkColor;
    [self.view addSubview:navBarView];
    
    UILabel* titleLabel = [CommonUtil createLabelWithText:@"步行" andTextColor:[UIColor whiteColor] andFont:[UIFont boldSystemFontOfSize:20] andTextAlignment:NSTextAlignmentCenter];
    titleLabel.frame = CGRectMake((APPCONFIG_UI_SCREEN_FWIDTH - 100.f) / 2.f, APPCONFIG_UI_STATUSBAR_HEIGHT, 100, APPCONFIG_UI_NAVIGATIONBAR_HEIGHT);
    [self.view addSubview:titleLabel];
    
    //声音图标
//    soundButton = [[UIButton alloc] init];
//    soundButton.frame = CGRectMake(APPCONFIG_UI_SCREEN_FWIDTH - APPCONFIG_UI_VIEW_BETWEEN_PADDING - 30, 25, 30, 30);
//    [soundButton setImage:[UIImage imageNamed:@"SoundEnabledIcon"] forState:UIControlStateNormal];
//    [soundButton setImage:nil forState:UIControlStateHighlighted];
//    [soundButton setImage:[UIImage imageNamed:@"SoundDisenabledIcon"] forState:UIControlStateSelected];
//    [soundButton addTarget:self action:@selector(tappedSoundBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:soundButton];
    
    //今日目标
    UIView *todayTargetView = [CommonUtil createViewWithFrame:CGRectMake(APPCONFIG_UI_VIEW_BETWEEN_PADDING, APPCONFIG_UI_VIEW_BETWEEN_PADDING + APPCONFIG_UI_STATUSBAR_HEIGHT + APPCONFIG_UI_NAVIGATIONBAR_HEIGHT, 120, 30) andHasBorder:NO];
    [self.view addSubview:todayTargetView];
    
    UILabel* textLabel = [CommonUtil createLabelWithText:@"今日目标" andTextColor:tipTitleLabelColor andFont:[UIFont systemFontOfSize:14]];
    textLabel.frame = CGRectMake(10, 0, 70, 30);
    [todayTargetView addSubview:textLabel];
    
    textLabel = [CommonUtil createLabelWithText:targetNumString andTextColor:tipTitleLabelColor andFont:[UIFont systemFontOfSize:16] andTextAlignment:NSTextAlignmentCenter];
    textLabel.frame = CGRectMake(70, 0, 50, 30);
    [todayTargetView addSubview:textLabel];
    
    //个人记录
    UIView *maxRecordView = [CommonUtil createViewWithFrame:CGRectMake(APPCONFIG_UI_SCREEN_FWIDTH - 120 - APPCONFIG_UI_VIEW_BETWEEN_PADDING, APPCONFIG_UI_SCREEN_FHEIGHT - APPCONFIG_UI_TABBAR_HEIGHT - APPCONFIG_UI_STATUSBAR_HEIGHT - 30 - APPCONFIG_UI_VIEW_BETWEEN_PADDING, 120, 30) andHasBorder:NO];
    [self.view addSubview:maxRecordView];
    
    textLabel = [CommonUtil createLabelWithText:@"个人记录" andTextColor:tipTitleLabelColor andFont:[UIFont systemFontOfSize:16]];
    textLabel.frame = CGRectMake(10, 0, 70, 30);
    [maxRecordView addSubview:textLabel];
    
    recordLabel = [CommonUtil createLabelWithText:maxNumString andTextColor:tipTitleLabelColor andFont:[UIFont systemFontOfSize:18] andTextAlignment:NSTextAlignmentCenter];
    recordLabel.frame = CGRectMake(80, 0, 40, 30);
    [maxRecordView addSubview:recordLabel];
    
    UIButton* saveButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 63, self.view.bounds.size.width, 63)];
    [saveButton setBackgroundColor:walkColor];
    [saveButton addTarget:self action:@selector(tappedSaveBtn) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setTitle:@"保存并退出" forState:UIControlStateNormal];
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
    
    closedIndicator = [[WQCircleProgressBar alloc]initWithFrame:CGRectMake((self.view.bounds.size.width - progressWidth)/2, progressOriginY, progressWidth, progressWidth) type:ClosedIndicator];
    [closedIndicator setBackgroundColor:[UIColor clearColor]];
    [closedIndicator setFillColor:themeRedColor];
    [closedIndicator setStrokeColor:themeRedColor];
    [self.view addSubview:closedIndicator];
    [closedIndicator loadIndicator];
    
    progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 80)];
    [progressLabel setTextColor:tipTitleLabelColor];
    [progressLabel setFont:[UIFont boldSystemFontOfSize:80]];
    [progressLabel setTextAlignment:NSTextAlignmentCenter];
    [progressLabel setText:@"0"];
    [progressLabel setCenter:closedIndicator.center];
    [self.view addSubview:progressLabel];
    
    textLabel = [[UILabel alloc] initWithFrame:CGRectMake(progressLabel.frame.origin.x, progressLabel.frame.origin.y - 30, 100, 30)];
    [textLabel setText:@"已完成"];
    [textLabel setTextColor:tipTitleLabelColor];
    [textLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [textLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:textLabel];
    
    //soundArray = [[NSArray alloc] initWithObjects:@"c4",@"d4",@"e4",@"g4",@"a4",@"c5",@"a4",@"g4",@"e4",@"d4", nil];
    //soundIndex = 0;
    
    //开启运动检测
    [[EBStepManager sharedManager] startStepCounting:^(NSInteger numberOfSteps,
                                                       NSDate *timestamp,
                                                       NSError *error) {
        if (error) {
            NSLog(@"error: %@", error);
        }else {
            [progressLabel setText:[NSString stringWithFormat:@"%ld", (long)numberOfSteps]];
            [closedIndicator updateWithTotalBytes:targetNum downloadedBytes:numberOfSteps];
            
            //播放声音
//            if (!soundButton.selected) {
//                [SoundTool playsound:[soundArray objectAtIndex:soundIndex]];
//                soundIndex ++;
//                if (soundIndex == [soundArray count]) soundIndex = 0;
//            }
        }
    }];
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)tappedSaveBtn
{
    [[EBStepManager sharedManager]  stopStepCounting];
    
    CompleteViewController *completeVC = [[CompleteViewController alloc] init];
    NSInteger count = (NSInteger)progressLabel.text;
    if (count > 100000 || count < 0) {
        count = 0;
    }
    completeVC.exerciseNum = count;
    completeVC.exerciseType = ExerciseTypeWalk;
    
    [self presentViewController:completeVC animated:NO completion:nil];
}

//- (void)tappedSoundBtn:(UIButton *)button {
//    button.selected = !button.selected;
//}

@end
