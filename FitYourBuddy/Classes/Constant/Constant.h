//
//  Constant.h
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/3/21.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

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

//请求相关
#define APPCONFIG_CONN_HEAD             @"http://"
#define APPCONFIG_CONN_SERVER           @"121.43.226.76"
#define APPCONFIG_CONN_AGENT            @"/webservice/WebService.asmx"
#define APPCONFIG_CONN_TIMEOUT          30                            // 连接超时时间
#define APPCONFIG_CONN_ERROR_MSG_DOMAIN @"HttpTaskError"              // 连接出错信息标志
