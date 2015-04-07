//
//  HistoryExerciseView.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/4/1.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "HistoryExerciseView.h"

static CGFloat const recordViewBetweenPadding = 20.f;           //个人记录框之间的间距
static CGFloat const recordViewHeight = 70.f;                   //个人记录框高度
static CGFloat const recordViewTipLabelHeight = 40.f;           //个人记录框标题高度

static CGFloat const calorieLabelLeftPadding = 30.f;            //卡路里框左边距
static CGFloat const calorieLabelTopPadding = 10.f;             //卡路里框上边距
static CGFloat const calorieLabelHeight = 30.f;                 //卡路里框高度

static CGFloat const histogramViewBetweenPadding = 10.f;        //柱状图间距
static CGFloat const histogramViewTopPadding = 50.f;            //柱状图上间距
static CGFloat const histogramLabelHeight = 30.f;               //柱状图标签栏高度
static CGFloat const histogramViewDefaultHeight = 10.f;         //柱状图空高度

@interface HistoryExerciseView() {
    CGFloat histogramViewHeight;                                //柱状图的高度
    
    UILabel *dayLabel;                                          //保留一个底部标签栏
}

@property(nonatomic, strong) UIColor *typeColor;                //类型颜色

@property(nonatomic, strong) UILabel *recordLabel;              //个人记录框
@property(nonatomic, strong) UILabel *countLabel;               //生涯总数框
@property(nonatomic, strong) UILabel *calorieLabel;             //卡路里框

@property(nonatomic, strong) UIView *dataView;                  //统计框
@end

@implementation HistoryExerciseView

#pragma mark - 生命周期

- (instancetype)initWithFrame:(CGRect)frame andExerciseType:(ExerciseType)type {
    self = [super initWithFrame:frame];
    if (self) {
        self.exerciseType = type;
        switch (type) { //根据类型设置颜色
            case ExerciseTypePushUp:
                self.typeColor = pushUpColor;
                break;
            case ExerciseTypeSitUp:
                self.typeColor = sitUpColor;
                break;
            case ExerciseTypeSquat:
                self.typeColor = squatColor;
                break;
            case ExerciseTypeWalk:
                self.typeColor = walkColor;
                break;
            default:
                self.typeColor = themeBlueColor;
                break;
        }
        
        [self customeInit];
    }
    return self;
}

