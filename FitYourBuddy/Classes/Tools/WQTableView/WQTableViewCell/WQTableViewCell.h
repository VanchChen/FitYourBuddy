//
//  WQTableViewCell.h
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/4/15.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "DataItemDetail.h"

@class WQTableView;

#define __KEY_CELL_EMPTY      @"<&__KEY_CELL_EMPTY&>"                //表示空数据
#define __KEY_CELL_SELECTED   @"<&__KEY_CELL_SELECTED&>"             //表示是否选中
#define __KEY_CELL_TAG        @"<&__KEY_CELL_TAG&>"                  //表示标记

@protocol WQTableViewCellDelegate <NSObject>

/** 单元格的表格视图，当单元格显示时会被重新赋值 */
@property (nonatomic,weak) WQTableView *table;

/** 单元格在表格中的位置，当单元格显示时会被重新赋值 */
@property (nonatomic,copy) NSIndexPath *indexPath;

/** 获取一个新的单元格 */
+ (id)createCell:(NSString *)reuseIdentifier;

/** 获取单元格的ID */
+ (NSString *)cellID:(WQTableView *)table;

@end

@interface DataItemDetail (DataTableCell)

@property (getter = tableCellTag, setter = setTableCellTag:) int tag;

/** 设定单元格数据为空 */
- (void)setEmptyTableCell;

/** 设定单元格数据为空/不为空 */
- (void)setEmptyTableCell:(BOOL)isEmpty;

/** 单元格数据是否为空 */
- (BOOL)tableCellIsEmpty;

/** 设定单元格选中/未选中状态 */
- (void)setSelectedTableCell:(BOOL)isSelected;

/** 单元格是否被选中状态 */
- (BOOL)tableCellIsSelected;

/** 设定单元格标记 */
- (void)setTableCellTag:(int)tag;

/** 获取单元格标记 */
- (int)tableCellTag;

@end

@interface WQTableViewCell : UITableViewCell <WQTableViewCellDelegate>

/** 单元格的表格视图，当单元格显示时会被重新赋值 */
@property (nonatomic,weak) WQTableView *table;

/** 单元格在表格中的位置，当单元格显示时会被重新赋值 */
@property (nonatomic,copy) NSIndexPath *indexPath;

/** 获取一个新的单元格 */
+ (id)createCell:(NSString *)reuseIdentifier;

/** 获取单元格的ID */
+ (NSString *)cellID:(WQTableView *)table;

@end
