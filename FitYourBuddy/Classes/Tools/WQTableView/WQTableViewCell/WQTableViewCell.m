//
//  WQTableViewCell.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/4/15.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "WQTableViewCell.h"

@implementation DataItemDetail (DataTableCell)

/** 设定单元格数据为空 */
- (void)setEmptyTableCell {
    [self setEmptyTableCell:YES];
}

/** 设定单元格数据为空/不为空 */
- (void)setEmptyTableCell:(BOOL)isEmpty {
    [self setBool:isEmpty forKey:__KEY_CELL_EMPTY];
}

/** 单元格数据是否为空 */
- (BOOL)tableCellIsEmpty {
    return [self getBool:__KEY_CELL_EMPTY];
}

/** 设定单元格选中/未选中状态 */
- (void)setSelectedTableCell:(BOOL)isSelected {
    [self setBool:isSelected forKey:__KEY_CELL_SELECTED];
}

/** 单元格是否被选中状态 */
- (BOOL)tableCellIsSelected {
    return [self getBool:__KEY_CELL_SELECTED];
}

/** 设定单元格标记 */
- (void)setTableCellTag:(int)tag {
    [self setInt:tag forKey:__KEY_CELL_TAG];
}

/** 获取单元格标记 */
- (int)tableCellTag {
    return [self getInt:__KEY_CELL_TAG];
}

@end

@implementation WQTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //单元格外不显示
        self.clipsToBounds = YES;
        if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
            self.layoutMargins = UIEdgeInsetsZero;
        }
    }
    return self;
}

+ (id)createCell:(NSString *)reuseIdentifier {
    return [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
}

/** 获取单元格的ID */
+ (NSString *)cellID:(WQTableView *)table {
    return [NSString stringWithFormat:@"%@-%x",[self class],  (unsigned int)table];
}

- (void)bindCellData {
}

@end
