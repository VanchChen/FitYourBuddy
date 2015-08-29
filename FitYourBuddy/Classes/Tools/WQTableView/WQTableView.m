//
//  WQTableView.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/4/15.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "WQTableView.h"
#import "WQTableData.h"
#import "DataItemResult.h"
#import "DataItemDetail.h"

#import "WQErrorTableViewCell.h"

@implementation WQTableView

#pragma mark - 生命周期

- (id)init {
    return [self initWithStyle:NO];
}

/** 初始化表格，isGrouped为YES时，表示初始化一个圆角表格 */
- (id)initWithStyle:(BOOL)isGrouped {
    self = [super initWithFrame:CGRectZero style:isGrouped ? UITableViewStyleGrouped : UITableViewStylePlain];
    
    [self customInit];
    
    //背景色
    if (isGrouped) {
        self.backgroundView = nil;
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)customInit {
    self.delegate = self;
    self.dataSource = self;
    
    //分割线默认不是昨天空一点 （67像素） 改为从最左边开始
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        self.separatorInset = UIEdgeInsetsZero;
    }
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        self.layoutMargins = UIEdgeInsetsZero;
    }
    
    //列表数据
    self.arrTableData = [NSMutableArray array];
    
    self.backgroundColor = [UIColor clearColor];
    self.tableFooterView = [UIView new];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self customInit];
}

- (void)dealloc {
}

//重写设置下拉
- (void)setIsRefreshType:(BOOL)isRefreshType {
    _isRefreshType = isRefreshType;
    if(isRefreshType){
        [self addHeaderWithTarget:self action:@selector(refreshTableData)];
    }else{
        [self removeHeader];
    }
}

- (void)refreshTableData {
    //0号位的段数据 重新请求数据
    WQTableData *sectionData = [self dataOfSection:0];
    [sectionData refreshData];
}

#pragma mark - UITableView UI回调
//单元格高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WQTableData *sectionData = [self dataOfSection:indexPath.section];
    NSUInteger rowCount = [sectionData.tableDataResult count];
    
    //没有数据，或者异常数据， 全文提示
    if (rowCount == 0) {
        //错误与空 只有第一页有效
        if (sectionData.tableDataStatus != WQTableDataStatusLoading) {
            //如果明确的给过高度
            if (sectionData.emptyCellHeight >= 0) {
                return sectionData.emptyCellHeight;
            }
            
            CGFloat tableHeight = CGRectGetHeight(tableView.bounds);
            CGFloat tableHeaderHeight = CGRectGetHeight(tableView.tableHeaderView.bounds);
            if (tableHeight - tableHeaderHeight >= APPCONFIG_UI_TABLE_CELL_HEIGHT) {
                //撑满屏幕
                return tableHeight - tableHeaderHeight;
            } else {
                return tableHeight;
            }
        } else { //加载中
            return APPCONFIG_UI_TABLE_CELL_HEIGHT;
        }
    } else if (indexPath.row >= rowCount) {
        //加载与错误
        return APPCONFIG_UI_TABLE_CELL_HEIGHT;
    } else if (self.heightForRow){
        return self.heightForRow(self, indexPath);
    }
    return APPCONFIG_UI_TABLE_CELL_HEIGHT;
}

//表头高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    WQTableData *sectionData = self.arrTableData[section];
    
    if (self.headerForSection && sectionData.hasHeaderView) {
        UIView *_sectionHeaderView = self.headerForSection(self, section);
        if (nil == _sectionHeaderView) {
            return 0;
        }
        return CGRectGetHeight(_sectionHeaderView.bounds);
    }
    
    if (tableView.style == UITableViewStyleGrouped) {
        return APPCONFIG_UI_TABLE_PADDING;
    }
    
    return 0;
}

//表格端的顶部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    WQTableData *sectionData = [self dataOfSection:section];
    
    if (self.headerForSection && sectionData.hasHeaderView) {
        return self.headerForSection(self, section);
    }
    
    return nil;
}

//表尾高
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    WQTableData *sectionData = self.arrTableData[section];
    
    //有自定义界面
    if (self.footerForSection && sectionData.hasFooterView) {
        UIView *sectionFooterView = self.footerForSection(self, section);
        if (nil == sectionFooterView) {
            return 0;
        }
        return  CGRectGetHeight(sectionFooterView.bounds);
    }
    
    if (tableView.style == UITableViewStyleGrouped) {
        return 1.0f;
    }
    
    return 0;
}

//表格段的底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    WQTableData *sectionData = [self dataOfSection:section];
    
    if (self.footerForSection && sectionData.hasFooterView) {
        return self.footerForSection(self, section);
    }
    
    return nil;
}

