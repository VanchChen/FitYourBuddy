//
//  LoadingViewController.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/5/7.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "LoadingViewController.h"
#import "AppDelegate.h"
#import "FXBlurView.h"

#import "WelcomeViewController.h"
#import "TarBarViewController.h"

#import <CoreSpotlight/CoreSpotlight.h> 

static CGFloat const BottomPadding = 20.0f;
static CGFloat const LabelHeight = 15.0f;
static CGFloat const IconHeight = 30.0f;

@interface LoadingViewController ()

@property (nonatomic, strong) UIView        *titleView;
@property (nonatomic, strong) FXBlurView    *blurView;

@property (nonatomic, strong) UIView        *labelCoverView;

@end

@implementation LoadingViewController

#pragma mark Life Circle

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"载入页面"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"载入页面"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加搜索
    [self addSpotlightSearch];
    
    //展示页面
    [self addLoadingView];
}

#pragma mark Core Spotlight
- (void)addSpotlightSearch {
    static NSString *domainIdentifier = @"xpz.FitYourBuddy.spotlight";
    
    CSSearchableItemAttributeSet *attributeSetPushUp = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:@"shortcut.pushup"];
    attributeSetPushUp.title = @"俯卧撑";
    attributeSetPushUp.contentDescription = @"提供最专业最趣味的俯卧撑辅助工具，帮助你更快乐的锻炼，快来体验吧~";
    attributeSetPushUp.thumbnailData = UIImagePNGRepresentation([UIImage imageNamed:@"PushUpIcon"]);
    attributeSetPushUp.keywords = @[@"俯卧撑",@"pushup"];
    
    CSSearchableItemAttributeSet *attributeSetSitUp = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:@"shortcut.situp"];
    attributeSetSitUp.title = @"仰卧起坐";
    attributeSetSitUp.contentDescription = @"提供最专业最趣味的仰卧起坐辅助工具，帮助你更快乐的锻炼，快来体验吧~";
    attributeSetSitUp.thumbnailData = UIImagePNGRepresentation([UIImage imageNamed:@"SitUpIcon"]);
    attributeSetSitUp.keywords = @[@"仰卧起坐",@"situp",@"卷腹"];
    
    CSSearchableItemAttributeSet *attributeSetSquat = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:@"shortcut.squat"];
    attributeSetSquat.title = @"深蹲";
    attributeSetSquat.contentDescription = @"提供最专业最趣味的深蹲辅助工具，帮助你更快乐的锻炼，快来体验吧~";
    attributeSetSquat.thumbnailData = UIImagePNGRepresentation([UIImage imageNamed:@"SquatIcon"]);
    attributeSetSquat.keywords = @[@"深蹲",@"squat",@"下蹲"];
    
    CSSearchableItemAttributeSet *attributeSetWalk = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:@"shortcut.walk"];
    attributeSetWalk.title = @"步行";
    attributeSetWalk.contentDescription = @"提供最专业最趣味的步行辅助工具，帮助你更快乐的锻炼，快来体验吧~";
    attributeSetWalk.thumbnailData = UIImagePNGRepresentation([UIImage imageNamed:@"WalkIcon"]);
    attributeSetWalk.keywords = @[@"步行",@"walk",@"跑步",@"竞走"];
    
    CSSearchableItem *pushupItem = [[CSSearchableItem alloc] initWithUniqueIdentifier:@"pushUp"
                                                                     domainIdentifier:domainIdentifier
                                                                         attributeSet:attributeSetPushUp];
    CSSearchableItem *situpItem = [[CSSearchableItem alloc] initWithUniqueIdentifier:@"situp"
                                                                    domainIdentifier:domainIdentifier
                                                                        attributeSet:attributeSetSitUp];
    CSSearchableItem *squatItem = [[CSSearchableItem alloc] initWithUniqueIdentifier:@"squat"
                                                                    domainIdentifier:domainIdentifier
                                                                        attributeSet:attributeSetSquat];
    CSSearchableItem *walkItem = [[CSSearchableItem alloc] initWithUniqueIdentifier:@"walk"
                                                                   domainIdentifier:domainIdentifier
                                                                       attributeSet:attributeSetWalk];
    
    [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:@[pushupItem,situpItem,squatItem,walkItem]
                                                   completionHandler:^(NSError * _Nullable error) {
                                                       if (error) {
                                                           NSLog(@"add search item error");
                                                       }
    }];
}

#pragma mark Working Method

