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
    
    self.backgroundColor = [UIColor clearColor];
    self.tableFooterView = [[UIView alloc] init];
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
    
}

#pragma mark - UITableView UI回调
//单元格高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.heightForRow){
        return self.heightForRow(self, indexPath);
    }
    return APPCONFIG_UI_TABLE_CELL_HEIGHT;
}

//表头高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.headerForSection) {
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
    if (self.headerForSection) {
        return self.headerForSection(self, section);
    }
    
    return nil;
}

//表尾高
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    //有自定义界面
    if (self.footerForSection) {
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
    if (self.footerForSection) {
        return self.footerForSection(self, section);
    }
    
    return nil;
}

//选中某行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.didSelectRow) {
        self.didSelectRow(self, indexPath);
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableView 数据回调
//因为未绑定数据，所以不能实现块数行数,单元格,先写死

//返回表格端的数量
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.numberForSection) {
        return self.numberForSection(self);
    }
    return 1;
}

//一个单元中有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.numberForRowInSection) {
        return self.numberForRowInSection(self, section);
    }
    return 10;
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
    
//    SBTableData *sectionData = [self dataOfSection:indexPath.section];
//    cell.table = self;
//    cell.tableData = sectionData;
//    cell.indexPath = indexPath;
//    cell.cellDetail = [sectionData.tableDataResult getItem:indexPath.row];
//    
//    //绑定数据
//    [cell bindCellData];
    
    return cell;
}

// 创建指定单元格的 UITableViewCell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.modifiRowClass) {
        Class modifiRowClass = self.modifiRowClass(self, [WQTableViewCell class], indexPath);
        return [self cellWithClass:modifiRowClass indexPath:indexPath];
    }
    
    return [[UITableViewCell alloc] init];
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
