//
//  WQTableData.h
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/8/5.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

@class WQTableView;
@class DataItemResult;

typedef NS_ENUM(NSInteger, WQTableDataStatus) {
    WQTableDataStatusNotStart,
    WQTableDataStatusLoading,
    WQTableDataStatusFinished
};

@interface WQTableData : NSObject

@property (nonatomic, weak) WQTableView *tableView;                 //列表数据对应的列表
@property (nonatomic, assign) NSInteger tag;                        //一个tag，没事情别乱用

@property (nonatomic, strong) DataItemResult *tableDataResult;          //列表数据

@end