//选中某行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WQTableData *sectionData = [self dataOfSection:indexPath.section];
    
    //异常情况 点击让用户重试
    if (indexPath.row >= [sectionData.tableDataResult count]) {
        //如果外部已经有处理错误代码了，这里就引到外面去，自己不做处理
        if (self.errorHandle != NULL) {
            self.errorHandle(self,sectionData);
            return;
        }
        
        //以下是默认的错误处理
        if (WQTableDataStatusFinished == sectionData.tableDataStatus) {
            //出错数据 数据为空
            NSUInteger rowCount = [sectionData.tableDataResult count];
            if (!sectionData.isLoadDataOK || rowCount == 0) {
                if (sectionData.isEmptyCellEnableClick) {
                    [sectionData loadData];
                }
            } else { //更多
                if (![sectionData isLoadDataComplete]) {
                    //更多数据
                    [sectionData loadDataforNextPage];
                }
            }
        }
    } else if (self.didSelectRow) {
        self.didSelectRow(self, indexPath);
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableView 数据回调
//返回表格端的数量
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.arrTableData count];
}

//一个单元中有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    WQTableData *sectionData = [self dataOfSection:section];
    
    assert(nil != sectionData);
    
    NSUInteger rowCount = [sectionData.tableDataResult count];
    
    //根据状态，决定显示的单元格个数
    switch (sectionData.tableDataStatus) {
        case WQTableDataStatusNotStart: {
            //无加载情况，显示数等于数据个数 （多半是无网络请求的）
            return rowCount;
            break;
        }
        case WQTableDataStatusLoading: {
            return rowCount + 1;
            break;
        }
        case WQTableDataStatusFinished: {
            //没有后续数据了
            if ([sectionData isLoadDataComplete]) {
                //无数据，加载完毕
                if (rowCount == 0) {
                    //空单元格
                    return 1;
                }
                //有数据，加载完毕
                else {
                    //加载完毕
                    if (sectionData.hasFinishCell) {
                        return rowCount + 1;
                    } else {
                        //正常个数
                        return rowCount;
                    }
                }
            }
            //更多
            else {
                //只有最后一个section才有更多
                if (section == self.numberOfSections - 1) {
                    //最底下是加载更多数据的单元格
                    return rowCount + 1;
                } else {
                    return rowCount;
                }
            }
            break;
        }
        default: {
            return rowCount;
            break;
        }
    }
}

//创建表格中的一个单元格
- (id)cellWithClass:(Class<WQTableViewCellDelegate>)cellClass indexPath:(NSIndexPath *)indexPath {
    assert(nil != cellClass);
    
    NSString *cellIdentifier = [NSString stringWithFormat:@"dequeueReusableCellWithIdentifier-%@", cellClass] ;
    
    UITableViewCell<WQTableViewCellDelegate> *cell = [self dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (nil == cell) {
        //创建单元格
        cell = [cellClass createCell:cellIdentifier];
        cell.frame = CGRectMake(0, 0, self.frame.size.width, [self tableView:self heightForRowAtIndexPath:indexPath]);
    }
    
    assert(nil != cell);
    
    WQTableData *sectionData = [self dataOfSection:indexPath.section];
    cell.table = self;
    cell.tableData = sectionData;
    cell.indexPath = indexPath;
    cell.cellDetail = [sectionData.tableDataResult getItem:indexPath.row];
    
    //绑定数据
    [cell bindCellData];
    
    return cell;
}

// 创建指定单元格的 UITableViewCell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WQTableData *sectionData = [self dataOfSection:indexPath.section];
    
    //这里是最后一行，一般是出错了，加载中的单元格样式
    if (indexPath.row >= [sectionData.tableDataResult count]) {
        //确保是加载完毕了
        assert(WQTableDataStatusNotStart != sectionData.tableDataStatus);
        
        //加载状态，显示加载样式
        if (WQTableDataStatusLoading == sectionData.tableDataStatus) {
            return [self cellWithClass:sectionData.mLoadingCellClass indexPath:indexPath];
        } else {
            //异常
            assert(WQTableDataStatusFinished == sectionData.tableDataStatus);
            
            //加载失败
            if(!sectionData.isLoadDataOK) {
                if (sectionData.pageAt == 1) {
                    return [self cellWithClass:sectionData.mErrorCellClass indexPath:indexPath];
                } else {
                    return [self cellWithClass:[WQErrorTableViewCell class] indexPath:indexPath];
                }
            }
            //空单元格
            else if ([sectionData.tableDataResult count] == 0) {
                return [self cellWithClass:sectionData.mEmptyCellClass indexPath:indexPath];
            }
            //加载完单元格
            else if (sectionData.hasFinishCell && sectionData.isLoadDataComplete) {
                return [self cellWithClass:sectionData.mFinishedCellClass indexPath:indexPath];
            }
            //更多单元格
            else {
                return [self cellWithClass:sectionData.mMoreCellClass indexPath:indexPath];
            }
        }
    }
    
    if (self.modifiRowClass) {
        Class modifiRowClass = self.modifiRowClass(self, sectionData.mDataCellClass, indexPath);
        return [self cellWithClass:modifiRowClass indexPath:indexPath];
    }
    
    return [self cellWithClass:sectionData.mDataCellClass indexPath:indexPath];
}

