//
//  SettingsDetailViewController.h
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/7/5.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

typedef NS_ENUM(NSInteger, DetailType) {
    DetailTypeTeam = 0,
    DetailTypeSupport
};

@interface SettingsDetailViewController : UIViewController

+(instancetype)createSettingsDetailWithType:(DetailType)type;

@end
