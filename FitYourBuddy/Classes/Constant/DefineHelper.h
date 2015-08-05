//
//  DefineHelper.h
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/8/5.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

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