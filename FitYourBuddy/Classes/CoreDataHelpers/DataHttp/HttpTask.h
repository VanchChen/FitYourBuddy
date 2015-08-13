//
//  HttpTask.h
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/8/12.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HttpTaskState) {
    HttpTaskStateReady = 1,
    HttpTaskStateExecuting = 2,
    HttpTaskStateFinished = 3
};

@class HttpTask;

typedef void (^TaskOnError)(HttpTask *task, NSError *error);
typedef void (^TaskOnReceived)(HttpTask *task, NSData *data);

@interface HttpTask : NSOperation

/** 回调 */
@property (nonatomic, copy) TaskOnError     errorBlock;     //出错回调
@property (nonatomic, copy) TaskOnReceived  receivedBlock;  //接受回调

/** 网络*/
@property (nonatomic, strong) NSURLConnection *urlConnection;
@property (nonatomic, strong) NSMutableURLRequest *urlRequest;

/** url为最基本的参数，必须指定 */
@property (nonatomic, copy) NSString *aURLString;

/** 请求的方式，GET/POST */
@property (nonatomic, copy) NSString *httpMethod;

/** 接收到的网络数据 */
@property (nonatomic, strong) NSMutableData *recieveData;

/** 是否加载完毕 */
@property (nonatomic, assign) BOOL completed;

/** 网络请求状态码 */
@property (nonatomic, assign) NSInteger statusCode;

/** 网络下载数据预估大小 */
@property (nonatomic, assign) NSUInteger expectedContentLength;

/** 错误信息 */
@property (strong, nonatomic) NSError *httpError;

/** 标签，用以区分同一个delegate的不同task */
@property (nonatomic, assign) NSInteger tag;

/** 附带的用户信息 */
@property (nonatomic, retain) id userInfo;

/** post请求的post数据 */
@property (nonatomic, strong) NSData *postData;

/** 超时时间，默认为xx秒 */
@property (nonatomic, assign) NSTimeInterval timeout;

/** 数据压缩  */
@property (nonatomic, assign) BOOL gzip;

/** 网络操作状态 */
@property (nonatomic, assign) HttpTaskState httpTaskState;

#pragma mark - method

/** 初始化一个HTTP请求 */
- (instancetype)initWithURLString:(NSString *)aURLString
                       httpMethod:(NSString *)method
                         received:(TaskOnReceived)receivedBlock
                            error:(TaskOnError)errorBlock;

/** 终止数据加载 */
- (void)stopLoading;

/** 网络任务描述 */
- (NSString *)sbHttpDescribe;

//获取http请求过的数据
+ (NSString *)getHttpRecord;

@end
