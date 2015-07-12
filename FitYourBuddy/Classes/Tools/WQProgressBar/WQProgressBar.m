//
//  WQProgressBar.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/2/20.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "WQProgressBar.h"

const CGFloat  LevelIconWidth   = 60.0f;
const CGFloat  LevelViewHeight  = 40.0f;

@interface WQProgressBar()

@property(nonatomic, strong) UIView  *progressView;
@property(nonatomic, strong) UILabel *levelLabel;
@property(nonatomic, strong) UILabel *tintLabel;

@end

@implementation WQProgressBar

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *backgroundView = [CommonUtil createViewWithFrame:CGRectMake(LevelIconWidth / 4.0f, self.height - LevelViewHeight, self.width - LevelIconWidth / 4.0f, LevelViewHeight) andHasBorder:NO];
        backgroundView.layer.cornerRadius = 10.0f;
        [self addSubview:backgroundView];
        
        UIImageView *diamondImage = [[UIImageView alloc] init];
        diamondImage.frame = CGRectMake(0, 0, frame.size.height, frame.size.height);
        diamondImage.image = [UIImage imageNamed:@"OutLineIcon"];
        diamondImage.contentMode = UIViewContentModeScaleAspectFit;
        diamondImage.layer.cornerRadius = LevelIconWidth/2.0f;
        diamondImage.layer.masksToBounds = YES;
        diamondImage.layer.borderColor = [UIColor whiteColor].CGColor;
        diamondImage.layer.borderWidth = 4.0f;
        [self addSubview:diamondImage];
        
        _levelLabel = [CommonUtil createLabelWithText:@"Lv.6 男神" andTextColor:tipTitleLabelColor andFont:[UIFont boldSystemFontOfSize:12] andTextAlignment:NSTextAlignmentCenter];
        _levelLabel.frame = CGRectMake(10, 0, self.width - 10, 20);
        [backgroundView addSubview:_levelLabel];
        
        _progressView = [[UIView alloc] init];
        _progressView.backgroundColor = startTrainTargetGreyColor;
        _progressView.frame = CGRectMake(30, backgroundView.height - 5 - 12, backgroundView.width - 30 - 7, 12);
        _progressView.layer.cornerRadius = 4;
        _progressView.layer.masksToBounds = YES;
        [backgroundView addSubview:_progressView];
        
        _tintLabel = [CommonUtil createLabelWithText:@"等级" andTextColor:tipTitleLabelColor andFont:[UIFont systemFontOfSize:10] andTextAlignment:NSTextAlignmentRight];
        _tintLabel.frame = CGRectMake(self.width - APPCONFIG_UI_VIEW_BETWEEN_PADDING - 40, 0, 40, 10);
        [_tintLabel topOfView:backgroundView withMargin:3.0f];
        [self addSubview:_tintLabel];
    }
    return self;
}

- (void)loadLevelAndExp {
    //获取等级和经验
    NSError *error;
    NSDictionary * accountDict = [AccountCoreDataHelper getAccountDictionaryWithError:&error];
    NSString *level = accountDict[@"level"];
    float fullExp = [CommonUtil getExpFromLevel:accountDict[@"level"]];
    float exp = [accountDict[@"exp"] floatValue];
    exp = exp / fullExp;
    
    _levelLabel.text = [NSString stringWithFormat:@"Lv.%@", level];
    UIView *progressInsideView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, _progressView.height)];
    progressInsideView.backgroundColor = themePureBlueColor;
    progressInsideView.layer.cornerRadius = 2;
    [_progressView addSubview:progressInsideView];
    
    [UIView animateWithDuration:0.5 animations:^{
        progressInsideView.frame = CGRectMake(0, 0, exp * _progressView.width, _progressView.height);
    }];
}

- (void)simpleVersion {
    _levelLabel.hidden = YES;
    _tintLabel.hidden = YES;
    
    _progressView.frame = CGRectMake(30, LevelViewHeight - 5 - 16, _progressView.frame.size.width, 16);
}

@end
