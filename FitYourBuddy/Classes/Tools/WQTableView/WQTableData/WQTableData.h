//
//  WQTableData.h
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/8/5.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

@class WQTableView;
@class DataItemResult;
@class DataLoader;
@protocol WQTableViewCellDelegate;

typedef NS_ENUM(NSInteger, WQTableDataStatus) {
    WQTableDataStatusNotStart,
    WQTableDataStatusLoading,
    WQTableDataStatusFinished
};

@interface WQTableData : NSObject

/**  普通Cell的class，mDataCellInfo的简便方法 */
@property (nonatomic, assign) Class<WQTableViewCellDelegate>   mDataCellClass;

@property (nonatomic, weak) WQTableView *tableView;                 //列表数据对应的列表
@property (nonatomic, assign) NSInteger tag;                        //一个tag，没事情别乱用

@property (nonatomic, strong) DataItemResult *tableDataResult;          //列表数据

@property (nonatomic, strong) DataLoader    *dataLoader;//数据请求句柄

@property (nonatomic, assign) WQTableDataStatus tableDataStatus; //状态
@property (nonatomic, assign) NSUInteger pageAt;            //pageAt即是tailPage
@property (nonatomic, readonly, assign) NSUInteger totalPage;               //数据总大小
@property (nonatomic, assign) NSUInteger pageSize;              //每页的数据大小
@property (nonatomic, assign) BOOL isLoadDataOK;                //是否加载完毕
@property (nonatomic, assign) BOOL hasFinishCell;                //是否有显示完毕的单元格
@property (nonatomic, assign) BOOL hasHeaderView;                   //是否有悬浮段头
@property (nonatomic, assign) BOOL hasFooterView;                   //是否有悬浮段尾
@property (nonatomic, assign) BOOL isEmptyCellEnableClick;                   //空单元格是否允许点击 默认yes
@property (nonatomic, assign) CGFloat emptyCellHeight;                   //空列表的高度 （指定空单元格的高度）
@property (nonatomic, strong) UIColor *selectedBackgroundColor;              //单元格点击色
@property (nonatomic, strong) NSDate *lastUpdateTime;               //最后刷新时间

//刷新数据
- (void)refreshData;

//加载数据
- (void)loadData;

//停止加载数据
- (void)stopLoadData;

//加载下一页的数据
- (void)loadDataforNextPage;

//加载完毕，并且这里的意思是没有后续数据了，对应 hasNextPage 方法
- (BOOL)isLoadDataComplete;

//是否有后续数据
- (BOOL)hasNextPage;

//销毁数据
- (void)dispatchView;

@end
