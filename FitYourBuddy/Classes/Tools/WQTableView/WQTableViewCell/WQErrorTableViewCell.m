//
//  WQErrorTableViewCell.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/8/22.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "WQErrorTableViewCell.h"

#import "WQTableData.h"
#import "DataItemResult.h"

@implementation WQErrorTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.displayLabel = [UILabel new];
    self.displayLabel.font = [UIFont systemFontOfSize:__FONT_TABLE_DEFAULT_TIPS];
    self.displayLabel.textAlignment = NSTextAlignmentCenter;
    self.displayLabel.backgroundColor = [UIColor clearColor];
    self.displayLabel.textColor = __COLOR_TABLE_DEFAULT_TIPS;
    [self.contentView addSubview:self.displayLabel];
    
    self.displayLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    return self;
}

- (void)layoutSubviews {
    self.displayLabel.frame = self.contentView.bounds;
}

- (void)bindCellData {
    [super bindCellData];
    
    //加载错误信息
    [self loadErrorMessage];
}

//加载错误数据
- (void)loadErrorMessage {
    NSString *errorStr = self.tableData.tableDataResult.message;
    NSString *defaultMessage = __REMIND_LOADINGFAIL;
    self.displayLabel.hidden = NO;
    if (self.tableData.pageAt > 1) {
        self.displayLabel.text = defaultMessage;
    } else {
        self.displayLabel.text = errorStr.length == 0 ? defaultMessage : errorStr;
    }
    
    self.errorMessage = self.displayLabel.text;
}

@end

@implementation WQEmptyTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.errorMessage = @"数据为空！";
    return self;
}

//加载错误数据
-(void)loadErrorMessage {
    NSString *errorStr = self.tableData.tableDataResult.message;
    self.displayLabel.text = errorStr.length == 0 ? @"数据为空！" : errorStr;
}

@end

@implementation WQFinishedTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    //没箭头，不能点击
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.userInteractionEnabled = NO;
    
    return self;
}

- (void)bindCellData {
    [super bindCellData];
    
    self.displayLabel.text = @"数据已经加载完毕!";
}

@end
