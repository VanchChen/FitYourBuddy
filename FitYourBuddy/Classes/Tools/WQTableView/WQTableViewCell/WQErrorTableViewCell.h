//
//  WQErrorTableViewCell.h
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/8/22.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "WQTableViewCell.h"

@interface WQErrorTableViewCell : WQTableViewCell

@property (nonatomic, copy) NSString *errorMessage;
@property (nonatomic, strong) UILabel *displayLabel;

//加载错误数据
- (void)loadErrorMessage;

@end

@interface WQEmptyTableViewCell : WQErrorTableViewCell

@end

@interface WQFinishedTableViewCell : WQErrorTableViewCell

@end