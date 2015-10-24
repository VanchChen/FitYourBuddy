//
//  HistoryViewController.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/2/19.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "HistoryViewController.h"
#import "HistoryExerciseView.h"

static CGFloat const ScrollTitleViewHeight = 60.0f;             //整个条的高度
static CGFloat const BallonHeight = 28.0f;                      //小球的高度
//static CGFloat const BallonHalfHeight = BallonHeight / 2.0f;    //小球一半高度，用来计算边角
static CGFloat const BallonTopPadding = (ScrollTitleViewHeight - BallonHeight) / 2.0f;//小球的上边距
static CGFloat const BallonTitlePadding = 5.0f;                 //球和标题的间距
static CGFloat const TitleWidth = 80.0f;                        //标题框的宽度
static CGFloat const FontFloat = 16.0f;                         //字体

static CGFloat const TriangleWidht = 16.0f;                     //小三角
static CGFloat const TriangleHeight = 12.0f;
static CGFloat const TriangleLeftPadding = 40.0f;


@interface HistoryViewController ()<UIScrollViewDelegate>
{
    float fadeRatio;                //左边小球的移动系数
    float fontRatio;
    float longDistanceRatio;
    float shortDistanceRatio;
    
    NSInteger   page;
    
    UIImageView *melodyB, *melodyC, *melodyD, *melodyE, *melodyF, *melodyG, *melodyA;
    UILabel     *sharpB, *sharpC, *sharpD, *sharpA;
    
