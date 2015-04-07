//
//  TimerManager.h
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/4/7.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

@interface TimerManager : NSObject
// 计时器单例
+ (TimerManager *)sharedManager;

//开始计时
- (void)startTickTock;

@end
