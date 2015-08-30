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
static CGFloat const recordViewTipLabelHeight = 35.f;           //个人记录框标题高度

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

@property(nonatomic, strong) UILabel *numLabel;                 //数字框

@property(nonatomic, strong) UIView *dataView;                  //统计框

@property(nonatomic, strong) NSDictionary *dataDict;            //数据

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
    self.backgroundColor = [UIColor whiteColor];
    
    _numLabel = nil;//数字框，一开始不显示
    
    //个人记录框
    CGFloat recordWidth = (APPCONFIG_UI_SCREEN_FWIDTH - APPCONFIG_UI_VIEW_PADDING * 2 - recordViewBetweenPadding) / 2.0f;
    UIView *recordView = [CommonUtil createViewWithFrame:CGRectMake(APPCONFIG_UI_VIEW_PADDING, APPCONFIG_UI_VIEW_PADDING, recordWidth, recordViewHeight)];
    recordView.layer.borderColor = _typeColor.CGColor;
    recordView.layer.borderWidth = 2.0f;
    [self addSubview:recordView];
    
    UILabel *recordTipLabel = [CommonUtil createLabelWithText:@"个人记录" andTextColor:tipTitleLabelColor andFont:[UIFont systemFontOfSize:16.0] andTextAlignment:NSTextAlignmentCenter];
    recordTipLabel.frame = CGRectMake(0, 0, recordWidth, recordViewTipLabelHeight);
    [recordView addSubview:recordTipLabel];
    
    _recordLabel = [CommonUtil createLabelWithText:@"0" andTextColor:_typeColor andFont:[UIFont boldSystemFontOfSize:24.0f] andTextAlignment:NSTextAlignmentCenter];
    _recordLabel.frame = CGRectMake(0, recordViewTipLabelHeight, recordWidth, recordViewHeight - recordViewTipLabelHeight - APPCONFIG_UI_VIEW_BETWEEN_PADDING);//底部留10px
    [recordView addSubview:_recordLabel];
    
    //生涯总数框
    UIView *countView = [CommonUtil createViewWithFrame:CGRectMake(0, 0, recordWidth, recordViewHeight)];
    countView.layer.borderColor = _typeColor.CGColor;
    countView.layer.borderWidth = 2.0f;
    [self addSubview:countView];
    [countView rightOfView:recordView withMargin:recordViewBetweenPadding sameVertical:YES];
    
    UILabel *countTipLabel = [CommonUtil createLabelWithText:@"生涯总数" andTextColor:tipTitleLabelColor andFont:[UIFont systemFontOfSize:16.0] andTextAlignment:NSTextAlignmentCenter];
    countTipLabel.frame = CGRectMake(0, 0, recordWidth, recordViewTipLabelHeight);
    [countView addSubview:countTipLabel];
    
    _countLabel = [CommonUtil createLabelWithText:@"0" andTextColor:_typeColor andFont:[UIFont boldSystemFontOfSize:24.0f] andTextAlignment:NSTextAlignmentCenter];
    _countLabel.frame = CGRectMake(0, recordViewTipLabelHeight, recordWidth, recordViewHeight - recordViewTipLabelHeight - APPCONFIG_UI_VIEW_BETWEEN_PADDING);//底部留10px
    [countView addSubview:_countLabel];
    
    //数据框
    CGFloat dataViewHeight = self.height - CGRectGetMaxY(recordView.frame) - APPCONFIG_UI_VIEW_PADDING - APPCONFIG_UI_VIEW_PADDING;
    _dataView = [CommonUtil createViewWithFrame:CGRectMake(APPCONFIG_UI_VIEW_PADDING, 0, APPCONFIG_UI_SCREEN_FWIDTH - APPCONFIG_UI_VIEW_PADDING * 2, dataViewHeight) andHasBorder:NO];
    _dataView.backgroundColor = _typeColor;
    [self addSubview:_dataView];
    [_dataView bottomOfView:countView withMargin:APPCONFIG_UI_VIEW_PADDING];
    
    //卡路里框
    _calorieLabel = [CommonUtil createLabelWithText:@"最近七天共消耗卡路里90千卡" andTextColor:[UIColor whiteColor] andFont:[UIFont boldSystemFontOfSize:16.0] andTextAlignment:NSTextAlignmentCenter];
    _calorieLabel.frame = CGRectMake(calorieLabelLeftPadding, calorieLabelTopPadding, _dataView.width - calorieLabelLeftPadding * 2, calorieLabelHeight);
    _calorieLabel.backgroundColor = [UIColor clearColor];
    //_calorieLabel.layer.cornerRadius = 12.0f;
    //_calorieLabel.layer.masksToBounds = YES;
    [_dataView addSubview:_calorieLabel];
    
    //柱状图
    CGFloat histogramViewMinY = calorieLabelTopPadding + calorieLabelHeight + histogramViewTopPadding;
    histogramViewHeight = dataViewHeight - calorieLabelTopPadding - calorieLabelHeight - histogramViewTopPadding - histogramLabelHeight;
    CGFloat histogramViewWidth = (_dataView.width - histogramViewBetweenPadding * 8) / 7.0f;
    
    NSDate *today = [NSDate date];
    for (int i = 6; i >= 0; i--) {
        NSInteger day = [today previousDayWithNum:i].day;
        
        dayLabel = [CommonUtil createLabelWithText:[NSString stringFromInteger:day] andTextColor:[UIColor whiteColor] andFont:[UIFont systemFontOfSize:14.0f] andTextAlignment:NSTextAlignmentCenter];
        dayLabel.frame = CGRectMake(histogramViewBetweenPadding + (histogramViewBetweenPadding + histogramViewWidth) * (6 - i), histogramViewMinY + histogramViewHeight, histogramViewWidth, histogramLabelHeight);
        [_dataView addSubview:dayLabel];
        
        UIButton *histogramView = [[UIButton alloc] initWithFrame:CGRectMake(histogramViewBetweenPadding + (histogramViewBetweenPadding + histogramViewWidth) * (6 - i), 0 , histogramViewWidth, histogramViewDefaultHeight)];
        histogramView.tag = day;
        histogramView.layer.cornerRadius = 5;
        histogramView.layer.masksToBounds = YES;
        [histogramView setBackgroundImage:[UIImage imageWithUIColor:[UIColor whiteColor] andCGSize:histogramView.bounds.size] forState:UIControlStateNormal];
        [histogramView setBackgroundImage:[UIImage imageWithUIColor:transparentWhiteColor andCGSize:histogramView.bounds.size] forState:UIControlStateSelected];
        [histogramView addTarget:self action:@selector(tappedHistogramView:) forControlEvents:UIControlEventTouchUpInside];
        [_dataView addSubview:histogramView];
        [histogramView topOfView:dayLabel];
    }
}