#pragma mark -
#pragma mark 数据方法
/** 为表格添加一个表格段 */
- (void)addSectionWithData:(WQTableData *)sectionData {
    NSAssert(nil != sectionData.mDataCellClass, @"不允许加一个空的列表数据进来");
    sectionData.tableView = self;
    
    //队列中添加数据
    [self.arrTableData addObject:sectionData];
}

- (void)removeSection:(NSUInteger)section {
    if (section < self.arrTableData.count) {
        [self.arrTableData removeObjectAtIndex:section];
    }
}

/** 获取指定表格段的数据 */
- (WQTableData *)dataOfSection:(NSInteger)section {
    if(section > -1 && section < [self.arrTableData count]){
        return self.arrTableData[section];
    }
    
    return nil;
}

/** 获取指定单元格的数据 */
- (DataItemDetail *)dataOfIndexPath:(NSIndexPath *)indexPath {
    assert(nil != indexPath);
    
    WQTableData *data = [self dataOfSection:indexPath.section];
    
    if (nil == data) {
        return nil;
    }
    
    assert(nil != data.tableDataResult);
    
    return [data.tableDataResult getItem:indexPath.row];
}


/** 获取指定单元格的数据 */
- (DataItemDetail *)dataOfCellTag:(NSInteger)cellTag {
    for (int i = 0 ; i<[self.arrTableData count]; i++) {
        WQTableData *data = [self dataOfSection:i];
        for (int j = 0; j<data.tableDataResult.count; j++) {
            DataItemDetail *cellDetail = [self dataOfIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
            if ([cellDetail tableCellTag] == cellTag) {
                return cellDetail;
            }
        }
    }
    
    return nil;
}

#pragma mark -
#pragma mark 一些关于用户操作的方法
// 自动检测和加载最后一个表格数据段的下一页数据
- (void)autoCheckAndLoadNextPage:(UIScrollView *)scrollView {
    if (nil == self.arrTableData || [self.arrTableData count] < 1) {
        return;
    }
    
    //判断是否加载到底部
    if(!(scrollView.contentSize.height - (scrollView.contentOffset.y + scrollView.bounds.size.height) < 0.5f)){
        return;
    }
    
    //最底部的表段数据
    WQTableData *lastSectionData = self.arrTableData[[self.arrTableData count] - 1];
    
    //加载中或者无后续数据不用去处理
    if (lastSectionData.tableDataStatus == WQTableDataStatusLoading
        || ![lastSectionData hasNextPage]
        || [lastSectionData isLoadDataComplete]) {
        return;
    } else if(lastSectionData.tableDataStatus == WQTableDataStatusNotStart) {
        //这里一般不会进入
        [lastSectionData loadData];
    } else if(lastSectionData.tableDataStatus == WQTableDataStatusFinished){
        //加载完毕后判断状态
        if ([lastSectionData hasNextPage]) {
            [lastSectionData loadDataforNextPage];
        } else {
            [lastSectionData loadData];
        }
    }
}

/** view已经停止滚动 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //加载下一页
    [self autoCheckAndLoadNextPage:scrollView];
}

/** 有动画时调用 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self autoCheckAndLoadNextPage:scrollView];
}

/** 表格数据是否全加载成功（限使用网络数据时） */
- (BOOL)hasLoadFinished {
    assert(nil != self.arrTableData);
    
    for (WQTableData *sectionData in self.arrTableData) {
        if (sectionData.tableDataStatus != WQTableDataStatusFinished || !sectionData.isLoadDataOK) {
            return NO;
        }
    }
    
    return YES;
}

- (void)clearTableData {
    NSUInteger sectionCount = [self.arrTableData count];
    for (int i=0; i<sectionCount; i++) {
        [self removeSection:i];
    }
}

@end
