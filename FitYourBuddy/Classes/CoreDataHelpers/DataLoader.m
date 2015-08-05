//
//  DataLoader.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/8/5.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "DataLoader.h"
#import "DataItemResult.h"

#import "AFNetworking.h"

@implementation DataLoader

#pragma mark -
#pragma mark 生命周期

- (instancetype)initWithURL:(NSString *)URL complete:(CompleteBlock)completeBlock {
    self = [super init];
    
    if (self) {
        self.dataItemResult = [DataItemResult new];
        self.completeBlock = completeBlock;
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }
    
    return self;
}

//停止加载和解析数据，停止事件响应
- (void)stopLoading {
    self.completeBlock = nil;
    
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
