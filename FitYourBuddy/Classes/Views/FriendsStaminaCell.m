//
//  FriendsStaminaCell.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/5/16.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "FriendsStaminaCell.h"

static const CGFloat indexLabelWidth = 30.0f;//排名宽度
static const CGFloat scoreLabelWidth = 50.0f;//天数框宽度

@interface FriendsStaminaCell()

@property (nonatomic, strong) UIView      *grayBackgroundView;
@property (nonatomic, strong) UILabel     *cellIndexLabel;
@property (nonatomic, strong) UIImageView *personHeadIcon;
@property (nonatomic, strong) UILabel     *cellNameLabel;
@property (nonatomic, strong) UILabel     *cellScoreLabel;

@end

@implementation FriendsStaminaCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone; //取消点击效果
        self.backgroundColor = [UIColor clearColor];
        
        _grayBackgroundView = [[UIView alloc] init];
        _grayBackgroundView.backgroundColor = indexBackgroundColor;
        _grayBackgroundView.layer.cornerRadius = 10.0f;
        _grayBackgroundView.layer.masksToBounds = YES;
        [self addSubview:_grayBackgroundView];
        
        _cellIndexLabel = [CommonUtil createLabelWithText:@"1" andTextColor:themePureBlueColor];
        [_cellIndexLabel setTextAlignment:NSTextAlignmentCenter];
        [_grayBackgroundView addSubview:_cellIndexLabel];
        
        _personHeadIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2, self.height - 14, self.height - 14)];
        _personHeadIcon.backgroundColor = [UIColor whiteColor];
        _personHeadIcon.layer.cornerRadius = _personHeadIcon.width / 2.0f;
        _personHeadIcon.layer.masksToBounds = YES;
        _personHeadIcon.layer.borderColor = [UIColor grayColor].CGColor;
        _personHeadIcon.layer.borderWidth = 1.0f;
        _personHeadIcon.image = [UIImage imageNamed:@"LittleFatGuy"];
        [_grayBackgroundView addSubview:_personHeadIcon];
        
        _cellNameLabel = [CommonUtil createLabelWithText:@"小胖砸" andFont:[UIFont systemFontOfSize:15.0f]];
        [_grayBackgroundView addSubview:_cellNameLabel];
        
        _cellScoreLabel = [CommonUtil createLabelWithText:@"69天" andTextColor:[UIColor blackColor] andFont:[UIFont systemFontOfSize:15.0f] andTextAlignment:NSTextAlignmentRight];
        [_grayBackgroundView addSubview:_cellScoreLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _grayBackgroundView.frame = CGRectMake(20, 5, self.width - 40, self.height - 10);
    _cellIndexLabel.frame = CGRectMake(10, 0, indexLabelWidth, _grayBackgroundView.height);
    [_personHeadIcon rightOfView:_cellIndexLabel withMargin:10.0f sameVertical:YES];
    CGFloat nameLabelWidth = _grayBackgroundView.width - scoreLabelWidth - CGRectGetMaxX(_personHeadIcon.frame) - 20;//两边的间距
    _cellNameLabel.frame = CGRectMake(CGRectGetMaxX(_personHeadIcon.frame) + 10, 0, nameLabelWidth, _grayBackgroundView.height);
    _cellScoreLabel.frame = CGRectMake(CGRectGetMaxX(_cellNameLabel.frame), 0, scoreLabelWidth, _grayBackgroundView.height);
}

@end

@implementation FriendsMyStaminaCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.grayBackgroundView.backgroundColor = themePureBlueColor;
        self.cellNameLabel.text = @"我";
        
        self.cellIndexLabel.textColor = [UIColor whiteColor];
        self.cellNameLabel.textColor = [UIColor whiteColor];
        self.cellScoreLabel.textColor = [UIColor whiteColor];
    }
    return self;
}

@end
