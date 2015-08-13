//
//  AppCore.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/8/13.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "AppCore.h"

static int const kMultiteNetWorkCount = 20;          //并行的网络请求数

@implementation AppCore

SINGLETON_IMPLEMENT(AppCore)

- (void)dealloc {
    [_appCoreQueue cancelAllOperations];
    _appCoreQueue = nil;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.appCoreQueue = [[NSOperationQueue alloc] init];
        self.appCoreQueue.maxConcurrentOperationCount = kMultiteNetWorkCount;
    }
    return self;
}

@end
