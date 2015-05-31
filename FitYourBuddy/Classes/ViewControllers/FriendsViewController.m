//
//  FriendsViewController.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/2/19.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "FriendsViewController.h"

#import "WQTableView.h"
#import "FriendsStaminaCell.h"
#import "FriendsStrengthCell.h"

static UIEdgeInsets const popViewInset       = (UIEdgeInsets){0,0,320,280};//弹出框，分别为（上，左，高，宽）
static CGFloat      const popIconWidth       = 40.0f;
static CGFloat      const popIconLeftPadding = 40.0f;

@interface FriendsViewController ()

@property (nonatomic, strong) UIButton          *staminaBtn;
@property (nonatomic, strong) UIButton          *strengthBtn;
@property (nonatomic, strong) WQTableView       *tabelView;

@end

@implementation FriendsViewController

#pragma mark - 生命循环
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"萌胖圈";
    self.view.backgroundColor = indexBackgroundColor;
    
    [self initSegment];
    
    [self initTable];
}

#pragma mark - Event Method
- (void)tappedSegmentBtn:(UIButton *)button {
    if (button.selected) {
        return;
    } else {
        if (button == _staminaBtn) {
            _staminaBtn.selected = YES;
            _strengthBtn.selected = NO;
        } else {
            _staminaBtn.selected = NO;
            _strengthBtn.selected = YES;
        }
        [self.tabelView setContentOffset:CGPointMake(0, 0) animated:NO];
        [self.tabelView reloadData];
    }
}
- (void)initSegment {
    UIView *segmentView = [[UIView alloc] initWithFrame:CGRectMake(20, 10, self.view.width - 40, 30.0f)];
    segmentView.layer.cornerRadius = 10.0f;
    segmentView.layer.masksToBounds = YES;
    segmentView.layer.borderColor = themePureBlueColor.CGColor;
    segmentView.layer.borderWidth = 1.0f;
    [self.view addSubview:segmentView];
    
    UIImage *blueImage = [UIImage imageWithUIColor:themePureBlueColor andCGSize:CGSizeMake(segmentView.width / 2.0f, segmentView.height)];
    UIImage *blueBlurImage = [UIImage imageWithUIColor:themeBlueColor andCGSize:CGSizeMake(segmentView.width / 2.0f, segmentView.height)];
    UIImage *whiteImage = [UIImage imageWithUIColor:[UIColor whiteColor] andCGSize:CGSizeMake(segmentView.width / 2.0f, segmentView.height)];
    
    _staminaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _staminaBtn.frame = CGRectMake(0, 0, segmentView.width / 2.0f, segmentView.height);
    _staminaBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [_staminaBtn setTitle:@"毅力榜" forState:UIControlStateNormal];
    [_staminaBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_staminaBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_staminaBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected | UIControlStateHighlighted];
    [_staminaBtn setTitleColor:themePureBlueColor forState:UIControlStateNormal];
    [_staminaBtn setBackgroundImage:blueImage forState:UIControlStateSelected];
    [_staminaBtn setBackgroundImage:blueBlurImage forState:UIControlStateHighlighted];
    [_staminaBtn setBackgroundImage:blueImage forState:UIControlStateSelected | UIControlStateHighlighted];
    [_staminaBtn setBackgroundImage:whiteImage forState:UIControlStateNormal];
    [_staminaBtn setSelected:YES];
    [_staminaBtn addTarget:self action:@selector(tappedSegmentBtn:) forControlEvents:UIControlEventTouchUpInside];
    [segmentView addSubview:_staminaBtn];
    
    _strengthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _strengthBtn.frame = CGRectMake(segmentView.width / 2.0f, 0, segmentView.width / 2.0f, segmentView.height);
    _strengthBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [_strengthBtn setTitle:@"实力榜" forState:UIControlStateNormal];
    [_strengthBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_strengthBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_strengthBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected | UIControlStateHighlighted];
    [_strengthBtn setTitleColor:themePureBlueColor forState:UIControlStateNormal];
    [_strengthBtn setBackgroundImage:blueImage forState:UIControlStateSelected];
    [_strengthBtn setBackgroundImage:blueBlurImage forState:UIControlStateHighlighted];
    [_strengthBtn setBackgroundImage:blueImage forState:UIControlStateSelected | UIControlStateHighlighted];
    [_strengthBtn setBackgroundImage:whiteImage forState:UIControlStateNormal];
    [_strengthBtn addTarget:self action:@selector(tappedSegmentBtn:) forControlEvents:UIControlEventTouchUpInside];
    [segmentView addSubview:_strengthBtn];
}

