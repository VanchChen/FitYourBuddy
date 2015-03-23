//
//  IndexViewController.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/2/15.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "IndexViewController.h"
#import "WQProgressBar.h"
#import "WQCalendar.h"

#import "ExerciseViewController.h"

#import "AccountCoreDataHelper.h"

@interface IndexViewController ()<UIScrollViewDelegate, UIGestureRecognizerDelegate>
{
    UIView              *scrollBlock;
    
    NSDictionary        *accountDict;
}

@end

@implementation IndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"小胖砸";
    
    //统一返回键
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    [backItem setBackButtonBackgroundImage:[[UIImage imageNamed:@"NavBackIcon"] resizableImageWithCapInsets:UIEdgeInsetsMake(0,15,0,0)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [backItem setTitle:@""];
    self.navigationItem.backBarButtonItem = backItem;
    
    //获取姓名和性别
    NSError *error;
    accountDict = [AccountCoreDataHelper getAccountDictionaryWithError:&error];
    NSString *fatGuyName = [NSString stringWithFormat:@"早上好，%@", accountDict[@"name"]];
    NSString *fatGuyCount = accountDict[@"count"];
    NSString *fatGuyLevel = [NSString stringWithFormat:@"Lv.%@", accountDict[@"level"]];
    float fullExp = [self getExpFromLevel:accountDict[@"level"]];
    float exp = [accountDict[@"exp"] floatValue];
    exp = exp / fullExp;
    
    if (APPCONFIG_DEVICE_OVER_IPHONE5) {
        //添加小胖砸界面
        UIView* fatGuyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64 - 49 - 140)];//高315
        [fatGuyView setBackgroundColor:[UIColor whiteColor]];//themeBlueColor
        [self.view addSubview:fatGuyView];
        
        UILabel* fatGuyNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 20)];
        [fatGuyNameLabel setText:fatGuyName];
        [fatGuyNameLabel setTextColor:themeBlueColor];//[UIColor whiteColor]
        [fatGuyNameLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [fatGuyNameLabel setBackgroundColor:[UIColor clearColor]];
        [fatGuyView addSubview:fatGuyNameLabel];
        
        //临时小胖砸图
        UIImageView* littleFatGuy = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 151, 235)]; //9/14
        [littleFatGuy setImage:[UIImage imageNamed:@"LittleFatGuy"]];
        [littleFatGuy setCenter:fatGuyView.center];
        [fatGuyView addSubview:littleFatGuy];
    } else {
        //添加小胖砸界面
        UIView* fatGuyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64 - 49 - 140)];//高???
        [fatGuyView setBackgroundColor:[UIColor whiteColor]];//themeBlueColor
        [self.view addSubview:fatGuyView];
        
        UILabel* fatGuyNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 20)];
        [fatGuyNameLabel setText:fatGuyName];
        [fatGuyNameLabel setTextColor:themeBlueColor];//[UIColor whiteColor]
        [fatGuyNameLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [fatGuyNameLabel setBackgroundColor:[UIColor clearColor]];
        [fatGuyView addSubview:fatGuyNameLabel];
        
        //临时小胖砸图
        UIImageView* littleFatGuy = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 126, 196)]; //9/14
        [littleFatGuy setImage:[UIImage imageNamed:@"LittleFatGuy"]];
        [littleFatGuy setCenter:fatGuyView.center];
        [fatGuyView addSubview:littleFatGuy];
    }
    
    //添加锻炼界面，高度为140
    UIView* trainView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 64 - 49 - 140, self.view.frame.size.width, 140)];
    [trainView setBackgroundColor:themeBlueColor];
    [self.view addSubview:trainView];
    
    UIView* historyLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, trainView.bounds.size.width, 1)];
    [historyLine setBackgroundColor:[UIColor whiteColor]];
    [trainView addSubview:historyLine];
    
    UILabel* historyTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
    [historyTipLabel setText:@"您已坚持锻炼"];
    [historyTipLabel setTextColor:[UIColor whiteColor]];
    [historyTipLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [historyTipLabel setBackgroundColor:[UIColor clearColor]];
    [trainView addSubview:historyTipLabel];
    
    UILabel* historyDayLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 10, 50, 20)];
    [historyDayLabel setText:fatGuyCount];
    [historyDayLabel setTextColor:[UIColor whiteColor]];
    [historyDayLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [historyDayLabel setBackgroundColor:[UIColor clearColor]];
    [trainView addSubview:historyDayLabel];
    [historyDayLabel sizeToFit];
    
    UILabel* historyOneDay = [[UILabel alloc] initWithFrame:CGRectMake(110 + historyDayLabel.bounds.size.width + 5, 10, 20, 20)];
    [historyOneDay setText:@"天"];
    [historyOneDay setTextColor:[UIColor whiteColor]];
    [historyOneDay setFont:[UIFont boldSystemFontOfSize:16]];
    [historyOneDay setBackgroundColor:[UIColor clearColor]];
    [trainView addSubview:historyOneDay];
    
    UILabel* historyLevel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 30, 20)];
    [historyLevel setText:fatGuyLevel];
    [historyLevel setTextColor:[UIColor whiteColor]];
    [historyLevel setFont:[UIFont boldSystemFontOfSize:16]];
    [historyLevel setBackgroundColor:[UIColor clearColor]];
    [trainView addSubview:historyLevel];
    
    WQProgressBar* historyProgressBar = [[WQProgressBar alloc] initWithFrame:CGRectMake(50, 38, 220, 23) andRat:exp withAnimation:YES];
    [trainView addSubview:historyProgressBar];
    
    UIView* startTrainLine = [[UIView alloc] initWithFrame:CGRectMake(0, 69, trainView.bounds.size.width, 1)];
    [startTrainLine setBackgroundColor:[UIColor whiteColor]];
    [trainView addSubview:startTrainLine];
    
    UIButton* startTrainBtn = [[UIButton alloc] initWithFrame:CGRectMake(60, 80, 200, 50)];
    [startTrainBtn setBackgroundColor:themeRedColor];
    [[startTrainBtn layer] setCornerRadius:15];
    [startTrainBtn addTarget:self action:@selector(tappedStartTrainBtn) forControlEvents:UIControlEventTouchUpInside];
    [trainView addSubview:startTrainBtn];
    
    UILabel* startTrainLabel = [[UILabel alloc] initWithFrame:startTrainBtn.bounds];
    [startTrainLabel setTextColor:[UIColor whiteColor]];
    [startTrainLabel setText:@"开 始 锻 炼"];
    [startTrainLabel setFont:[UIFont boldSystemFontOfSize:22]];
    [startTrainLabel setTextAlignment:NSTextAlignmentCenter];
    [startTrainBtn addSubview:startTrainLabel];
    
    //盖一层下拉scrollview
    UIScrollView* fatGuyScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 315)];
    [fatGuyScrollView setDelegate:self];
    [fatGuyScrollView setContentSize:CGSizeMake(fatGuyScrollView.frame.size.width, fatGuyScrollView.frame.size.height * 2)];
    [fatGuyScrollView setPagingEnabled:YES];
    fatGuyScrollView.showsVerticalScrollIndicator = false;
    fatGuyScrollView.bounces = false;
    [fatGuyScrollView setContentOffset:CGPointMake(0, 315)];
    [self.view addSubview:fatGuyScrollView];
    
    //日历页
    UIView* calendarBackground = [[UIView alloc] initWithFrame:CGRectMake(2.5, 2.5, fatGuyScrollView.frame.size.width - 5, fatGuyScrollView.frame.size.height - 5)];
    [calendarBackground setBackgroundColor:[UIColor whiteColor]];
    [fatGuyScrollView addSubview:calendarBackground];
    
    NSDate* today = [NSDate date];
    
    UILabel* calendarDate = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 200, 30)];
    [calendarDate setTextColor:themeBlueColor];
    [calendarDate setFont:[UIFont boldSystemFontOfSize:22]];
    [calendarDate setText:[NSString stringWithFormat:@"%lu.%.2lu", (unsigned long)today.year, (unsigned long)today.month]];
    [calendarBackground addSubview:calendarDate];
    
    if ([today numberOfWeeksInMonth] == 6) {
        WQCalendar* calendar = [[WQCalendar alloc] initWithFrame:CGRectMake(10, 40, calendarBackground.frame.size.width - 20, 245)];
        [calendarBackground addSubview:calendar];
    } else {
        float tileWidth = (calendarBackground.frame.size.width - 20) / 7;
        for (int i = 0; i < 7; i++) {
            UILabel* calendarTitle = [[UILabel alloc] initWithFrame:CGRectMake(10 + i * tileWidth, 40, tileWidth, tileWidth)];
            [calendarTitle setTextAlignment:NSTextAlignmentCenter];
            [calendarTitle setFont:[UIFont systemFontOfSize:20]];
            [calendarBackground addSubview:calendarTitle];
            
            switch (i) {
                case 0:
                    [calendarTitle setTextColor:themeRedColor];
                    [calendarTitle setText:@"S"];
                    break;
                    
                case 1:
                    [calendarTitle setTextColor:themeBlueColor];
                    [calendarTitle setText:@"M"];
                    break;
                    
                case 2:
                    [calendarTitle setTextColor:themeBlueColor];
                    [calendarTitle setText:@"T"];
                    break;
                    
                case 3:
                    [calendarTitle setTextColor:themeBlueColor];
                    [calendarTitle setText:@"W"];
                    break;
                    
                case 4:
                    [calendarTitle setTextColor:themeBlueColor];
                    [calendarTitle setText:@"T"];
                    break;
                    
                case 5:
                    [calendarTitle setTextColor:themeBlueColor];
                    [calendarTitle setText:@"F"];
                    break;
                    
                case 6:
                    [calendarTitle setTextColor:themeRedColor];
                    [calendarTitle setText:@"S"];
                    break;
                    
                    
                default:
                    break;
            }
        }
        
        WQCalendar* calendar = [[WQCalendar alloc] initWithFrame:CGRectMake(10, 40 + tileWidth, calendarBackground.frame.size.width - 20, 245)];
        [calendarBackground addSubview:calendar];
    }
    //全局下拉块
    scrollBlock = [[UIView alloc] initWithFrame:CGRectMake(0, 315 + 5, 60, 3)];
    [scrollBlock setCenter:CGPointMake(fatGuyScrollView.center.x, scrollBlock.center.y)];
    [scrollBlock setBackgroundColor:themeBlueColor];
    [[scrollBlock layer] setCornerRadius:2];
    [fatGuyScrollView addSubview:scrollBlock];
}

#pragma mark - Class Extention Delegate
- (void)tappedStartTrainBtn
{
    ExerciseViewController* new = [[ExerciseViewController alloc] init];
    [self.navigationController pushViewController:new animated:YES];
}

- (float)getExpFromLevel:(NSString *)level
{
    int l = [level intValue];
    switch (l) {
        case 1:
            return 200;
            break;
        case 2:
            return 1000;
            break;
        case 3:
            return 4000;
            break;
        case 4:
            return 12000;
            break;
        default:
            return 0;
            break;
    }
}

#pragma mark - Scroll View Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float verticalY = 315 - scrollView.contentOffset.y;
    if (verticalY < 20) {
        scrollBlock.frame = CGRectMake(scrollBlock.frame.origin.x, 315 + 5 - verticalY, scrollBlock.frame.size.width, scrollBlock.frame.size.height);
    } else {
        scrollBlock.frame = CGRectMake(scrollBlock.frame.origin.x, 315 + 5 - 20, scrollBlock.frame.size.width, scrollBlock.frame.size.height);
    }
}

@end
