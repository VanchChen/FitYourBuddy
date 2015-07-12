//
//  SettingsDetailViewController.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/7/5.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "SettingsDetailViewController.h"

@interface SettingsDetailViewController ()

@property (nonatomic, assign) DetailType type;

@end

@implementation SettingsDetailViewController

+(instancetype)createSettingsDetailWithType:(DetailType)type {
    SettingsDetailViewController *view = [[SettingsDetailViewController alloc] init];
    view.type = type;
    return view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_type == DetailTypeTeam) {
        self.title = @"团队成员";
    } else {
        self.title = @"支持我们";
    }
    
    self.view.backgroundColor = indexBackgroundColor;
    
    UIView *backgroundView = [CommonUtil createViewWithFrame:CGRectMake(20, 40, self.view.width - 40, 100)];
    backgroundView.layer.borderColor = settingBorderColor.CGColor;
    [self.view addSubview:backgroundView];
}

@end
