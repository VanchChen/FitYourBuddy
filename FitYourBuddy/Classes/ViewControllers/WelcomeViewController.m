//
//  WelcomeViewController.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/3/9.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "WelcomeViewController.h"
#import "WQCircleProgressBar.h"

#import "TarBarViewController.h"

@interface WelcomeViewController () <UITextFieldDelegate>
{
    WQCircleProgressBar     *commitProgress;    //确认圈
    NSTimer                 *timer;             //计时器
    NSInteger               timerCount;         //计时数字，数字到表示确认
    
    UIImageView             *maleImage;         //男性按钮
    UIImageView             *femaleImage;       //女性按钮
    
    UIView                  *popView;           //弹出框
    UITextField             *popViewTextField;  //弹出输入框
    
    NSString                *gender;            //性别
}

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 60)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setFont:[UIFont systemFontOfSize:50.f]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setText:@"小胖砸"];
    [titleLabel setCenter:CGPointMake(self.view.center.x, titleLabel.center.y)];
    [self.view addSubview:titleLabel];
    
    UILabel* titleHintLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 110, self.view.frame.size.width, 30)];
    [titleHintLabel setBackgroundColor:[UIColor clearColor]];
    [titleHintLabel setFont:[UIFont boldSystemFontOfSize:20.f]];
    [titleHintLabel setTextAlignment:NSTextAlignmentCenter];
    [titleHintLabel setTextColor:themeGreyColor];
    [titleHintLabel setText:@"最好玩的娱乐健身APP"];
    [titleHintLabel setCenter:CGPointMake(self.view.center.x, titleHintLabel.center.y)];
    [self.view addSubview:titleHintLabel];
    
    UILabel* genderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 30)];
    [genderLabel setBackgroundColor:[UIColor clearColor]];
    [genderLabel setFont:[UIFont systemFontOfSize:25.f]];
    [genderLabel setTextAlignment:NSTextAlignmentCenter];
    [genderLabel setText:@"请先选择性别"];
    [genderLabel setCenter:CGPointMake(self.view.center.x, genderLabel.center.y)];
    [self.view addSubview:genderLabel];
    
    maleImage = [[UIImageView alloc] initWithFrame:CGRectMake(40, 250, 110, 110)];
    [maleImage setTag:0];
    [maleImage setImage:[UIImage imageNamed:@"GenderMaleIcon.jpg"]];
    [maleImage setUserInteractionEnabled:YES];
    [[maleImage layer] setCornerRadius:20];
    [[maleImage layer] setMasksToBounds:YES];
    [self.view addSubview:maleImage];
    
    femaleImage = [[UIImageView alloc] initWithFrame:CGRectMake(160, 250, 110, 110)];
    [femaleImage setTag:1];
    [femaleImage setImage:[UIImage imageNamed:@"GenderFemaleIcon.jpg"]];
    [femaleImage setUserInteractionEnabled:YES];
    [[femaleImage layer] setCornerRadius:20];
    [[femaleImage layer] setMasksToBounds:YES];
    [self.view addSubview:femaleImage];
    
    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressed:)];
    [gesture setMinimumPressDuration:0.5];
    [maleImage addGestureRecognizer:gesture];
    
    UILongPressGestureRecognizer *gesture2 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressed:)];
    [gesture2 setMinimumPressDuration:0.5];
    [femaleImage addGestureRecognizer:gesture2];
    
    commitProgress = nil;
    gender = @"0";
}

#pragma mark - Class Extention

- (void)handleLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        if (gestureRecognizer.view.tag == 0 && maleImage.userInteractionEnabled) {
            [femaleImage setUserInteractionEnabled:NO];
            gender = @"0";
        }
        if (gestureRecognizer.view.tag == 1 && femaleImage.userInteractionEnabled) {
            [maleImage setUserInteractionEnabled:NO];
            gender = @"1";
        }
        
        if (!commitProgress) {
            commitProgress = [[WQCircleProgressBar alloc]initWithFrame:gestureRecognizer.view.bounds type:MixedIndictor];
            [commitProgress setBackgroundColor:[UIColor clearColor]];//[UIColor colorWithRed:214.f/255.f green:214.f/255.f blue:214.f/255.f alpha:0.8]
            [commitProgress setFillColor:popBackgroundColor];
            [commitProgress setStrokeColor:popBackgroundColor];
            commitProgress.radiusPercent = 0.45;
            [gestureRecognizer.view addSubview:commitProgress];
            [commitProgress loadIndicator];
            
            timerCount = 0;
            timer = [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
        }
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded || gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        if (gestureRecognizer.view.userInteractionEnabled) {
            [timer invalidate];
            [commitProgress removeFromSuperview];
            commitProgress = nil;
            timerCount = 0;
            
            [maleImage setUserInteractionEnabled:YES];
            [femaleImage setUserInteractionEnabled:YES];
        }
    }
}

