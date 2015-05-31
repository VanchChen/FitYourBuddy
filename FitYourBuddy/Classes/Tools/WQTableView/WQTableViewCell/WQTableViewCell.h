//
//  WQTableViewCell.h
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/4/15.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

@class WQTableView;

@protocol WQTableViewCellDelegate <NSObject>

/** 单元格的表格视图，当单元格显示时会被重新赋值 */
@property (nonatomic,assign) WQTableView *table;

/** 单元格在表格中的位置，当单元格显示时会被重新赋值 */
@property (nonatomic,retain) NSIndexPath *indexPath;

/** 获取一个新的单元格 */
+ (id)createCell:(NSString *)reuseIdentifier;

/** 获取单元格的ID */
+ (NSString *)cellID:(WQTableView *)table;

@end

@interface WQTableViewCell : UITableViewCell <WQTableViewCellDelegate>

/** 单元格的表格视图，当单元格显示时会被重新赋值 */
@property (nonatomic,assign) WQTableView *table;

/** 单元格在表格中的位置，当单元格显示时会被重新赋值 */
@property (nonatomic,retain) NSIndexPath *indexPath;

/** 获取一个新的单元格 */
+ (id)createCell:(NSString *)reuseIdentifier;

/** 获取单元格的ID */
+ (NSString *)cellID:(WQTableView *)table;

@end
