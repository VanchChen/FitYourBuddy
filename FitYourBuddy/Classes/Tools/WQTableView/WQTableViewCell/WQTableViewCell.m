//
//  WQTableViewCell.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/4/15.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "WQTableViewCell.h"

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

@end
