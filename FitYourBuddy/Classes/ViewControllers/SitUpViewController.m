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
    UILabel                 *progressLabel;
    WQCircleProgressBar     *closedIndicator;
    CMMotionManager         *wqMotionManager;
    
    NSArray                 *soundArray;
    NSUInteger              soundIndex;
}

@end

@implementation SitUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = themeBlueColor;
    
    float totalWidth = self.view.bounds.size.height, totalHeight = self.view.bounds.size.width;
    //float totalWidth = self.view.bounds.size.width, totalHeight = self.view.bounds.size.height;
    
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(totalWidth / 2 - 10, 0, 100, 44)];
    [titleLabel setText:@"仰卧起坐"];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [self.view addSubview:titleLabel];
    
    UIView* ballon = [[UIView alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x - 34, 10, 24, 24)];
    [ballon setBackgroundColor:sitUpColor];
    [[ballon layer] setCornerRadius:12];
    [self.view addSubview:ballon];
    
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, 43, totalWidth, 1)];
    [line setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:line];
    
    UILabel* textLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 44 + 5, 80, 30)];
    [textLabel setText:@"今日目标"];
    [textLabel setTextColor:[UIColor whiteColor]];
    [textLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [self.view addSubview:textLabel];
    
    textLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 44 + 5, 50, 30)];
    [textLabel setTextColor:themeRedColor];
    [textLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [textLabel setText:@"20"];
    [self.view addSubview:textLabel];
    
    textLabel = [[UILabel alloc] initWithFrame:CGRectMake(totalWidth - 120, totalHeight - 40 - 40, 80, 40)];
    [textLabel setText:@"个人记录"];
    [textLabel setTextColor:[UIColor whiteColor]];
    [textLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [self.view addSubview:textLabel];
    
    textLabel = [[UILabel alloc] initWithFrame:CGRectMake(totalWidth - 40, totalHeight - 40 - 40, 40, 40)];
    [textLabel setTextColor:[UIColor whiteColor]];
    [textLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [textLabel setText:@"40"];
    [self.view addSubview:textLabel];
    
    line = [[UIView alloc] initWithFrame:CGRectMake(0, totalHeight - 40, totalWidth, 1)];
    [line setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:line];
    
    UIButton* saveButton = [[UIButton alloc] initWithFrame:CGRectMake(0, totalHeight - 39, totalWidth, 39)];
    [saveButton setBackgroundColor:saveButtonGreyColor];
    [saveButton addTarget:self action:@selector(tappedSaveBtn) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setTitle:@"保存并退出" forState:UIControlStateNormal];
    [saveButton setTitleColor:saveTextGreyColor forState:UIControlStateNormal];
    [self.view addSubview:saveButton];
    
    closedIndicator = [[WQCircleProgressBar alloc]initWithFrame:CGRectMake((totalWidth - 200)/2, 60, 200, 200) type:ClosedIndicator];
    [closedIndicator setBackgroundColor:[UIColor clearColor]];
    [closedIndicator setFillColor:themeRedColor];
    [closedIndicator setStrokeColor:themeRedColor];
    [self.view addSubview:closedIndicator];
    [closedIndicator loadIndicator];
    
    progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 80)];
    [progressLabel setTextColor:[UIColor whiteColor]];
    [progressLabel setFont:[UIFont boldSystemFontOfSize:60]];
    [progressLabel setTextAlignment:NSTextAlignmentCenter];
    [progressLabel setText:@"0"];
    [progressLabel setCenter:closedIndicator.center];
    [self.view addSubview:progressLabel];
    
    textLabel = [[UILabel alloc] initWithFrame:CGRectMake(progressLabel.frame.origin.x, progressLabel.frame.origin.y - 20, 100, 30)];
    [textLabel setText:@"已完成"];
    [textLabel setTextColor:[UIColor whiteColor]];
    [textLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [textLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:textLabel];
    
    soundArray = [[NSArray alloc] initWithObjects:@"c4",@"c4",@"g4",@"g4",@"a4",@"a4",@"g4",@"",@"f4",@"f4",@"e4",@"e4",@"d4",@"d4",@"c4",@"", nil];
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
//                [SoundTool playsound:[soundArray objectAtIndex:soundIndex]];
//                soundIndex ++;
//                if (soundIndex == [soundArray count]) soundIndex = 0;
            }
            
            if (isStart && motion.attitude.roll < - 2) {
                isStart = false;
            }
        }];
        
    } else {
        NSLog(@"并没有加速计");
    }
}

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

- (double)magnitudeFromAttitude:(CMAttitude *)attitude
{
    return sqrt(pow(attitude.roll, 2) + pow(attitude.yaw, 2) + pow(attitude.pitch, 2));
}

@end
