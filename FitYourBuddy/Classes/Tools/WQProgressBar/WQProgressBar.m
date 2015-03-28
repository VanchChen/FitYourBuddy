//
//  WQProgressBar.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/2/20.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "WQProgressBar.h"

@interface WQProgressBar()

@property(nonatomic, strong)UIView  *progressView;
@property(nonatomic, strong)UILabel *levelLabel;

@end

@implementation WQProgressBar

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *diamondImage = [[UIImageView alloc] init];
        diamondImage.frame = CGRectMake(0, 0, frame.size.height, frame.size.height);
        diamondImage.image = [UIImage imageNamed:@"DiamondIcon"];
        diamondImage.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:diamondImage];
        
        _levelLabel = [CommonUtil createLabelWithText:@"1" andTextColor:[UIColor whiteColor] andFont:[UIFont boldSystemFontOfSize:14] andTextAlignment:NSTextAlignmentCenter];
        _levelLabel.frame = CGRectMake(0, 0, 20, 20);
        _levelLabel.center = CGPointMake(diamondImage.center.x, diamondImage.center.y + 10);
        [diamondImage addSubview:_levelLabel];
        
        _progressView = [[UIView alloc] init];
        _progressView.frame = CGRectMake(0, 0, frame.size.width - diamondImage.frame.size.width + 5, 20);
        _progressView.layer.borderColor = levelPurpleColor.CGColor;
        _progressView.layer.borderWidth = 1;
        _progressView.layer.cornerRadius = 10;
        _progressView.layer.masksToBounds = YES;
        [self addSubview:_progressView];
        [_progressView rightOfView:diamondImage withMargin:-5 sameVertical:YES];
        
        [self loadLevelAndExp];
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
    
    _levelLabel.text = level;
    UIView *progressInsideView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, _progressView.height)];
    progressInsideView.backgroundColor = levelPurpleColor;
    [_progressView addSubview:progressInsideView];
    
    [UIView animateWithDuration:0.5 animations:^{
        progressInsideView.frame = CGRectMake(0, 0, exp * _progressView.width, _progressView.height);
    }];
}

@end
