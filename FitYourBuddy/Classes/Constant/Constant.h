//
//  Constant.h
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/3/21.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

//UI系统库
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

//基础类
#import "BaseViewController.h"

//数据库小帮手
#import "AccountCoreDataHelper.h"
#import "ExerciseCoreDataHelper.h"
#import "StoreCoreDataHelper.h"

//扩展
#import "CommonUtil.h"
#import "NSString+Base.h"
#import "NSDate+Base.h"
#import "UIView+Base.h"
#import "UIImage+Base.h"

//友盟
#import "MobClick.h"

/** 单例模式：声明 */
#define SINGLETON_DEFINE(_class_name_)  \
+ (_class_name_ *)shared##_class_name_;          \

/** 单例模式：实现 */
#define SINGLETON_IMPLEMENT(_class_name) SINGLETON_BOILERPLATE(_class_name, shared##_class_name)

#define SINGLETON_BOILERPLATE(_object_name_, _shared_obj_name_) \
static _object_name_ *z##_shared_obj_name_ = nil;  \
+ (_object_name_ *)_shared_obj_name_ {             \
static dispatch_once_t onceToken;              \
dispatch_once(&onceToken, ^{                   \
z##_shared_obj_name_ = [[self alloc] init];\
});                                            \
return z##_shared_obj_name_;                   \
}


/** 色值 RGBA **/
#define RGB_A(r, g, b, a) [UIColor colorWithRed:(CGFloat)(r)/255.0f green:(CGFloat)(g)/255.0f blue:(CGFloat)(b)/255.0f alpha:(CGFloat)(a)]

/** 色值 RGB **/
#define RGB(r, g, b) RGB_A(r, g, b, 1)


//公用颜色值
#define themeBlueColor              RGB_A(0, 150, 255, 0.8)
#define themePureBlueColor          RGB_A(48, 168, 252, 1)
#define shadowBlueColor             RGB_A(47, 124, 201, 1)
#define themeDeepBlueColor          RGB_A(0, 150, 255, 1)
#define themeRedColor               RGB_A(255, 126, 121, 1)
#define themeGreyColor              RGB_A(214, 214, 214, 1)
#define themeOrangeColor            RGB_A(255, 169, 91, 1)
#define themeDarkOrangeColor        RGB_A(255, 139, 0, 1)

#define indexBackgroundColor        RGB_A(246, 246, 246, 1)
#define tarBarColor                 RGB_A(66, 66, 66, 1)

#define sitUpColor                  RGB_A(112, 191, 65, 1)
#define pushUpColor                 RGB_A(243, 144, 25, 1)
#define squatColor                  RGB_A(236, 93, 87, 1)
#define walkColor                   RGB_A(179, 106, 226, 1)

#define saveButtonGreyColor         RGB_A(235, 235, 235, 1)
#define saveTextGreyColor           RGB_A(192, 192, 192, 1)

#define popBackgroundColor          RGB_A(66, 66, 66, 0.8)
#define popContentColor             RGB_A(246, 246, 246, 1)
#define transparentBlackColor       RGB_A(0, 0, 0, 0.4)
#define transparentWhiteColor       RGB_A(255, 255, 255, 0.4)

#define levelPurpleColor            RGB_A(132, 110, 255, 1)
#define startTrainTargetGreyColor   RGB_A(218, 218, 218, 1)
#define circleGreyColor             RGB_A(205, 205, 205, 1)

#define settingBorderColor          RGB_A(81, 167, 249, 1)

//字体颜色
#define tipTitleLabelColor          RGB_A(66, 66, 66, 1)

//UI控件常规像素
#define APPCONFIG_UI_STATUSBAR_HEIGHT       20.0f                       // 系统自带的状态条的高度
#define APPCONFIG_UI_NAVIGATIONBAR_HEIGHT   44.0f                       // 系统自带的导航条的高度
#define APPCONFIG_UI_TABBAR_HEIGHT          49.0f                       // 系统自带的导航条的高度
#define APPCONFIG_UI_VIEW_PADDING           20.0f                       // 默认视图边距
#define APPCONFIG_UI_VIEW_BETWEEN_PADDING   10.0f                       // 默认视图间距
#define APPCONFIG_UI_TABLE_CELL_HEIGHT      44.0f                       // UITableView 单元格默认高度
#define APPCONFIG_UI_ERROR_CELL_HEIGHT      180.0f                      // UITableView 异常单元格默认高度
#define APPCONFIG_UI_TABLE_PADDING          10.0f                       // UITableView 的默认边距

// UI 界面大小
#define APPCONFIG_UI_SCREEN_FHEIGHT             ([UIScreen mainScreen].bounds.size.height)              //界面的高度 iphone5 568 其他480
#define APPCONFIG_UI_SCREEN_FWIDTH              ([UIScreen mainScreen].bounds.size.width)               //界面的宽度 iphone 320
#define APPCONFIG_UI_SCREEN_VHEIGHT             (APPCONFIG_UI_SCREEN_FHEIGHT - APPCONFIG_UI_STATUSBAR_HEIGHT - APPCONFIG_UI_NAVIGATIONBAR_HEIGHT - APPCONFIG_UI_TABBAR_HEIGHT)
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