#pragma mark - 事件
//由上层控制刷新视图
- (void)reloadData {
    //数据
    NSError *error;
    NSInteger maxExerciseNum = [ExerciseCoreDataHelper getBestNumByType:self.exerciseType withError:&error];
    NSInteger totalCount = [ExerciseCoreDataHelper getTotalNumByType:self.exerciseType withError:&error];
    //更新个人记录和生涯总数
    _recordLabel.text = [NSString stringFromInteger:maxExerciseNum];
    _countLabel.text = [NSString stringFromInteger:totalCount];
    //更新柱状图
    _dataDict = [ExerciseCoreDataHelper getOneWeekNumByType:self.exerciseType withError:&error];
    if (_dataDict && _dataDict.count > 0) {
        float maxNum = 0, tmpNum = 0, tmpHeight, totalNum = 0;
        CGRect tmpFrame;
        for (NSString *akey in [_dataDict allKeys]) {
            tmpNum = [[_dataDict objectForKey:akey] floatValue];
            if (tmpNum > maxNum) {
                maxNum = tmpNum;
            }
            totalNum += tmpNum;
        }
        //更新卡路里
        switch (self.exerciseType) {
            case ExerciseTypeSitUp: {
                totalNum = totalNum * 200;
                break;
            }
            case ExerciseTypePushUp: {
                totalNum = totalNum * 400;
                break;
            }
            case ExerciseTypeSquat: {
                totalNum = totalNum * 200;
                break;
            }
            case ExerciseTypeWalk: {
                totalNum = totalNum * 40;
                break;
            }
            default: {
                break;
            }
        }
        
        if (totalNum > 1000) {
            _calorieLabel.text = [NSString stringWithFormat:@"最近七天共消耗卡路里%.f千卡", totalNum / 1000.0f];
        } else {
            _calorieLabel.text = [NSString stringWithFormat:@"最近七天共消耗卡路里%.f卡", totalNum];
        }
        
        if (maxNum > 0) {
            for (NSString *akey in [_dataDict allKeys]) {
                UIView *view = [self findViewByTag:[akey integerValue]];
                if (view) {
                    tmpNum = [[_dataDict objectForKey:akey] floatValue];
                    if (tmpNum > 0) {//必须大于0才有数据条
                        tmpFrame = view.frame;
                        tmpHeight = (tmpNum / maxNum) * histogramViewHeight;
                        if (tmpHeight < histogramViewDefaultHeight) {
                            tmpHeight = histogramViewDefaultHeight;
                        }
                        tmpFrame.size.height = tmpHeight;
                        view.frame = tmpFrame;
                        
                        [view topOfView:dayLabel];
                    }
                }
            }
        }
    }
}

//点击柱状图
- (void)tappedHistogramView:(UIButton *)button {
    //先找到上一个
    UIButton *tmpButton = [self findButtonInView:_dataView];
    if (tmpButton) {
        tmpButton.selected = NO;
    }
    //再把当前这个选中
    button.selected = YES;
    
    //显示框
    NSString *numString = @"";
    if (_dataDict && _dataDict.count > 0) {
        numString = [_dataDict valueForKey:[NSString stringFromInteger:button.tag]];
    }
    
    if (numString.length == 0) {
        numString = @"0";
    }
    
    if (!_numLabel) {
        CGFloat histogramViewWidth = (_dataView.width - histogramViewBetweenPadding * 8) / 7.0f;
        
        _numLabel = [CommonUtil createLabelWithText:@"" andTextColor:[UIColor whiteColor] andFont:[UIFont systemFontOfSize:20] andTextAlignment:NSTextAlignmentCenter];
        _numLabel.frame = CGRectMake(0, 0, histogramViewWidth, histogramViewWidth);
        _numLabel.layer.borderColor = [UIColor whiteColor].CGColor;
        _numLabel.layer.borderWidth = 1.0f;
        _numLabel.layer.cornerRadius = 5.0f;
        [_dataView addSubview:_numLabel];
    }
    _numLabel.text = numString;
    [_numLabel topOfView:button withMargin:APPCONFIG_UI_VIEW_BETWEEN_PADDING sameHorizontal:YES];
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

//找到选中的button
- (UIButton *)findButtonInView:(UIView *)view {
    UIButton *tmpButton;
    for (id obj in _dataView.subviews) {
        if ([obj isMemberOfClass:[UIButton class]]) {
            tmpButton = (UIButton *)obj;
            if (tmpButton.selected) {
                return tmpButton;
            }
        }
    }
    return nil;
}

@end
