//
//  Constant.h
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/3/21.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

//UI系统库
#import <UIKit/UIKit.h>

//数据库小帮手
#import "AccountCoreDataHelper.h"
#import "ExerciseCoreDataHelper.h"

//扩展
#import "UIView+Base.h"

/** 色值 RGBA **/
#define RGB_A(r, g, b, a) [UIColor colorWithRed:(CGFloat)(r)/255.0f green:(CGFloat)(g)/255.0f blue:(CGFloat)(b)/255.0f alpha:(CGFloat)(a)]

/** 色值 RGB **/
#define RGB(r, g, b) RGB_A(r, g, b, 1)


//公用颜色值
#define themeBlueColor [UIColor colorWithRed:118.f/255.f green:214.f/255.f blue:255.f/255.f alpha:1]
#define themeRedColor [UIColor colorWithRed:255.f/255.f green:126.f/255.f blue:121.f/255.f alpha:1]
#define themeGreyColor [UIColor colorWithRed:214.f/255.f green:214.f/255.f blue:214.f/255.f alpha:1]

#define sitUpColor [UIColor colorWithRed:132.f/255.f green:110.f/255.f blue:255.f/255.f alpha:1]
#define pushUpColor [UIColor colorWithRed:255.f/255.f green:111.f/255.f blue:215.f/255.f alpha:1]
#define squatColor [UIColor colorWithRed:0/255.f green:255.f/255.f blue:149.f/255.f alpha:1]
#define walkColor [UIColor colorWithRed:255.f/255.f green:214.f/255.f blue:112.f/255.f alpha:1]

#define saveButtonGreyColor [UIColor colorWithRed:235.f/255.f green:235.f/255.f blue:235.f/255.f alpha:1]
#define saveTextGreyColor [UIColor colorWithRed:192.f/255.f green:192.f/255.f blue:192.f/255.f alpha:1]

#define popBackgroundColor [UIColor colorWithRed:214.f/255.f green:214.f/255.f blue:214.f/255.f alpha:0.8]

//UI控件常规像素
#define APPCONFIG_UI_STATUSBAR_HEIGHT       20.0f                       // 系统自带的状态条的高度
#define APPCONFIG_UI_NAVIGATIONBAR_HEIGHT   44.0f                       // 系统自带的导航条的高度
#define APPCONFIG_UI_VIEW_PADDING           20.0f                       // 默认视图边距

// UI 界面大小
#define APPCONFIG_UI_SCREEN_FHEIGHT             ([UIScreen mainScreen].bounds.size.height)              //界面的高度 iphone5 568 其他480
#define APPCONFIG_UI_SCREEN_FWIDTH              ([UIScreen mainScreen].bounds.size.width)               //界面的宽度 iphone 320
#define APPCONFIG_UI_CONTROLLER_FHEIGHT         (self.view.frame.size.height)                           //界面的高度 iphone5 548 其他460
#define APPCONFIG_UI_CONTROLLER_FWIDTH          APPCONFIG_UI_SCREEN_FWIDTH                              //界面的宽度 iphone 320
#define APPCONFIG_UI_VIEW_FHEIGHT               (self.frame.size.height)                                //界面的高度 iphone5 548 其他460
#define APPCONFIG_UI_VIEW_FWIDTH                APPCONFIG_UI_SCREEN_FWIDTH                              //界面的宽度 iphone 320
#define APPCONFIG_UI_SCREEN_SIZE                ([UIScreen mainScreen].bounds.size)         //屏幕大小

#define APPCONFIG_VERSION_OVER_5                 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0f)
#define APPCONFIG_VERSION_OVER_6                 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0f)
#define APPCONFIG_VERSION_OVER_7                 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f)
#define APPCONFIG_VERSION_OVER_8                 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f)

#define APPCONFIG_UNIT_LINE_WIDTH                (1/[UIScreen mainScreen].scale)       //常用线宽

// 判断是否是iPhone5以上的设备，区分iPhone4
#define APPCONFIG_DEVICE_OVER_IPHONE5           (APPCONFIG_UI_SCREEN_FHEIGHT >= 568.0f)
