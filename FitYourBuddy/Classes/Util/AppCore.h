//
//  AppCore.h
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/8/13.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

@interface AppCore : NSObject

SINGLETON_DEFINE(AppCore)

@property (nonatomic, assign) NSInteger        appTablePageSize;
@property (nonatomic, copy  ) NSString         *appLaunchDate;
@property (nonatomic, strong) NSOperationQueue *appCoreQueue;//核心任务队列

/**上传用户信息以及用户锻炼数据*/
- (void)networkUpdateAccount;

#pragma mark - 跳转页面相关

/**跳转到欢迎页面*/
- (void)jumpToWelcomeViewController;
/**跳转到首页*/
- (void)jumpToIndexViewController;
/**跳转到某一个页面，现是跳转到锻炼页面，present的形式*/
- (void)presentViewControllerByClass:(NSString *)className;
/**检查是否有跳转*/
- (void)checkPresent;

@end
