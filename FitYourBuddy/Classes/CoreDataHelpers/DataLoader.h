//
//  DataLoader.h
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/8/5.
//  Copyright (c) 2015年 xpz. All rights reserved.
//
//  一次性的请求类，一次只能一个请求，无论失败与否，一次作废

#import <Foundation/Foundation.h>

#define Method_GET      @"GET"
#define Method_POST     @"POST"

@class DataItemResult;

typedef void (^CompleteBlock)(DataItemResult *result);

@interface DataLoader : NSObject

@property (nonatomic, assign) BOOL           hasFinishedLoad;//标志位
@property (nonatomic, strong) DataItemResult *dataItemResult;//解析的数据放入数据容器中
@property (nonatomic, copy  ) CompleteBlock  completeBlock;//完成回调

/** 初始化GET方式请求的网络数据 */
- (instancetype)initWithURL:(NSString *)URL complete:(CompleteBlock)completeBlock;

/** 获取本地解析好的数据 */
- (DataItemResult *)getDataItemResult;

/** 停止加载和解析数据，停止事件响应 */
- (void)stopLoading;

//数据装载事件完成后调用的函数，自动释放一次
- (void)onFinished;

@end
