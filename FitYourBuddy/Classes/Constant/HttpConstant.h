//
//  HttpConstant.h
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/8/22.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

//请求相关
#define APPCONFIG_CONN_HEAD             @"http://"
#define APPCONFIG_CONN_SERVER           @"121.43.226.76"
#define APPCONFIG_CONN_AGENT            @"/webservice/WebService.asmx"
#define APPCONFIG_CONN_TIMEOUT          30                            // 连接超时时间
#define APPCONFIG_CONN_ERROR_MSG_DOMAIN @"HttpTaskError"              // 连接出错信息标志

//数据包标准包头名
#define HTTP_PACKAGE_CODE               @"resCode"
#define HTTP_PACKAGE_MESSAGE            @"resMsg"
#define HTTP_PACKAGE_RESULT             @"result"

//萌胖圈包字段名
#define Friends_List_Rank               @"i_Rank"
#define Friends_List_ClientID           @"i_ClientID"
#define Friends_List_Name               @"vc_Name"
#define Friends_List_Level              @"i_Level"
#define Friends_List_Count              @"i_Count"
#define Friends_List_Fight              @"i_Fight"
#define Friends_List_Gender             @"i_Gender"
#define Friends_List_Hair               @"i_Hair"
#define Friends_List_Eye                @"i_Eye"
#define Friends_List_Mouth              @"i_Mouth"
#define Friends_List_Clothes            @"i_Clothes"
#define Friends_List_IsMe               @"isMe"