- (void)customeInit {
    //个人记录框
    CGFloat recordWidth = (APPCONFIG_UI_SCREEN_FWIDTH - APPCONFIG_UI_VIEW_PADDING * 2 - recordViewBetweenPadding) / 2.0f;
    UIView *recordView = [CommonUtil createViewWithFrame:CGRectMake(APPCONFIG_UI_VIEW_PADDING, APPCONFIG_UI_VIEW_PADDING, recordWidth, recordViewHeight)];
    recordView.layer.borderColor = _typeColor.CGColor;
    [self addSubview:recordView];
    
    UILabel *recordTipLabel = [CommonUtil createLabelWithText:@"个人记录" andTextColor:tipTitleLabelColor andFont:[UIFont systemFontOfSize:18.0] andTextAlignment:NSTextAlignmentCenter];
    recordTipLabel.frame = CGRectMake(0, 0, recordWidth, recordViewTipLabelHeight);
    [recordView addSubview:recordTipLabel];
    
    _recordLabel = [CommonUtil createLabelWithText:@"0" andTextColor:tipTitleLabelColor andFont:[UIFont boldSystemFontOfSize:18.0f] andTextAlignment:NSTextAlignmentCenter];
    _recordLabel.frame = CGRectMake(0, recordViewTipLabelHeight, recordWidth, recordViewHeight - recordViewTipLabelHeight - APPCONFIG_UI_VIEW_BETWEEN_PADDING);//底部留10px
    [recordView addSubview:_recordLabel];
    
    //生涯总数框
    UIView *countView = [CommonUtil createViewWithFrame:CGRectMake(0, 0, recordWidth, recordViewHeight)];
    countView.layer.borderColor = _typeColor.CGColor;
    [self addSubview:countView];
    [countView rightOfView:recordView withMargin:recordViewBetweenPadding sameVertical:YES];
    
    UILabel *countTipLabel = [CommonUtil createLabelWithText:@"生涯总数" andTextColor:tipTitleLabelColor andFont:[UIFont systemFontOfSize:18.0] andTextAlignment:NSTextAlignmentCenter];
    countTipLabel.frame = CGRectMake(0, 0, recordWidth, recordViewTipLabelHeight);
    [countView addSubview:countTipLabel];
    
    _countLabel = [CommonUtil createLabelWithText:@"0" andTextColor:tipTitleLabelColor andFont:[UIFont boldSystemFontOfSize:18.0f] andTextAlignment:NSTextAlignmentCenter];
    _countLabel.frame = CGRectMake(0, recordViewTipLabelHeight, recordWidth, recordViewHeight - recordViewTipLabelHeight - APPCONFIG_UI_VIEW_BETWEEN_PADDING);//底部留10px
    [countView addSubview:_countLabel];
    
    //数据框
    CGFloat dataViewHeight = self.height - CGRectGetMaxY(recordView.frame) - APPCONFIG_UI_VIEW_PADDING - APPCONFIG_UI_VIEW_BETWEEN_PADDING;
    _dataView = [CommonUtil createViewWithFrame:CGRectMake(APPCONFIG_UI_VIEW_PADDING, 0, APPCONFIG_UI_SCREEN_FWIDTH - APPCONFIG_UI_VIEW_PADDING * 2, dataViewHeight) andHasBorder:NO];
    _dataView.backgroundColor = _typeColor;
    [self addSubview:_dataView];
    [_dataView bottomOfView:countView withMargin:APPCONFIG_UI_VIEW_BETWEEN_PADDING];
    
    //卡路里框
    _calorieLabel = [CommonUtil createLabelWithText:@"最近一周共消耗90大卡" andTextColor:tipTitleLabelColor andFont:[UIFont systemFontOfSize:16.0] andTextAlignment:NSTextAlignmentCenter];
    _calorieLabel.frame = CGRectMake(calorieLabelLeftPadding, calorieLabelTopPadding, _dataView.width - calorieLabelLeftPadding * 2, calorieLabelHeight);
    _calorieLabel.backgroundColor = [UIColor whiteColor];
    _calorieLabel.layer.cornerRadius = 12.0f;
    _calorieLabel.layer.masksToBounds = YES;
    [_dataView addSubview:_calorieLabel];
    
    //柱状图
    CGFloat histogramViewMinY = calorieLabelTopPadding + calorieLabelHeight + histogramViewTopPadding;
    histogramViewHeight = dataViewHeight - calorieLabelTopPadding - calorieLabelHeight - histogramViewTopPadding - histogramLabelHeight;
    CGFloat histogramViewWidth = (_dataView.width - histogramViewBetweenPadding * 8) / 7.0f;
    
    NSDate *today = [NSDate date];
    for (int i = 6; i >= 0; i--) {
        NSInteger day = [today previousDayWithNum:i].day;
        
        dayLabel = [CommonUtil createLabelWithText:[NSString getFromInteger:day] andTextColor:[UIColor whiteColor] andFont:[UIFont systemFontOfSize:14.0f] andTextAlignment:NSTextAlignmentCenter];
        dayLabel.frame = CGRectMake(histogramViewBetweenPadding + (histogramViewBetweenPadding + histogramViewWidth) * (6 - i), histogramViewMinY + histogramViewHeight, histogramViewWidth, histogramLabelHeight);
        [_dataView addSubview:dayLabel];
        
        UIView *histogramView = [[UIView alloc] initWithFrame:CGRectMake(histogramViewBetweenPadding + (histogramViewBetweenPadding + histogramViewWidth) * (6 - i), 0 , histogramViewWidth, histogramViewDefaultHeight)];
        histogramView.tag = day;
        [histogramView setBackgroundColor:[UIColor whiteColor]];
        histogramView.layer.cornerRadius = 5;
        histogramView.layer.masksToBounds = YES;
        [_dataView addSubview:histogramView];
        [histogramView topOfView:dayLabel];
    }
}
//由上层控制刷新视图
- (void)reloadData {
    //数据
    NSError *error;
    NSInteger maxExerciseNum = [ExerciseCoreDataHelper getBestNumByType:self.exerciseType withError:&error];
    NSInteger totalCount = [ExerciseCoreDataHelper getTotalNumByType:self.exerciseType withError:&error];
    //更新个人记录和生涯总数
    _recordLabel.text = [NSString getFromInteger:maxExerciseNum];
    _countLabel.text = [NSString getFromInteger:totalCount];
    //更新柱状图
    NSDictionary *dict = [ExerciseCoreDataHelper getOneWeekNumByType:self.exerciseType withError:&error];
    if (dict && dict.count > 0) {
        float maxNum = 0, tmpNum = 0;
        CGRect tmpFrame;
        for (NSString *akey in [dict allKeys]) {
            tmpNum = [[dict objectForKey:akey] floatValue];
            if (tmpNum > maxNum) {
                maxNum = tmpNum;
            }
        }
        if (maxNum > 0) {
            for (NSString *akey in [dict allKeys]) {
                UIView *view = [self findViewByTag:[akey integerValue]];
                if (view) {
                    tmpNum = [[dict objectForKey:akey] floatValue];
                    if (tmpNum > 0) {//必须大于0才有数据条
                        tmpFrame = view.frame;
                        tmpFrame.size.height = (tmpNum / maxNum) * histogramViewHeight;
                        view.frame = tmpFrame;
                        
                        [view topOfView:dayLabel];
                    }
                }
            }
        }
    }
}

//根据tag找uiview 其实uilabel也是uiview
- (UIView *)findViewByTag:(NSInteger)tag {
    for (id obj in _dataView.subviews) {
        if ([obj isKindOfClass:[UIView class]]) {
            if ([(UIView *)obj tag] == tag) {
                return (UIView *)obj;
            }
        }
    }
    return nil;
}

@end