- (void)handleTimer:(NSTimer *)theTimer
{
    timerCount += 1;
    
    if (timerCount == 6) {
        [timer invalidate];
        [commitProgress removeFromSuperview];
        commitProgress = nil;
        timerCount = 0;
        
        [maleImage setUserInteractionEnabled:YES];
        [femaleImage setUserInteractionEnabled:YES];
        
        //时间到，可以输入姓名
        [self showNameView];
    } else {
        [commitProgress updateWithTotalBytes:5 downloadedBytes:timerCount];
    }
}

#pragma mark - Name View

//弹出输入姓名框
- (void)showNameView
{
    UIButton *popBackgroundButton = [[UIButton alloc] initWithFrame:self.view.bounds];
    [popBackgroundButton setBackgroundColor:popBackgroundColor];
    [popBackgroundButton addTarget:self action:@selector(tappedNameViewBackground:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:popBackgroundButton];
    
    popView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(popBackgroundButton.bounds) - 40, 250)];
    popView.backgroundColor = [UIColor whiteColor];
    popView.center = popBackgroundButton.center;
    popView.layer.cornerRadius = 20;
    popView.layer.masksToBounds = YES;
    popView.layer.borderWidth = 2;
    popView.layer.borderColor = themeBlueColor.CGColor;
    [popBackgroundButton addSubview:popView];
    
    UILabel *popViewTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, CGRectGetWidth(popView.bounds) - 40, 40)];
    popViewTitleLabel.textColor = themeBlueColor;
    popViewTitleLabel.font = [UIFont boldSystemFontOfSize:25];
    popViewTitleLabel.text = @"小胖砸的名字是";
    [popView addSubview:popViewTitleLabel];
    
    popViewTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 80, CGRectGetWidth(popView.bounds) - 40, 80)];
    popViewTextField.tintColor = themeBlueColor;
    popViewTextField.layer.borderColor = themeBlueColor.CGColor;
    popViewTextField.layer.borderWidth = 2;
    popViewTextField.textColor = themeBlueColor;
    popViewTextField.font = [UIFont boldSystemFontOfSize:30];
    popViewTextField.keyboardType = UIKeyboardTypeNamePhonePad;
    popViewTextField.returnKeyType = UIReturnKeyDone;
    popViewTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    popViewTextField.delegate = self;
    [popView addSubview:popViewTextField];
    
    UIButton *popViewCommitButton = [[UIButton alloc] initWithFrame:CGRectMake(60, 180, CGRectGetWidth(popView.bounds) - 120, 40)];
    popViewCommitButton.backgroundColor = themeRedColor;
    popViewCommitButton.titleLabel.textColor = [UIColor whiteColor];
    popViewCommitButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    popViewCommitButton.layer.cornerRadius = 10;
    [popViewCommitButton setTitle:@"确定" forState:UIControlStateNormal];
    [popViewCommitButton addTarget:self action:@selector(tappedPopCommit:) forControlEvents:UIControlEventTouchUpInside];
    [popView addSubview:popViewCommitButton];
    
    [popViewTextField becomeFirstResponder];
}

//点击姓名框背景
- (void)tappedNameViewBackground:(UIButton *)sender
{
    [sender removeFromSuperview];
}

//点击确认框
- (void)tappedPopCommit:(UIButton *)sender
{
    NSError *error;
    if ([AccountCoreDataHelper initAccountWithName:popViewTextField.text andGender:gender andError:&error]) {
        //名字保存成功，跳到首页
        TarBarViewController* tabBarController = [[TarBarViewController alloc] init];
        [self presentViewController:tabBarController animated:NO completion:nil];
    }
}

#pragma mark - Text Field Delegate

//当开始点击textField会调用的方法
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = popView.frame;
    frame.origin.y = 50;
    
    [UIView animateWithDuration:0.3 animations:^{
        popView.frame = frame;
    }];
}

//当textField编辑结束时调用的方法
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 animations:^{
        popView.center = self.view.center;
    }];
}

//按下Done按钮的调用方法，我们让键盘消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    return YES;
}

@end
