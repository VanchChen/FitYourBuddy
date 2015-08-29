//
//  FriendsTableViewCell.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/8/29.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "FriendsTableViewCell.h"
#import "WQTableView.h"

static const CGFloat indexLabelWidth = 30.0f;//排名宽度
static const CGFloat scoreLabelWidth = 50.0f;//天数框宽度

@interface FriendsTableViewCell()

@property (nonatomic, strong) UIView      *grayBackgroundView;
@property (nonatomic, strong) UILabel     *cellIndexLabel;
@property (nonatomic, strong) UIView      *personHeadIcon;
@property (nonatomic, strong) UILabel     *cellNameLabel;
@property (nonatomic, strong) UILabel     *cellScoreLabel;

@property (nonatomic, assign) BOOL        isMe;

@end

@implementation FriendsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.isMe = false;
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
        
        _personHeadIcon = [[UIView alloc] initWithFrame:CGRectMake(0, 2, self.height - 14, self.height - 14)];
        _personHeadIcon.backgroundColor = [UIColor whiteColor];
        _personHeadIcon.layer.cornerRadius = _personHeadIcon.width / 2.0f;
        _personHeadIcon.layer.masksToBounds = YES;
        _personHeadIcon.layer.borderColor = [UIColor grayColor].CGColor;
        _personHeadIcon.layer.borderWidth = 1.0f;
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

- (void)bindCellData {
    [super bindCellData];
    
    if ([self.cellDetail getBool:Friends_List_IsMe]) {
        self.cellNameLabel.text = @"我";
        
        if (!self.isMe) {
            self.isMe = true;
            
            self.grayBackgroundView.backgroundColor = themePureBlueColor;
            self.cellIndexLabel.textColor = [UIColor whiteColor];
            self.cellNameLabel.textColor = [UIColor whiteColor];
            self.cellScoreLabel.textColor = [UIColor whiteColor];
        }
    } else {
        self.cellNameLabel.text = [self.cellDetail getString:Friends_List_Name];
        
        if (self.isMe) {
            self.grayBackgroundView.backgroundColor = indexBackgroundColor;
            self.cellIndexLabel.textColor = themePureBlueColor;
            self.cellNameLabel.textColor = [UIColor blackColor];
            self.cellScoreLabel.textColor = [UIColor blackColor];
        }
    }
    
    [self addFatGuyAvatarWithLevel:[self.cellDetail getString:Friends_List_Level]
                            gender:[self.cellDetail getString:Friends_List_Gender]
                               eye:[self.cellDetail getString:Friends_List_Eye]
                             mouth:[self.cellDetail getString:Friends_List_Mouth]];
    
    _cellIndexLabel.text =  [self.cellDetail getString:Friends_List_Rank];
    
}

- (void)addFatGuyAvatarWithLevel:(NSString *)level gender:(NSString *)gender eye:(NSString *)eye mouth:(NSString *)mouth {
    [_personHeadIcon.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIImage *bodyImagePict = [UIImage imageNamed:[NSString stringWithFormat:@"body_%@_%@",gender, level]];
    UIImage *eyeImagePict = [UIImage imageNamed:[NSString stringWithFormat:@"eye_tn_%@_%@",gender, eye]];
    UIImage *mouthImagePict = [UIImage imageNamed:[NSString stringWithFormat:@"mouth_tn_%@_%@",gender, mouth]];
    
    CGRect bodyRect, eyeRect, mouthRect;
    CGFloat eyeGap, mouthGap, offset;
    
    if ([gender isEqualToString:@"0"]) { //男
        bodyRect = CGRectMake(0, 0, _personHeadIcon.width, _personHeadIcon.width * 1.5f);
        eyeGap = 11;
        mouthGap = 17;
        offset = 0;
    } else { //女
        bodyRect = CGRectMake(0, 0, _personHeadIcon.width, _personHeadIcon.width * 2);
        eyeGap = 14;
        mouthGap = 20;
        offset = -0.5f;
    }
    
    CGFloat width = eyeImagePict.size.width / 120.0f * _personHeadIcon.width;
    eyeRect = CGRectMake(0, 0, width, width);
    width = mouthImagePict.size.width / 120.0f * _personHeadIcon.width;
    mouthRect = CGRectMake(0, 0, width, width);
    
    //体型
    UIImageView *bodyImage = [[UIImageView alloc] initWithFrame:bodyRect];
    [bodyImage setImage:bodyImagePict];
    [bodyImage setContentMode:UIViewContentModeScaleAspectFit];
    [_personHeadIcon addSubview:bodyImage];
    
    //眼睛
    UIImageView *_eyeImage = [[UIImageView alloc] initWithFrame:eyeRect];
    [_eyeImage setImage:eyeImagePict];
    [_eyeImage setContentMode:UIViewContentModeScaleAspectFit];
    _eyeImage.center = CGPointMake(_personHeadIcon.width / 2.0f + offset, eyeGap);
    [_personHeadIcon addSubview:_eyeImage];
    
    //嘴巴
    UIImageView *_mouthImage = [[UIImageView alloc] initWithFrame:mouthRect];
    [_mouthImage setImage:mouthImagePict];
    [_mouthImage setContentMode:UIViewContentModeScaleAspectFit];
    _mouthImage.center = CGPointMake(_personHeadIcon.width / 2.0f + offset, mouthGap);
    [_personHeadIcon addSubview:_mouthImage];
}

@end

@implementation FriendsStrengthCell

- (void)bindCellData {
    [super bindCellData];
    
    self.cellScoreLabel.text = [NSString stringWithFormat:@"%d瓦", [self.cellDetail getInt:Friends_List_Fight]];
}

@end

@implementation FriendsStaminaCell

- (void)bindCellData {
    [super bindCellData];
    
    self.cellScoreLabel.text = [NSString stringWithFormat:@"%d天", [self.cellDetail getInt:Friends_List_Count]];
}

@end
