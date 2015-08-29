//
//  WQTableData.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/8/5.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "WQTableData.h"

#import "AppCore.h"
#import "DataItemResult.h"
#import "DataLoader.h"
#import "WQTableView.h"

#import "WQErrorTableViewCell.h"
#import "WQLoadingTableViewCell.h"
#import "WQMoreTableViewCell.h"

@implementation WQTableData

#pragma mark -
#pragma mark 生命周期
- (id)init {
    self = [super init];
    
    if (self) {
        self.tableDataResult = [DataItemResult new];
        self.tableDataStatus = WQTableDataStatusNotStart;         //默认没开始加载
        self.pageAt = 1;                //默认第一页
        self.pageSize = [AppCore sharedAppCore].appTablePageSize;    //默认一页xx条
        self.isLoadDataOK = YES;             //默认加载完毕
        self.isEmptyCellEnableClick = YES;      //允许点击
        self.emptyCellHeight = -1;          //给一个负数
        self.selectedBackgroundColor = RGB(0xf0, 0xf0, 0xf0);       //点击色
        
        self.tag = 0;
        
        self.mDataCellClass = nil;
        self.mEmptyCellClass = [WQEmptyTableViewCell class];
        self.mErrorCellClass = [WQErrorTableViewCell class];
        self.mLoadingCellClass = [WQLoadingTableViewCell class];
        self.mMoreCellClass = [WQMoreTableViewCell class];
        self.mFinishedCellClass = [WQFinishedTableViewCell class];
    }
    
    return self;
}

- (void)dealloc {
    [self.dataLoader stopLoading];
}

//总页数
- (NSUInteger)totalPage {
    NSUInteger totalPage = (NSUInteger)ceilf((float)self.tableDataResult.maxCount / self.pageSize);
    return totalPage;
}

#pragma mark -
#pragma mark 数据操作
//刷新数据
- (void)refreshData {
    //数据不在加载状态
    if (self.tableDataStatus == WQTableDataStatusLoading) {
        return;
    }
    
    //判断是否正在刷新
    if (self.tableView.headerRefreshing) {
        return;
    }
    
    //从第一页开始
    self.pageAt = 1;
    
    //加载数据
    [self loadData];
}

//加载数据
- (void)loadData {
    if(!self.tableView) {
        return;
    }
    
    //将要发起请求
    if (self.tableView.willRequestData) {
        self.tableView.willRequestData(self);
    }
    
    //记载状态
    self.tableDataStatus = WQTableDataStatusLoading;
    
    if (self.pageAt == 1) {
        //如果是下拉列表
        if (self.tableView.isRefreshType) {
            [self.tableView headerBeginRefreshing];
        } else {
            //删除老数据
            [self.tableDataResult clear];
            //显示刷新样式
            [self.tableView reloadData];
        }
    } else {
        //显示刷新样式
        [self.tableView reloadData];
    }
    
    //获取网络接口
    [self.dataLoader stopLoading];
    
    NSAssert(NULL != self.tableView.requestData, @"请求数据不允许不实现");
    //发起请求
    self.dataLoader = self.tableView.requestData(self);
    
    //数据完成回调
    __weak WQTableData *weakSelf = self;
    self.dataLoader.completeBlock = ^(DataItemResult *result){
        //列表数据的状态
        weakSelf.isLoadDataOK = !result.hasError;
        weakSelf.tableDataResult.message = result.message;
        
        //如果是下拉列表
        if (weakSelf.tableView.isRefreshType) {
            //下拉列表下拉请求，加载成功
            if (weakSelf.pageAt == 1) {
                //数据如果有问题，则还是上一次的数据
                if (weakSelf.isLoadDataOK) {
                    weakSelf.lastUpdateTime = [NSDate new];
                    
                    //只留下section 0 号
                    for (NSInteger i = weakSelf.tableView.arrTableData.count; i > 0; i--) {
                        [weakSelf.tableView removeSection:i];
                    }
                    
                    [weakSelf.tableDataResult clear];
                }
            }
        }
        
        //加载完毕
        weakSelf.tableDataStatus = WQTableDataStatusFinished;
        
        //接受数据，理论上是必实现的
        if (weakSelf.tableView.receiveData) {
            weakSelf.tableView.receiveData(weakSelf.tableView, weakSelf, result);
        }
        
        //如果是下拉列表
        if (weakSelf.tableView.isRefreshType) {
            [weakSelf.tableView headerEndRefreshing];
        }
        
        [weakSelf.tableView reloadData];
    };
}

//停止加载数据
- (void)stopLoadData {
    self.tableDataStatus = WQTableDataStatusFinished;
    [self.dataLoader stopLoading];
    [self.tableView reloadData];
    
    //如果是下拉列表
    if (self.tableView.isRefreshType) {
        [self.tableView headerEndRefreshing];
    }
}

//加载下一页
- (void)loadDataforNextPage {
    if (![self hasNextPage]) {
        return;
    }
    
    //页码自动加1 并加载数据
    self.pageAt++;
    
    [self loadData];
}

//加载完毕，并且这里的意思是没有后续数据了，对应 hasNextPage 方法
- (BOOL)isLoadDataComplete {
    if (self.tableDataStatus == WQTableDataStatusFinished) {
        NSUInteger maxCount = self.tableDataResult.maxCount;
        NSUInteger currentCount = [self.tableDataResult count];
        if (maxCount <= currentCount || maxCount <= self.pageAt * self.pageSize) {
            return YES;
        }
    }
    
    return NO;
}

//是否有下一页
- (BOOL)hasNextPage {
    if (nil == self.tableView) {
        return NO;
    }
    
    //排除加载中状态
    if (self.tableDataStatus != WQTableDataStatusFinished) {
        return NO;
    }
    
    //排除数据加载完毕
    if (self.pageAt * self.pageSize >= self.tableDataResult.maxCount) {
        return NO;
    }
    
    return YES;
}

#pragma mark -
#pragma mark 界面操作
//销毁数据加载等
- (void)dispatchView {
    self.tableView = nil;
    [self.dataLoader stopLoading];
    self.dataLoader = nil;
}

@end
