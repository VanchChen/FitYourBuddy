//
//  HistoryViewController.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/2/19.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "HistoryViewController.h"

@interface HistoryViewController ()<UIScrollViewDelegate>
{
    float fadeRatio;
    float fontRatio;
    float longDistanceRatio;
    float shortDistanceRatio;
    
    NSInteger   page;
    
    UIView *melodyB, *melodyC, *melodyD, *melodyE, *melodyF, *melodyG, *melodyA;
    UILabel *sharpB, *sharpC, *sharpD, *sharpA;
}

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"统计";
    
    //标题栏
    fadeRatio = 55.f/320.f;
    fontRatio = 20.f/320.f;
    longDistanceRatio = 175.f / 320.f;
    shortDistanceRatio = 45.f / 320.f;
    page = 1;
    
    UIView* scrollTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 75)];
    [scrollTitleView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:scrollTitleView];
    
    melodyB = [[UIView alloc] initWithFrame:CGRectMake(-45, 20, 35, 35)];
    [melodyB setBackgroundColor:walkColor];
    [[melodyB layer] setCornerRadius:17.5f];
    [scrollTitleView addSubview:melodyB];
    
    sharpB = [[UILabel alloc] initWithFrame:CGRectMake(-5, 20, 100, 35)];
    [sharpB setText:@"步行"];
    [sharpB setTextColor:themeBlueColor];
    [sharpB setFont:[UIFont boldSystemFontOfSize:0.f]];
    [sharpB setAlpha:0];
    [scrollTitleView addSubview:sharpB];
    
    melodyC = [[UIView alloc] initWithFrame:CGRectMake(10, 20, 35, 35)];
    [melodyC setBackgroundColor:sitUpColor];
    [[melodyC layer] setCornerRadius:17.5f];
    [scrollTitleView addSubview:melodyC];
    
    sharpC = [[UILabel alloc] initWithFrame:CGRectMake(50, 20, 100, 35)];
    [sharpC setText:@"仰卧起坐"];
    [sharpC setTextColor:themeBlueColor];
    [sharpC setFont:[UIFont boldSystemFontOfSize:20.f]];
    [sharpC setAlpha:1];
    [scrollTitleView addSubview:sharpC];
    
    melodyD = [[UIView alloc] initWithFrame:CGRectMake(185, 20, 35, 35)];
    [melodyD setBackgroundColor:pushUpColor];
    [[melodyD layer] setCornerRadius:17.5f];
    [scrollTitleView addSubview:melodyD];
    
    sharpD = [[UILabel alloc] initWithFrame:CGRectMake(225, 20, 100, 35)];
    [sharpD setText:@"俯卧撑"];
    [sharpD setTextColor:themeBlueColor];
    [sharpD setFont:[UIFont boldSystemFontOfSize:0.f]];
    [sharpD setAlpha:0];
    [scrollTitleView addSubview:sharpD];
    
    melodyE = [[UIView alloc] initWithFrame:CGRectMake(230, 20, 35, 35)];
    [melodyE setBackgroundColor:squatColor];
    [[melodyE layer] setCornerRadius:17.5f];
    [scrollTitleView addSubview:melodyE];
    
    melodyF = [[UIView alloc] initWithFrame:CGRectMake(275, 20, 35, 35)];
    [melodyF setBackgroundColor:walkColor];
    [[melodyF layer] setCornerRadius:17.5f];
    [scrollTitleView addSubview:melodyF];
    
    melodyG = [[UIView alloc] initWithFrame:CGRectMake(330, 20, 35, 35)];
    [melodyG setBackgroundColor:sitUpColor];
    [[melodyG layer] setCornerRadius:17.5f];
    [scrollTitleView addSubview:melodyG];
    
    melodyA = nil;sharpA = nil;
    
    //统计滚动视图
    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 75, self.view.frame.size.width, self.view.frame.size.height - 49 - 75 - 64)];
    [scrollView setDelegate:self];
    [scrollView setBackgroundColor:themeBlueColor];
    [scrollView setPagingEnabled:YES];
    scrollView.showsHorizontalScrollIndicator = NO;
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width * 5, scrollView.frame.size.height)];
    [scrollView setContentOffset:CGPointMake(scrollView.frame.size.width, 0)];
    [self.view addSubview:scrollView];
    
    UIView* walkView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, scrollView.frame.size.width, scrollView.frame.size.height)];
    [scrollView addSubview:walkView];
    [self createInitFrame:walkView];
    
    UIView* sitUpView = [[UIView alloc] initWithFrame:CGRectMake(scrollView.frame.size.width, 0, scrollView.frame.size.width, scrollView.frame.size.height)];
    [scrollView addSubview:sitUpView];
    [self createInitFrame:sitUpView];
    
    UIView* pushUpView = [[UIView alloc] initWithFrame:CGRectMake(scrollView.frame.size.width * 2, 0, scrollView.frame.size.width, scrollView.frame.size.height)];
    [scrollView addSubview:pushUpView];
    [self createInitFrame:pushUpView];
    
    UIView* squatView = [[UIView alloc] initWithFrame:CGRectMake(scrollView.frame.size.width * 3, 0, scrollView.frame.size.width, scrollView.frame.size.height)];
    [scrollView addSubview:squatView];
    [self createInitFrame:squatView];
    
    UIView* walkView2 = [[UIView alloc] initWithFrame:CGRectMake(scrollView.frame.size.width * 4, 0, scrollView.frame.size.width, scrollView.frame.size.height)];
    [scrollView addSubview:walkView2];
    [self createInitFrame:walkView2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Class Extention
- (void)createInitFrame:(UIView *)view
{
    UIView* lineView;
    UILabel* textLabel;
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(159.5, 0, 1, 100)];
    [lineView setBackgroundColor:[UIColor whiteColor]];
    [view addSubview:lineView];
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, 320, 1)];
    [lineView setBackgroundColor:[UIColor whiteColor]];
    [view addSubview:lineView];
    
    textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 160, 40)];
    [textLabel setTextColor:[UIColor whiteColor]];
    [textLabel setTextAlignment:NSTextAlignmentCenter];
    [textLabel setText:@"个人记录"];
    [textLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [view addSubview:textLabel];
    
    textLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 10, 160, 40)];
    [textLabel setTextColor:[UIColor whiteColor]];
    [textLabel setTextAlignment:NSTextAlignmentCenter];
    [textLabel setText:@"生涯总数"];
    [textLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [view addSubview:textLabel];
}