    NSArray     *viewArray;
}

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"统计";
    
    //各种系数
    fadeRatio = (BallonHeight + APPCONFIG_UI_VIEW_BETWEEN_PADDING * 2) / (APPCONFIG_UI_SCREEN_FWIDTH);
    fontRatio = FontFloat / APPCONFIG_UI_SCREEN_FWIDTH;
    longDistanceRatio = (APPCONFIG_UI_SCREEN_FWIDTH - (APPCONFIG_UI_VIEW_BETWEEN_PADDING + BallonHeight )* 3 - APPCONFIG_UI_VIEW_BETWEEN_PADDING) / APPCONFIG_UI_SCREEN_FWIDTH;
    shortDistanceRatio = (BallonHeight + APPCONFIG_UI_VIEW_BETWEEN_PADDING) / (APPCONFIG_UI_SCREEN_FWIDTH);
    page = 1;
    
    UIView* scrollTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPCONFIG_UI_SCREEN_FWIDTH, ScrollTitleViewHeight)];
    [scrollTitleView setBackgroundColor:indexBackgroundColor];
    [self.view addSubview:scrollTitleView];
    
    //小三角
    UIImageView *triangleView = [[UIImageView alloc] initWithFrame:CGRectMake(TriangleLeftPadding, scrollTitleView.height - TriangleHeight, TriangleWidht, TriangleHeight)];
    triangleView.image = [UIImage imageNamed:@"HistoryTriangleIcon"];
    [scrollTitleView addSubview:triangleView];
    
    melodyB = [[UIImageView alloc] initWithFrame:CGRectMake(- APPCONFIG_UI_VIEW_BETWEEN_PADDING - BallonHeight, BallonTopPadding, BallonHeight, BallonHeight)];
    //[melodyB setBackgroundColor:walkColor];
    [melodyB setImage:[UIImage imageWithExerciseType:ExerciseTypeWalk]];
    //[[melodyB layer] setCornerRadius:BallonHalfHeight];
    [scrollTitleView addSubview:melodyB];
    
    sharpB = [[UILabel alloc] initWithFrame:CGRectMake(BallonTitlePadding - APPCONFIG_UI_VIEW_BETWEEN_PADDING , BallonTopPadding, TitleWidth, BallonHeight)];
    [sharpB setText:@"步行"];
    [sharpB setTextColor:tipTitleLabelColor];
    [sharpB setFont:[UIFont boldSystemFontOfSize:0.f]];
    [sharpB setAlpha:0];
    [scrollTitleView addSubview:sharpB];
    
    melodyC = [[UIImageView alloc] initWithFrame:CGRectMake(APPCONFIG_UI_VIEW_BETWEEN_PADDING, BallonTopPadding, BallonHeight, BallonHeight)];
    //[melodyC setBackgroundColor:[UIColor clearColor]];
    [melodyC setImage:[UIImage imageWithExerciseType:ExerciseTypeSitUp]];
    //[[melodyC layer] setCornerRadius:BallonHalfHeight];
    [scrollTitleView addSubview:melodyC];
    
    sharpC = [[UILabel alloc] initWithFrame:CGRectMake(BallonHeight + APPCONFIG_UI_VIEW_BETWEEN_PADDING + BallonTitlePadding, BallonTopPadding, TitleWidth, BallonHeight)];
    [sharpC setText:@"仰卧起坐"];
    [sharpC setTextColor:tipTitleLabelColor];
    [sharpC setFont:[UIFont boldSystemFontOfSize:FontFloat]];
    [sharpC setAlpha:1];
    [scrollTitleView addSubview:sharpC];
    
    melodyD = [[UIImageView alloc] initWithFrame:CGRectMake(APPCONFIG_UI_SCREEN_FWIDTH - (APPCONFIG_UI_VIEW_BETWEEN_PADDING + BallonHeight )* 3, BallonTopPadding, BallonHeight, BallonHeight)];
    //[melodyD setBackgroundColor:pushUpColor];
    [melodyD setImage:[UIImage imageWithExerciseType:ExerciseTypePushUp]];
    //[[melodyD layer] setCornerRadius:BallonHalfHeight];
    [scrollTitleView addSubview:melodyD];
    
    sharpD = [[UILabel alloc] initWithFrame:CGRectMake(APPCONFIG_UI_SCREEN_FWIDTH - (APPCONFIG_UI_VIEW_BETWEEN_PADDING + BallonHeight )* 2 - BallonTitlePadding, BallonTopPadding, TitleWidth, BallonHeight)];
    [sharpD setText:@"俯卧撑"];
    [sharpD setTextColor:tipTitleLabelColor];
    [sharpD setFont:[UIFont boldSystemFontOfSize:0.f]];
    [sharpD setAlpha:0];
    [scrollTitleView addSubview:sharpD];
    
    melodyE = [[UIImageView alloc] initWithFrame:CGRectMake(APPCONFIG_UI_SCREEN_FWIDTH - (APPCONFIG_UI_VIEW_BETWEEN_PADDING + BallonHeight )* 2, BallonTopPadding, BallonHeight, BallonHeight)];
    //[melodyE setBackgroundColor:squatColor];
    [melodyE setImage:[UIImage imageWithExerciseType:ExerciseTypeSquat]];
    //[[melodyE layer] setCornerRadius:BallonHalfHeight];
    [scrollTitleView addSubview:melodyE];
    
    melodyF = [[UIImageView alloc] initWithFrame:CGRectMake(APPCONFIG_UI_SCREEN_FWIDTH - APPCONFIG_UI_VIEW_BETWEEN_PADDING - BallonHeight, BallonTopPadding, BallonHeight, BallonHeight)];
    //[melodyF setBackgroundColor:walkColor];
    [melodyF setImage:[UIImage imageWithExerciseType:ExerciseTypeWalk]];
    //[[melodyF layer] setCornerRadius:BallonHalfHeight];
    [scrollTitleView addSubview:melodyF];
    
    melodyG = [[UIImageView alloc] initWithFrame:CGRectMake(APPCONFIG_UI_SCREEN_FWIDTH + APPCONFIG_UI_VIEW_BETWEEN_PADDING, BallonTopPadding, BallonHeight, BallonHeight)];
    //[melodyG setBackgroundColor:sitUpColor];
    [melodyG setImage:[UIImage imageWithExerciseType:ExerciseTypeSitUp]];
    //[[melodyG layer] setCornerRadius:BallonHalfHeight];
    [scrollTitleView addSubview:melodyG];
    
    melodyA = nil;sharpA = nil;
    
    //统计滚动视图
    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, ScrollTitleViewHeight, APPCONFIG_UI_SCREEN_FWIDTH, APPCONFIG_UI_SCREEN_VHEIGHT - ScrollTitleViewHeight)];
    [scrollView setDelegate:self];
    [scrollView setPagingEnabled:YES];
    scrollView.showsHorizontalScrollIndicator = NO;
    [scrollView setContentSize:CGSizeMake(scrollView.width * 5, scrollView.height)];
    [scrollView setContentOffset:CGPointMake(scrollView.width, 0)];
    [self.view addSubview:scrollView];
    
    HistoryExerciseView *walkView = [[HistoryExerciseView alloc] initWithFrame:CGRectMake(0, 0, scrollView.width, scrollView.height) andExerciseType:ExerciseTypeWalk];
    [scrollView addSubview:walkView];
    
    HistoryExerciseView *sitUpView = [[HistoryExerciseView alloc] initWithFrame:CGRectMake(scrollView.width, 0, scrollView.width, scrollView.height) andExerciseType:ExerciseTypeSitUp];
    [scrollView addSubview:sitUpView];
    
    HistoryExerciseView *pushUpView = [[HistoryExerciseView alloc] initWithFrame:CGRectMake(scrollView.width * 2, 0, scrollView.width, scrollView.height) andExerciseType:ExerciseTypePushUp];
    [scrollView addSubview:pushUpView];
    
    HistoryExerciseView *squatView = [[HistoryExerciseView alloc] initWithFrame:CGRectMake(scrollView.width * 3, 0, scrollView.width, scrollView.height) andExerciseType:ExerciseTypeSquat];
    [scrollView addSubview:squatView];
    
    HistoryExerciseView *walkView2 = [[HistoryExerciseView alloc] initWithFrame:CGRectMake(scrollView.width * 4, 0, scrollView.width, scrollView.height) andExerciseType:ExerciseTypeWalk];
    [scrollView addSubview:walkView2];
    
    //所有view添加到array
    viewArray = @[walkView, sitUpView, pushUpView, squatView, walkView2];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"统计"];
    
    HistoryExerciseView *currentView = [viewArray objectAtIndex:page];
    [currentView dismissSelected];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"统计"];
    
    //每次进入都要重载一下数据
    for (HistoryExerciseView *view in viewArray) {
        [view reloadData];
    }
}