- (void)addLoadingView {
    //底部栏
    UILabel *appVersionLabel = [CommonUtil createLabelWithText:@"程序版本 V1.0" andTextColor:tipTitleLabelColor andFont:[UIFont systemFontOfSize:14.0f] andTextAlignment:NSTextAlignmentCenter];
    appVersionLabel.frame = CGRectMake(0, 0, APPCONFIG_UI_SCREEN_FWIDTH, LabelHeight);
    
    UILabel *companyLabel = [CommonUtil createLabelWithText:@"小笋科技有限公司" andTextColor:tipTitleLabelColor andFont:[UIFont systemFontOfSize:14.0f] andTextAlignment:NSTextAlignmentCenter];
    companyLabel.frame = CGRectMake(0, APPCONFIG_UI_SCREEN_FHEIGHT - BottomPadding - LabelHeight, APPCONFIG_UI_SCREEN_FWIDTH, LabelHeight);
    [appVersionLabel topOfView:companyLabel];
    [self.view addSubview:appVersionLabel];
    [self.view addSubview:companyLabel];
    
    //标题栏
    _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPCONFIG_UI_SCREEN_FWIDTH, 160)];
    _titleView.backgroundColor = [UIColor whiteColor];
    _titleView.center = CGPointMake(self.view.center.x, self.view.center.y - _titleView.height / 2.0f) ;
    [self.view addSubview:_titleView];
    
    UILabel *titleNameLabel = [CommonUtil createLabelWithText:@"天天趣健身" andTextColor:tipTitleLabelColor andFont:[UIFont boldSystemFontOfSize:22.0f] andTextAlignment:NSTextAlignmentCenter];
    titleNameLabel.frame = CGRectMake(0, 20, _titleView.width, 30.0f);
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"天天趣健身"];
    [str addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:26.0f] range:NSMakeRange(2, 1)];
    titleNameLabel.attributedText = str;
    [_titleView addSubview:titleNameLabel];
    
    UIImageView *pushUpIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, IconHeight, IconHeight)];
    pushUpIcon.image = [UIImage imageNamed:@"PushUpIcon"];
    pushUpIcon.center = CGPointMake(titleNameLabel.center.x - IconHeight / 2.0f - 2.0f, titleNameLabel.center.y);
    [_titleView addSubview:pushUpIcon];
    [pushUpIcon bottomOfView:titleNameLabel withMargin:5.0f];
    
    UIImageView *sitUpIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, IconHeight, IconHeight)];
    sitUpIcon.image = [UIImage imageNamed:@"SitUpIcon"];
    [sitUpIcon leftOfView:pushUpIcon withMargin:4.0f sameVertical:YES];
    [_titleView addSubview:sitUpIcon];
    
    UIImageView *squatIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, IconHeight, IconHeight)];
    squatIcon.image = [UIImage imageNamed:@"SquatIcon"];
    [squatIcon rightOfView:pushUpIcon withMargin:4.0f sameVertical:YES];
    [_titleView addSubview:squatIcon];
    
    UIImageView *walkIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, IconHeight, IconHeight)];
    walkIcon.image = [UIImage imageNamed:@"WalkIcon"];
    [walkIcon rightOfView:squatIcon withMargin:4.0f sameVertical:YES];
    [_titleView addSubview:walkIcon];
    
    UILabel *titleTintLabel = [CommonUtil createLabelWithText:@"因 为 快 乐 ，所 以 坚 持" andTextColor:tipTitleLabelColor andFont:[UIFont systemFontOfSize:16.0f] andTextAlignment:NSTextAlignmentCenter];
    titleTintLabel.frame = CGRectMake(0, 0, _titleView.width, 30.0f);
    [titleTintLabel bottomOfView:walkIcon withMargin:20.0f];
    [_titleView addSubview:titleTintLabel];
    
    _labelCoverView = [[UIView alloc] initWithFrame:titleTintLabel.frame];
    _labelCoverView.backgroundColor = [UIColor whiteColor];
    [_titleView addSubview:_labelCoverView];
    
    //添加模糊效果
    _blurView = [[FXBlurView alloc] initWithFrame:CGRectMake(0, 0, _titleView.width, 100)];
    _blurView.center = CGPointMake(_titleView.center.x, _titleView.center.y - 30);
    _blurView.layer.cornerRadius = 50.0f;
    _blurView.tintColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1];
    _blurView.blurRadius = 40;
    _blurView.dynamic = NO;
    [self.view addSubview:_blurView];
    
    [self performSelector:@selector(clearBlur) withObject:nil afterDelay:1.0f];
}

- (void)clearBlur {
    [UIView animateWithDuration:1 animations:^{
        self.blurView.blurRadius = 0;
        self.blurView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.blurView removeFromSuperview];
        self.blurView = nil;
        
        CGRect coverFrame = _labelCoverView.frame;
        coverFrame.origin.x += coverFrame.size.width;
        coverFrame.size.width = 0;
        [UIView animateWithDuration:2 animations:^{
            _labelCoverView.frame = coverFrame;
        } completion:^(BOOL finished) {
            AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            //判断是否有本地数据
            NSError *error;
            NSString* name = [AccountCoreDataHelper getDataByName:@"name" withError:&error];
            if (name == nil) {
                //第一次使用，创建初始存档
                WelcomeViewController* welcomeView = [[WelcomeViewController alloc] init];
                [appDelegate.window setRootViewController:welcomeView];
            } else {
                [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
        
                TarBarViewController* tabBarController = [[TarBarViewController alloc] init];
                [appDelegate.window setRootViewController:tabBarController];
            }
        }];
    }];
}

//强制竖屏
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
