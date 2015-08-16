//
//  DataLoader.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/8/5.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "DataLoader.h"
#import "DataItemResult.h"

#import "HttpTask.h"

@implementation DataLoader

#pragma mark -
#pragma mark 生命周期

- (instancetype)initWithURL:(NSString *)URL httpMethod:(NSString *)httpMethod complete:(CompleteBlock)completeBlock {
    self = [super init];
    
    if (self) {
        self.dataItemResult = [DataItemResult new];
        self.completeBlock = completeBlock;
        
        self.httpTask = [[HttpTask alloc] initWithURLString:URL httpMethod:httpMethod received:^(HttpTask *task, NSData *data) {
            self.dataItemResult.rawData = data;
            
            //结束一次请求
            [self onFinished];
        } error:^(HttpTask *task, NSError *error) {
            self.dataItemResult.hasError = YES;
            self.dataItemResult.message = @"网络貌似不给力，请重新加载";
            
            [self onFinished];
        }];
    }
    
    return self;
}

//停止加载和解析数据，停止事件响应
- (void)stopLoading {
    self.completeBlock = nil;
    
    if (nil != self.httpTask) {
        [self.httpTask stopLoading];
    }
    
    [self onFinished];
}

//释放资源
- (void)dealloc {
    [self stopLoading];
}

#pragma mark -
#pragma mark 获取数据
//获取本地解析好的数据
- (DataItemResult *)getDataItemResult {
    if (!self.hasFinishedLoad) {
        return nil;
    }
    
    return self.dataItemResult;
}

- (void)onFinished {
    @synchronized(self){
        if (_hasFinishedLoad) {
            return;
        }
        
        _hasFinishedLoad = YES;
        
        if (self.completeBlock) {
            self.completeBlock(self.dataItemResult);
        }
    }
}

@end
