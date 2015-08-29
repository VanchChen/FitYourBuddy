//
//  WQTableView.h
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/4/15.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "WQTableViewCell.h"
#import "MJRefresh.h"       //下拉表头

@class WQTableView;
@class WQTableData;
@class DataLoader;
@class DataItemResult;
@class DataItemDetail;

// 网络请求
typedef void (^tableViewDataBlock)(WQTableData *tableViewData);
// 网络请求
typedef DataLoader *(^requestDataBlock)(WQTableData *tableViewData);
// 网络加载数据完成时触发的事件
typedef void (^receiveDataBlock)(WQTableView *tableView, WQTableData *tableViewData, DataItemResult *result);
//加载完成时的回调
typedef void (^cacheLoadBlock)(WQTableView *tableView, WQTableData *tableViewData, DataItemResult *result);
// 处理网络载入错误
typedef void (^errorHandleBlock)(WQTableView *tableView, WQTableData *section);

// 段落首尾界面
typedef UIView *(^viewForSectionBlock)(WQTableView *tableView, NSInteger section);
// 单元格高度
typedef CGFloat (^heightForRowBlock)(WQTableView *tableView, NSIndexPath *indexPath);
// 处理单元格
typedef void (^operateRowBlock)(WQTableView *tableView, NSIndexPath *indexPath);
// 临时修改单元格的显示样式
typedef Class(^modifiRowClassBlock)(WQTableView *tableView, Class<WQTableViewCellDelegate> originClass, NSIndexPath *indexPath);


@interface WQTableView : UITableView <UITableViewDelegate, UITableViewDataSource>

/** 一般对应列表所在的viewctroller **/
@property (nonatomic, weak) UIViewController *ctrl;
/** 是否是下拉类型的列表 */
@property (nonatomic, assign) BOOL isRefreshType;

/** 网络请求列表 */
@property (nonatomic, strong) NSMutableArray *arrTableData;                     //列表数据

/** 将要发起网络请求 */
@property (nonatomic, copy) tableViewDataBlock willRequestData;
/** 发起网络请求 */
@property (nonatomic, copy) requestDataBlock requestData;
/** 接受网络数据 */
@property (nonatomic, copy) receiveDataBlock receiveData;
/** cache加载完成时的block */
@property (nonatomic, copy) cacheLoadBlock cacheLoad;
// 网络异常处理
@property (nonatomic, copy) errorHandleBlock errorHandle;

/** 段的头部视图 */
@property (nonatomic, copy) viewForSectionBlock headerForSection;
/** 段的尾部视图 */
@property (nonatomic, copy) viewForSectionBlock footerForSection;
/** 单元格高度 */
@property (nonatomic, copy) heightForRowBlock heightForRow;
/** 临时修改单元格的显示样式 */
@property (nonatomic, copy) modifiRowClassBlock modifiRowClass;
/** 点击单元格 */
@property (nonatomic, copy) operateRowBlock didSelectRow;

/** 初始化表格，isGrouped为YES时，表示初始化一个圆角表格 */
- (id)initWithStyle:(BOOL)isGrouped;
/**  表格初始化，会在initWithStyle:时调用 */
- (void)customInit;

/** 为表格添加一个表格段 */
- (void)addSectionWithData:(WQTableData *)sectionData;
/** 删除一个表格段 */
- (void)removeSection:(NSUInteger)section;

/** 获取指定表格段的数据 */
- (WQTableData *)dataOfSection:(NSInteger)section;

/** 获取指定单元格的数据 */
- (DataItemDetail *)dataOfIndexPath:(NSIndexPath *)indexPath;

/** 获取指定单元格的数据 */
- (DataItemDetail *)dataOfCellTag:(NSInteger)cellTag;

/** 表格数据是否全加载成功（限使用网络数据时） */
- (BOOL)hasLoadFinished;

/** 自动检测和加载最后一个表格数据段的下一页数据 */
- (void)autoCheckAndLoadNextPage:(UIScrollView *)scrollView;

/** 清除所有表内容 */
- (void)clearTableData;

@end
