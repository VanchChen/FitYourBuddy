//
//  WelcomeViewController.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/3/9.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "WelcomeViewController.h"

#import "TarBarViewController.h"

//性别
typedef NS_ENUM(NSInteger, GenderType) {
    Boy  = 0,
    Girl = 1
};

//常量
static CGFloat const TitleLabelTopPadding = 60.0f;
static CGFloat const TitleLabelWidth = 60.0f;
static CGFloat const ContentViewHeight = 200.0f;
static CGFloat const GenderLabelHeight = 30.0f;
static CGFloat const GenderButtonTopPadding = 20.0f;
static CGFloat const GenderButtonLeftPadding = 40.0f;
static CGFloat const GenderButtonWidth = 110.0f;
static CGFloat const GenderExplainLabelTopPadding = 10.0f;
static CGFloat const GenderExplainLabelHeight = 20.0f;
static CGFloat const AccountButtonHeight = 20.0f;
static CGFloat const AccountButtonWidth = 200.0f;
static CGFloat const AccountButtonBottomPadding = 40.0f;

@interface WelcomeViewController () <UITextFieldDelegate>
{
    UIView                  *popView;           //弹出框
    UITextField             *popViewTextField;  //弹出输入框
    
    GenderType              gender;            //性别
}

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, TitleLabelTopPadding, APPCONFIG_UI_SCREEN_FWIDTH, TitleLabelWidth)];
    [titleLabel setFont:[UIFont systemFontOfSize:30.f]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setText:@"快来创造小胖砸！"];
    [titleLabel setCenter:CGPointMake(self.view.center.x, titleLabel.center.y)];
    [self.view addSubview:titleLabel];
    
    //居中一个内容框
    UIView *contentView = [[UIView alloc] init];
    contentView.frame = CGRectMake(0, 0, APPCONFIG_UI_SCREEN_FWIDTH, ContentViewHeight);
    contentView.center = self.view.center;
    [self.view addSubview:contentView];
    
    UILabel* genderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, APPCONFIG_UI_SCREEN_FWIDTH, GenderLabelHeight)];
    [genderLabel setFont:[UIFont systemFontOfSize:25.f]];
    [genderLabel setTextAlignment:NSTextAlignmentCenter];
    [genderLabel setText:@"我是..."];
    [contentView addSubview:genderLabel];
    //男女按钮
    UIButton *maleImage = [[UIButton alloc] initWithFrame:CGRectMake(GenderButtonLeftPadding, 0, GenderButtonWidth, GenderButtonWidth)];
    [maleImage setTag:Boy];
    [maleImage setBackgroundImage:[UIImage imageNamed:@"GenderMaleIcon.jpg"] forState:UIControlStateNormal];
    [maleImage addTarget:self action:@selector(showNameView:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:maleImage];
    
    UIButton *femaleImage = [[UIButton alloc] initWithFrame:CGRectMake(APPCONFIG_UI_SCREEN_FWIDTH - GenderButtonLeftPadding - GenderButtonWidth, 0, GenderButtonWidth, GenderButtonWidth)];
    [femaleImage setTag:Girl];
    [femaleImage setBackgroundImage:[UIImage imageNamed:@"GenderFemaleIcon.jpg"] forState:UIControlStateNormal];
    [femaleImage addTarget:self action:@selector(showNameView:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:femaleImage];
    
    [maleImage bottomOfView:genderLabel withMargin:GenderButtonTopPadding];
    [femaleImage bottomOfView:genderLabel withMargin:GenderButtonTopPadding];
    
    //男女解释
    UILabel *maleLabel = [[UILabel alloc] init];
    maleLabel.frame = CGRectMake(GenderButtonLeftPadding, 0, GenderButtonWidth, GenderExplainLabelHeight);
    maleLabel.font = [UIFont systemFontOfSize:16.f];
    maleLabel.textColor = themeBlueColor;
    [maleLabel setTextAlignment:NSTextAlignmentCenter];
    [maleLabel setText:@"男生"];
    [contentView addSubview:maleLabel];
    
    UILabel *femaleLabel = [[UILabel alloc] init];
    femaleLabel.frame = CGRectMake(APPCONFIG_UI_SCREEN_FWIDTH - GenderButtonLeftPadding - GenderButtonWidth, 0, GenderButtonWidth, GenderExplainLabelHeight);
    femaleLabel.font = [UIFont systemFontOfSize:16.f];
    femaleLabel.textColor = themeRedColor;
    [femaleLabel setTextAlignment:NSTextAlignmentCenter];
    [femaleLabel setText:@"女生"];
    [contentView addSubview:femaleLabel];
    
    [maleLabel bottomOfView:maleImage withMargin:GenderExplainLabelTopPadding];
    [femaleLabel bottomOfView:maleImage withMargin:GenderExplainLabelTopPadding];
    
    //已有账号
    UIButton *accountButton = [[UIButton alloc] init];
    [accountButton setAttributedTitle:[@"已有账号，请直接登录>" bottomLineString] forState:UIControlStateNormal];
    accountButton.frame = CGRectMake(0, APPCONFIG_UI_SCREEN_FHEIGHT - AccountButtonBottomPadding - AccountButtonHeight, AccountButtonWidth, AccountButtonHeight);
    [accountButton centerOfView:self.view];
    [self.view addSubview:accountButton];
}

#pragma mark - Name View

//弹出输入姓名框
- (void)showNameView:(UIButton *)button
{
    gender = [button tag];//记录性别
    //先来个背景返回
    UIButton *popBackgroundButton = [[UIButton alloc] initWithFrame:self.view.bounds];
    [popBackgroundButton setBackgroundColor:popBackgroundColor];
    [popBackgroundButton addTarget:self action:@selector(tappedNameViewBackground:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:popBackgroundButton];
    
    popView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(popBackgroundButton.bounds) - 40, 160)];
    popView.backgroundColor = themeBlueColor;
    popView.center = popBackgroundButton.center;
    popView.layer.cornerRadius = 16;
    popView.layer.masksToBounds = YES;
    [popBackgroundButton addSubview:popView];
    
    UILabel *popViewTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, CGRectGetWidth(popView.bounds) - 40, 40)];
    popViewTitleLabel.textColor = [UIColor whiteColor];
    popViewTitleLabel.font = [UIFont boldSystemFontOfSize:18];
    popViewTitleLabel.text = @"我的名字是...";
    [popView addSubview:popViewTitleLabel];
    
    popViewTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 60, CGRectGetWidth(popView.bounds) - 40, 40)];
    popViewTextField.backgroundColor = [UIColor whiteColor];
    popViewTextField.tintColor = [UIColor blackColor];
    popViewTextField.textColor = [UIColor blackColor];
    popViewTextField.font = [UIFont boldSystemFontOfSize:20];
    popViewTextField.keyboardType = UIKeyboardTypeNamePhonePad;
    popViewTextField.returnKeyType = UIReturnKeyDone;
    popViewTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    popViewTextField.delegate = self;
    [popView addSubview:popViewTextField];
    
    UIButton *popViewCommitButton = [[UIButton alloc] initWithFrame:CGRectMake(60, 113, CGRectGetWidth(popView.bounds) - 120, 34)];
    popViewCommitButton.backgroundColor = themeOrangeColor;
    popViewCommitButton.titleLabel.textColor = [UIColor whiteColor];
    popViewCommitButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
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
    NSString *name = popViewTextField.text;
    name = [name trim];
    if (!name && name.length == 0) {//没输入名字
        return;
    }
    if (name.length > 10) {//名字太长
        return;
    }
    
    NSError *error;
    if ([AccountCoreDataHelper initAccountWithName:popViewTextField.text andGender:[NSString stringWithFormat:@"%ld", (unsigned long)gender] andError:&error]) {
        //名字保存成功，跳到首页
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
        
        TarBarViewController* tabBarController = [[TarBarViewController alloc] init];
        [self presentViewController:tabBarController animated:NO completion:nil];
    }
}

#pragma mark - Text Field Delegate

//当开始点击textField会调用的方法
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = popView.frame;
    frame.origin.y = 80;
    
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

//强制竖屏
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
