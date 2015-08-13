//
//  AppCore.h
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/8/13.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

@interface AppCore : NSObject

SINGLETON_DEFINE(AppCore)

@property (nonatomic, strong) NSOperationQueue *appCoreQueue;      //核心任务队列

@end
