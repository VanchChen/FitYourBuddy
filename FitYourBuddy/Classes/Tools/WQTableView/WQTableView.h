//
//  WQTableView.h
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/4/15.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "WQTableViewCell.h"

@class WQTableView;

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
@property (nonatomic, assign) UIViewController *ctrl;
/** 是否是下拉类型的列表 */
@property (nonatomic, assign) BOOL isRefreshType;

// 段的头部视图
@property (nonatomic, copy) viewForSectionBlock headerForSection;
// 段的尾部视图
@property (nonatomic, copy) viewForSectionBlock footerForSection;
// 单元格高度
@property (nonatomic, copy) heightForRowBlock heightForRow;
// 临时修改单元格的显示样式
@property (nonatomic, copy) modifiRowClassBlock modifiRowClass;
// 点击单元格
@property (nonatomic, copy) operateRowBlock didSelectRow;

/** 初始化表格，isGrouped为YES时，表示初始化一个圆角表格 */
- (id)initWithStyle:(BOOL)isGrouped;
/**  表格初始化，会在initWithStyle:时调用 */
- (void)customInit;

@end