- (void)initTable {
    self.tabelView = [[WQTableView alloc] initWithStyle:YES];
    self.tabelView.frame = CGRectMake(20, 50, self.view.width - 40, APPCONFIG_UI_SCREEN_VHEIGHT - 60);
    self.tabelView.backgroundColor = [UIColor whiteColor];
    self.tabelView.layer.cornerRadius = 10;
    self.tabelView.layer.masksToBounds = YES;
    self.tabelView.layer.borderWidth = 1.0f;
    self.tabelView.layer.borderColor = themePureBlueColor.CGColor;
    self.tabelView.ctrl = self;
    [self.view addSubview:self.tabelView];
    
    __weak typeof(self) __weakMe = self;
    
    //计算单元格的高度
    self.tabelView.heightForRow = ^CGFloat(WQTableView *tableView, NSIndexPath *indexPath) {
        return 50.0f;
    };
    
    //单元格点击事件
    self.tabelView.didSelectRow = ^(WQTableView *table, NSIndexPath *indexPath) {
        [__weakMe didSelectedCell:table indexPath:indexPath];
    };
    
    //单元格样式
    self.tabelView.modifiRowClass = ^(WQTableView *table, Class originClass, NSIndexPath *indexPath) {
        if (__weakMe.staminaBtn.selected) {
            if (indexPath.row == 5) {
                return [FriendsMyStaminaCell class];
            }
            return [FriendsStaminaCell class];
        } else {
            if (indexPath.row == 3) {
                return [FriendsMyStrengthCell class];
            }
            return [FriendsStrengthCell class];
        }
    };
    //一定要在modifiRowClass后取消分割线
    self.tabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - WQTableView Method
/** 点击单元格 */
- (void)didSelectedCell:(WQTableView *)table indexPath:(NSIndexPath *)indexPath {
    UIButton *backgroundButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backgroundButton.frame = self.view.window.bounds;
    backgroundButton.backgroundColor = popBackgroundColor;
    [backgroundButton addTarget:self action:@selector(tappedCoverBackgroundButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view.window addSubview:backgroundButton];
    
    UIView *popView = [CommonUtil createView];
    popView.frame = CGRectMake(0, 0, popViewInset.right, popViewInset.bottom);
    popView.center = backgroundButton.center;
    popView.layer.borderColor = themeDeepBlueColor.CGColor;
    popView.layer.borderWidth = 2.0f;
    [backgroundButton addSubview:popView];
    
    UILabel *nameLabel = [CommonUtil createLabelWithText:@"萱萱" andFont:[UIFont systemFontOfSize:20.0f]];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.frame = CGRectMake(0, 10, popView.width, 30.0f);
    [popView addSubview:nameLabel];
    
    UIImageView *nameImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(nameLabel.frame) + 10.0f, popView.width, 200)];
    [nameImage setImage:[UIImage imageNamed:@"LittleFatGuy"]];
    [nameImage setContentMode:UIViewContentModeScaleAspectFit];
    [popView addSubview:nameImage];
    
    UIImageView *calendarImage = [[UIImageView alloc] initWithFrame:CGRectMake(popIconLeftPadding, CGRectGetMaxY(nameImage.frame) + 10.0f, popIconWidth, popIconWidth)];
    calendarImage.image = [UIImage imageNamed:@"CalendarIcon"];
    [popView addSubview:calendarImage];
    
    UILabel *calendarLabel = [CommonUtil createLabelWithText:@"100"];
    calendarLabel.frame = CGRectMake(0, 0, 50, popIconWidth);
    [calendarLabel rightOfView:calendarImage withMargin:APPCONFIG_UI_VIEW_BETWEEN_PADDING sameVertical:YES];
    [popView addSubview:calendarLabel];
    
    UILabel *outLineLabel = [CommonUtil createLabelWithText:@"男神"];
    outLineLabel.frame = CGRectMake(popView.width - popIconLeftPadding - 50, CGRectGetMaxY(nameImage.frame) + 10.0f, 50, popIconWidth);
    [popView addSubview:outLineLabel];
    
    UIImageView *outLineImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, popIconWidth, popIconWidth)];
    outLineImage.image = [UIImage imageNamed:@"OutLineIcon"];
    [outLineImage leftOfView:outLineLabel withMargin:APPCONFIG_UI_VIEW_BETWEEN_PADDING sameVertical:YES];
    [popView addSubview:outLineImage];
}

- (void)tappedCoverBackgroundButton:(UIButton *)button {
    [button removeFromSuperview];
}

@end