#pragma mark - Scroll View Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float x = scrollView.contentOffset.x;
    if (x < 0) {
        [self changeScrollViewWithPage:4];
        [scrollView setContentOffset:CGPointMake(scrollView.frame.size.width * 4 + x, 0)];
    } else if (x > scrollView.frame.size.width * 4) {
        [self changeScrollViewWithPage:0];
        [scrollView setContentOffset:CGPointMake(x - scrollView.frame.size.width * 4, 0)];
    } else {
        //移动标题栏
        float lx = page * 320 - x;
        if (lx > 320 || lx < -320) {
            NSInteger newPage = round(x / 320);
            [self changeScrollViewWithPage:newPage];
        } else {
            if (lx < 0) {
                melodyC.frame = CGRectMake(10 + lx * fadeRatio, 20, 35, 35);
                melodyD.frame = CGRectMake(185 + lx * longDistanceRatio, 20, 35, 35);
                melodyE.frame = CGRectMake(230 + lx * shortDistanceRatio, 20, 35, 35);
                melodyF.frame = CGRectMake(275 + lx * shortDistanceRatio, 20, 35, 35);
                melodyG.frame = CGRectMake(330 + lx * fadeRatio, 20, 35, 35);
                
                
                sharpC.frame = CGRectMake(50 + lx * fadeRatio, 20, 100, 35);
                sharpC.font = [UIFont boldSystemFontOfSize:(20 + lx * fontRatio)];
                sharpC.alpha = 1 + lx / 320.f;
                sharpD.frame = CGRectMake(225 + lx * longDistanceRatio, 20, 100, 35);
                sharpD.font = [UIFont boldSystemFontOfSize:(0 - lx * fontRatio)];
                sharpD.alpha = - lx / 320.f;
            } else {
                melodyB.frame = CGRectMake(-45 + lx * fadeRatio, 20, 35, 35);
                melodyC.frame = CGRectMake(10 + lx * longDistanceRatio, 20, 35, 35);
                melodyD.frame = CGRectMake(185 + lx * shortDistanceRatio, 20, 35, 35);
                melodyE.frame = CGRectMake(230 + lx * shortDistanceRatio, 20, 35, 35);
                melodyF.frame = CGRectMake(275 + lx * fadeRatio, 20, 35, 35);
                
                
                sharpC.frame = CGRectMake(50 + lx * longDistanceRatio, 20, 100, 35);
                sharpC.font = [UIFont boldSystemFontOfSize:(20 - lx * fontRatio)];
                sharpC.alpha = 1 - lx / 320.f;
                sharpB.frame = CGRectMake(-5 + lx * fadeRatio, 20, 100, 35);
                sharpB.font = [UIFont boldSystemFontOfSize:(lx * fontRatio)];
                sharpB.alpha = lx / 320.f;
            }
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger newPage = scrollView.contentOffset.x / 320;
    [self changeScrollViewWithPage:newPage];
}

- (void)changeScrollViewWithPage:(NSInteger)newPage
{
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
                }
                break;
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
        page = newPage;
    }
}

- (void)scrollViewMoveLeft
{
    melodyB.frame = CGRectMake(330, 20, 35, 35);
    melodyA = melodyB;
    melodyB = melodyC;
    melodyC = melodyD;
    melodyD = melodyE;
    melodyE = melodyF;
    melodyF = melodyG;
    melodyG = melodyA;
    melodyG.backgroundColor = melodyC.backgroundColor;
    melodyB.backgroundColor = melodyF.backgroundColor;
    melodyA = nil;
    
    sharpB.frame = CGRectMake(225, 20, 100, 35);
    sharpA = sharpB;
    sharpB = sharpC;
    sharpC = sharpD;
    sharpD = sharpA;
    sharpA = nil;
}

- (void)scrollViewMoveRight
{
    melodyG.frame = CGRectMake(-45, 20, 35, 35);
    melodyA = melodyG;
    melodyG = melodyF;
    melodyF = melodyE;
    melodyE = melodyD;
    melodyD = melodyC;
    melodyC = melodyB;
    melodyB = melodyA;
    melodyG.backgroundColor = melodyC.backgroundColor;
    melodyB.backgroundColor = melodyF.backgroundColor;
    melodyA = nil;
    
    sharpD.frame = CGRectMake(-5, 20, 100, 35);
    sharpA = sharpD;
    sharpD = sharpC;
    sharpC = sharpB;
    sharpB = sharpA;
    sharpA = nil;
}


@end
