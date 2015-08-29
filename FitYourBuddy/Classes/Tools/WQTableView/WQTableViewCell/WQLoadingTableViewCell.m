//
//  WQLoadingTableViewCell.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/8/22.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "WQLoadingTableViewCell.h"

#define ACTIVITYVIEW_HEIGHT   20.0f
#define ACTIVITYVIEW_WIDTH    20.0f
#define ACTIVITYVIEW_PADDING  5.0f

@interface WQLoadingTips : UIView

@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) UILabel *loadingLabel;

//显示加载信息
- (void)showLoadingView;

@end

@implementation WQLoadingTips

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _loadingLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _loadingLabel.backgroundColor = [UIColor clearColor];
        _loadingLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _loadingLabel.font = [UIFont systemFontOfSize:__FONT_TABLE_DEFAULT_TIPS];
        _loadingLabel.numberOfLines = 0;
        _loadingLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_loadingLabel];
        
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityView.backgroundColor = [UIColor clearColor];
        [_activityView startAnimating];
        [self addSubview:_activityView];
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self resetSubViewsFrame];
}

- (void)resetSubViewsFrame {
    [_loadingLabel sizeToFit];
    [_loadingLabel setHeight:CGRectGetHeight(self.bounds)];
    [_loadingLabel centerOfView:self];
    
    _activityView.frame = CGRectMake(0, 0, ACTIVITYVIEW_WIDTH, ACTIVITYVIEW_HEIGHT);
    [_activityView leftOfView:_loadingLabel withMargin:ACTIVITYVIEW_PADDING sameVertical:YES];
}

- (void)showLoadingView {
    [self resetSubViewsFrame];
}

@end

@interface WQLoadingTableViewCell ()

@property (nonatomic, strong) WQLoadingTips *loadingView;

@end

@implementation WQLoadingTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    //没箭头，不能点击
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.userInteractionEnabled = NO;
    
    self.loadingView = [[WQLoadingTips alloc] initWithFrame:CGRectZero];
    self.loadingView.loadingLabel.textColor = __COLOR_TABLE_DEFAULT_TIPS;
    [self addSubview:self.loadingView];
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.loadingView.frame = CGRectMake(2 * APPCONFIG_UI_TABLE_PADDING, 0, CGRectGetWidth(self.bounds) - 4 * APPCONFIG_UI_TABLE_PADDING, CGRectGetHeight(self.bounds));
}
- (void)bindCellData {
    [super bindCellData];
    
    //默认加载中
    self.loadingView.loadingLabel.text = @"数据载入中…";
    [self.loadingView showLoadingView];
}

@end
