//
//  WQMoreTableViewCell.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/8/22.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "WQMoreTableViewCell.h"
#import "WQTableData.h"

@interface WQMoreTableViewCell ()

@property (nonatomic, strong) UILabel *displayLabel;

@end

@implementation WQMoreTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.displayLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.displayLabel.font = [UIFont systemFontOfSize:__FONT_TABLE_DEFAULT_TIPS];
    self.displayLabel.textAlignment = NSTextAlignmentCenter;
    self.displayLabel.backgroundColor = [UIColor clearColor];
    self.displayLabel.textColor = __COLOR_TABLE_DEFAULT_TIPS;
    [self addSubview:self.displayLabel];
    
    return self;
}

- (void)layoutSubviews
{
    self.displayLabel.frame = self.bounds;
}

- (void)bindCellData{
    [super bindCellData];
    
    self.displayLabel.text = [NSString stringWithFormat:@"显示下 %ld 条", (long)self.tableData.pageSize];
}

@end