#pragma mark - Scroll View Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    float x = scrollView.contentOffset.x;
    if (x < 0) {
        [self changeScrollViewWithPage:4];
        [scrollView setContentOffset:CGPointMake(scrollView.width * 4 + x, 0)];
    } else if (x > scrollView.frame.size.width * 4) {
        [self changeScrollViewWithPage:0];
        [scrollView setContentOffset:CGPointMake(x - scrollView.width * 4, 0)];
    } else {
        //移动标题栏
        float lx = page * APPCONFIG_UI_SCREEN_FWIDTH - x;
        if (lx > APPCONFIG_UI_SCREEN_FWIDTH || lx < - APPCONFIG_UI_SCREEN_FWIDTH) {
            NSInteger newPage = round(x / APPCONFIG_UI_SCREEN_FWIDTH);
            [self changeScrollViewWithPage:newPage];
        } else {
            //My Lord，写完根本看不懂了。。
            if (lx < 0) {
                melodyC.frame = CGRectMake(APPCONFIG_UI_VIEW_BETWEEN_PADDING + lx * fadeRatio, BallonTopPadding, BallonHeight, BallonHeight);
                melodyD.frame = CGRectMake(APPCONFIG_UI_SCREEN_FWIDTH - (APPCONFIG_UI_VIEW_BETWEEN_PADDING + BallonHeight )* 3 + lx * longDistanceRatio, BallonTopPadding, BallonHeight, BallonHeight);
                melodyE.frame = CGRectMake(APPCONFIG_UI_SCREEN_FWIDTH - (APPCONFIG_UI_VIEW_BETWEEN_PADDING + BallonHeight )* 2 + lx * shortDistanceRatio, BallonTopPadding, BallonHeight, BallonHeight);
                melodyF.frame = CGRectMake(APPCONFIG_UI_SCREEN_FWIDTH - APPCONFIG_UI_VIEW_BETWEEN_PADDING - BallonHeight + lx * shortDistanceRatio, BallonTopPadding, BallonHeight, BallonHeight);
                melodyG.frame = CGRectMake(APPCONFIG_UI_SCREEN_FWIDTH + APPCONFIG_UI_VIEW_BETWEEN_PADDING + lx * fadeRatio, BallonTopPadding, BallonHeight, BallonHeight);
                
                
                sharpC.frame = CGRectMake(BallonHeight + APPCONFIG_UI_VIEW_BETWEEN_PADDING + BallonTitlePadding + lx * fadeRatio, BallonTopPadding, TitleWidth, BallonHeight);
                sharpC.font = [UIFont boldSystemFontOfSize:(FontFloat + lx * fontRatio)];
                sharpC.alpha = 1 + lx / APPCONFIG_UI_SCREEN_FWIDTH;
                sharpD.frame = CGRectMake(APPCONFIG_UI_SCREEN_FWIDTH - (APPCONFIG_UI_VIEW_BETWEEN_PADDING + BallonHeight )* 2 - BallonTitlePadding + lx * longDistanceRatio, BallonTopPadding, TitleWidth, BallonHeight);
                sharpD.font = [UIFont boldSystemFontOfSize:(0 - lx * fontRatio)];
                sharpD.alpha = - lx / APPCONFIG_UI_SCREEN_FWIDTH;
            } else {
                melodyB.frame = CGRectMake(- APPCONFIG_UI_VIEW_BETWEEN_PADDING - BallonHeight + lx * fadeRatio, BallonTopPadding, BallonHeight, BallonHeight);
                melodyC.frame = CGRectMake(APPCONFIG_UI_VIEW_BETWEEN_PADDING + lx * longDistanceRatio, BallonTopPadding, BallonHeight, BallonHeight);
                melodyD.frame = CGRectMake(APPCONFIG_UI_SCREEN_FWIDTH - (APPCONFIG_UI_VIEW_BETWEEN_PADDING + BallonHeight )* 3 + lx * shortDistanceRatio, BallonTopPadding, BallonHeight, BallonHeight);
                melodyE.frame = CGRectMake(APPCONFIG_UI_SCREEN_FWIDTH - (APPCONFIG_UI_VIEW_BETWEEN_PADDING + BallonHeight )* 2 + lx * shortDistanceRatio, BallonTopPadding, BallonHeight, BallonHeight);
                melodyF.frame = CGRectMake(APPCONFIG_UI_SCREEN_FWIDTH - APPCONFIG_UI_VIEW_BETWEEN_PADDING - BallonHeight + lx * fadeRatio, BallonTopPadding, BallonHeight, BallonHeight);
                
                
                sharpC.frame = CGRectMake(BallonHeight + APPCONFIG_UI_VIEW_BETWEEN_PADDING + BallonTitlePadding + lx * longDistanceRatio, BallonTopPadding, TitleWidth, BallonHeight);
                sharpC.font = [UIFont boldSystemFontOfSize:(FontFloat - lx * fontRatio)];
                sharpC.alpha = 1 - lx / APPCONFIG_UI_SCREEN_FWIDTH;
                sharpB.frame = CGRectMake(BallonTitlePadding - APPCONFIG_UI_VIEW_BETWEEN_PADDING + lx * fadeRatio, BallonTopPadding, TitleWidth, BallonHeight);
                sharpB.font = [UIFont boldSystemFontOfSize:(lx * fontRatio)];
                sharpB.alpha = lx / APPCONFIG_UI_SCREEN_FWIDTH;
            }
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger newPage = scrollView.contentOffset.x / APPCONFIG_UI_SCREEN_FWIDTH;
    [self changeScrollViewWithPage:newPage];
}

- (void)changeScrollViewWithPage:(NSInteger)newPage {
    if (newPage != page) {
        switch (page) {
            case 0:
                if (newPage == 3) {
                    sharpD.text = @"俯卧撑";
                    [self scrollViewMoveRight];
                }
                if (newPage == 1) {
                    sharpB.text = @"俯卧撑";
                    [self scrollViewMoveLeft];
                }
                break;
            case 1:
                if (newPage == 0 || newPage == 4){
                    sharpD.text = @"深蹲";
                    [self scrollViewMoveRight];
                }
                if (newPage == 2) {
                    sharpB.text = @"深蹲";
                    [self scrollViewMoveLeft];
                }
                break;
            case 2:
                if (newPage == 1) {
                    sharpD.text = @"步行";
                    [self scrollViewMoveRight];
                }
                if (newPage == 3) {
                    sharpB.text = @"步行";
                    [self scrollViewMoveLeft];
                }                break;
            case 3:
                if (newPage == 2) {
                    sharpD.text = @"仰卧起坐";
                    [self scrollViewMoveRight];
                }
                if (newPage == 4 || newPage == 0) {
                    sharpB.text = @"仰卧起坐";
                    [self scrollViewMoveLeft];
                }
                break;
            case 4:
                if (newPage == 3) {
                    sharpD.text = @"俯卧撑";
                    [self scrollViewMoveRight];
                }
                if (newPage == 1) {
                    sharpB.text = @"俯卧撑";
                    [self scrollViewMoveLeft];
                }
                break;
                
            default:
                break;
        }
        
        HistoryExerciseView *currentView = [viewArray objectAtIndex:page];
        [currentView dismissSelected];
        page = newPage;
    }
}

- (void)scrollViewMoveLeft
{
    melodyB.frame = CGRectMake(APPCONFIG_UI_SCREEN_FWIDTH + APPCONFIG_UI_VIEW_BETWEEN_PADDING, BallonTopPadding, BallonHeight, BallonHeight);
    melodyA = melodyB;
    melodyB = melodyC;
    melodyC = melodyD;
    melodyD = melodyE;
    melodyE = melodyF;
    melodyF = melodyG;
    melodyG = melodyA;
    melodyG.image = melodyC.image;
    melodyB.image = melodyF.image;
    melodyA = nil;
    
    sharpB.frame = CGRectMake(APPCONFIG_UI_SCREEN_FWIDTH - (APPCONFIG_UI_VIEW_BETWEEN_PADDING + BallonHeight )* 2 - BallonTitlePadding, BallonTopPadding, TitleWidth, BallonHeight);
    sharpA = sharpB;
    sharpB = sharpC;
    sharpC = sharpD;
    sharpD = sharpA;
    sharpA = nil;
}

- (void)scrollViewMoveRight
{
    melodyG.frame = CGRectMake(- APPCONFIG_UI_VIEW_BETWEEN_PADDING - BallonHeight, BallonTopPadding, BallonHeight, BallonHeight);
    melodyA = melodyG;
    melodyG = melodyF;
    melodyF = melodyE;
    melodyE = melodyD;
    melodyD = melodyC;
    melodyC = melodyB;
    melodyB = melodyA;
    melodyG.image = melodyC.image;
    melodyB.image = melodyF.image;
    melodyA = nil;
    
    sharpD.frame = CGRectMake(BallonTitlePadding - APPCONFIG_UI_VIEW_BETWEEN_PADDING, BallonTopPadding, TitleWidth, BallonHeight);
    sharpA = sharpD;
    sharpD = sharpC;
    sharpC = sharpB;
    sharpB = sharpA;
    sharpA = nil;
}


@end
