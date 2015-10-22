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
#import "StoreViewController.h"
#import "AppCore.h"

static CGFloat  const TitleLabelWidth   = 40.0f;
static CGFloat  const FatGuyHeightRatio = 0.8f;
static CGFloat  const IPhone4sRatio = 217.0f / 305.0f;
static CGFloat  const CalendarViewHeight = 320.0f;
static UIEdgeInsets const DayLabelInset = (UIEdgeInsets){0,0,10,40};  //购买框，分别为（上，左，高，宽）

@interface IndexViewController () {
    UIButton            *fatGuyFrameView;   //胖子圆框
    
    UILabel             *fatGuyNameLabel;   //名字框
    UILabel             *leftHistoryDayLabel;//坚持天数
    WQProgressBar       *levelProgressBar;  //经验框
    WQCalendar          *calendar;          //日历
}

@property (nonatomic, strong) UIView        *bodyView;
@property (nonatomic, strong) UIButton      *shadowView;
@property (nonatomic, strong) UIView        *headView;
@property (nonatomic, assign) BOOL          isPull;

@end

@implementation IndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav]; //导航栏和页面背景设置
    
    [self initFatGuy]; //添加小胖砸界面
    
    [self initDataView]; //坚持天数和开始锻炼按钮

    [self initCalendar]; //日历加载
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //先删光
    [fatGuyFrameView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //获取等级和配件
    NSError *error;
    NSDictionary *_dict = [AccountCoreDataHelper getAccountDictionaryWithError:&error];
    
    UIImage *bodyImagePict = [UIImage imageNamed:[NSString stringWithFormat:@"body_%@_%@",_dict[@"gender"], _dict[@"level"]]];
    UIImage *eyeImagePict = [UIImage imageNamed:[NSString stringWithFormat:@"eye_tn_%@_%@",_dict[@"gender"], _dict[@"eye"]]];
    UIImage *mouthImagePict = [UIImage imageNamed:[NSString stringWithFormat:@"mouth_tn_%@_%@",_dict[@"gender"], _dict[@"mouth"]]];
    CGRect bodyRect, eyeRect, mouthRect;
    CGFloat eyeGap, mouthGap;
    if (!APPCONFIG_DEVICE_OVER_IPHONE5) {
        CGSize size = bodyImagePict.size;
        size.width *= IPhone4sRatio;
        size.height *= IPhone4sRatio;
        bodyRect = CGRectMake(0, 0, size.width, size.height);
        
        size = eyeImagePict.size;
        size.width *= IPhone4sRatio;
        size.height *= IPhone4sRatio;
        eyeRect = CGRectMake(0, 0, size.width, size.height);
        
        size = mouthImagePict.size;
        size.width *= IPhone4sRatio;
        size.height *= IPhone4sRatio;
        mouthRect = CGRectMake(0, 0, size.width, size.height);
        
        eyeGap = 43;
        mouthGap = 61;
    } else {
        bodyRect = CGRectMake(0, 0, bodyImagePict.size.width, bodyImagePict.size.height);
        eyeRect = CGRectMake(0, 0, eyeImagePict.size.width, eyeImagePict.size.height);
        mouthRect = CGRectMake(0, 0, mouthImagePict.size.width, mouthImagePict.size.height);
        
        eyeGap = 60;
        mouthGap = 85;
    }
    
    //体型
    UIImageView *bodyImage = [[UIImageView alloc] initWithFrame:bodyRect];
    [bodyImage setImage:bodyImagePict];
    [bodyImage setCenter:CGPointMake(fatGuyFrameView.width / 2.0f, fatGuyFrameView.height / 2.0f)];
    [fatGuyFrameView addSubview:bodyImage];
    

//        //发型
//        NSString *hairImageUrl = [NSString stringWithFormat:@"hair_%@_%@",_dict[@"gender"], _dict[@"hair"]];
//        UIImageView *_hairImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:hairImageUrl]];
//        _hairImage.center = CGPointMake(fatGuyFrameView.width / 2.0f, fatGuyFrameView.height / 2.0f);//fatGuyFrameView.width / 2.0f + 3.0f, 38.0f
//        [fatGuyFrameView addSubview:_hairImage];
//        
    //眼睛
    UIImageView *_eyeImage = [[UIImageView alloc] initWithFrame:eyeRect];
    [_eyeImage setImage:eyeImagePict];
    _eyeImage.center = CGPointMake(fatGuyFrameView.width / 2.0f - 1.0f, eyeGap);//fatGuyFrameView.width / 2.0f - 1.0f, 54.0f
    [fatGuyFrameView addSubview:_eyeImage];
    
    //嘴巴
    UIImageView *_mouthImage = [[UIImageView alloc] initWithFrame:mouthRect];
    [_mouthImage setImage:mouthImagePict];
    _mouthImage.center = CGPointMake(fatGuyFrameView.width / 2.0f - 1.0f, mouthGap);//fatGuyFrameView.width / 2.0f - 1.0f, 80.0f
    [fatGuyFrameView addSubview:_mouthImage];
        
//        //衣服
//        NSString *clothesImageUrl = [NSString stringWithFormat:@"clothes_%@_%@_%@",_dict[@"gender"], _dict[@"clothes"], _dict[@"level"]];
//        UIImageView *_clothesImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:clothesImageUrl]];
//        _clothesImage.center = CGPointMake(fatGuyFrameView.width / 2.0f, fatGuyFrameView.height / 2.0f);
//        [fatGuyFrameView addSubview:_clothesImage];
    
    //获取姓名和性别
    fatGuyNameLabel.text = [NSString stringWithFormat:@"%@好，%@",[[NSDate date] timeZone], _dict[@"name"]];
    leftHistoryDayLabel.text = [NSString stringWithFormat:@"%@天", _dict[@"count"]];
    
    //经验
    [levelProgressBar loadLevelAndExp];
    
    //加载日历数据
    [calendar reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    BOOL isFirst = [[NSUserDefaults standardUserDefaults] boolForKey:@"FirstTimeEnterIndexPage"];
    if (isFirst) {
        //弹窗
        [self addPopView];
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"FirstTimeEnterIndexPage"];
    }
    
    [[AppCore sharedAppCore] checkPresent];
}

- (void)initNav {
    self.navigationItem.title = @"天天趣健身";
    
    //来个分享按钮
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(0, 0, 24, 24);
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"ShareWhiteIcon"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(tappedShareBtn) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    
    //统一返回键
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    [backItem setBackButtonBackgroundImage:[[UIImage imageNamed:@"NavBackIcon"] resizableImageWithCapInsets:UIEdgeInsetsMake(0,15,0,-15)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    
    //页面view
    _bodyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPCONFIG_UI_SCREEN_FWIDTH, APPCONFIG_UI_SCREEN_VHEIGHT)];
    _bodyView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_bodyView];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] init];
    [pan addTarget:self action:@selector(handlePan:)];
    [_bodyView addGestureRecognizer:pan];
}

- (void)initFatGuy {
    CGFloat fatGuyViewHeight = APPCONFIG_UI_SCREEN_VHEIGHT - LevelIconWidth - TitleLabelWidth - APPCONFIG_UI_VIEW_PADDING * 2 - APPCONFIG_UI_VIEW_BETWEEN_PADDING;
    UIView* fatGuyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPCONFIG_UI_SCREEN_FWIDTH, fatGuyViewHeight)];
    [fatGuyView setBackgroundColor:themeBlueColor];
    [_bodyView addSubview:fatGuyView];
    
    UIView *scrollBlock = [[UIView alloc] init];
    scrollBlock.frame = CGRectMake(0, 8, 50, 2);
    scrollBlock.backgroundColor = [UIColor whiteColor];
    scrollBlock.layer.cornerRadius = 1.0f;
    scrollBlock.center = CGPointMake(APPCONFIG_UI_SCREEN_FWIDTH / 2, scrollBlock.center.y);
    [fatGuyView addSubview:scrollBlock];
    
    fatGuyNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 20)];
    [fatGuyNameLabel setTextColor:[UIColor whiteColor]];
    [fatGuyNameLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [fatGuyNameLabel setBackgroundColor:[UIColor clearColor]];
    [fatGuyView addSubview:fatGuyNameLabel];
    
    //加两个云，这里frame就写死了
    UIImageView *cloudImage = [[UIImageView alloc] init];
    cloudImage.frame = CGRectMake(210, 5, 60, 60);
    cloudImage.image = [UIImage imageNamed:@"CloudIcon"];
    [fatGuyView addSubview:cloudImage];
    
    cloudImage = [[UIImageView alloc] init];
    cloudImage.frame = CGRectMake(260, 45, 60, 60);
    cloudImage.image = [UIImage imageNamed:@"CloudIcon"];
    [fatGuyView addSubview:cloudImage];
    
    //胖子框
    fatGuyFrameView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, fatGuyViewHeight * FatGuyHeightRatio, fatGuyViewHeight * FatGuyHeightRatio)];
    [fatGuyFrameView setBackgroundColor:[UIColor whiteColor]];
    [fatGuyFrameView setCenter:CGPointMake(fatGuyView.center.x, fatGuyView.center.y + APPCONFIG_UI_VIEW_BETWEEN_PADDING)];
    [fatGuyFrameView addTarget:self action:@selector(tappedStoreBtn) forControlEvents:UIControlEventTouchUpInside];
    fatGuyFrameView.layer.cornerRadius = fatGuyViewHeight * FatGuyHeightRatio / 2.0f;
    fatGuyFrameView.layer.shadowColor = themeDeepBlueColor.CGColor;
    fatGuyFrameView.layer.shadowOffset = CGSizeMake(0, 4);
    fatGuyFrameView.layer.shadowOpacity = 1;
    fatGuyFrameView.layer.shadowRadius = 0;
    [fatGuyView addSubview:fatGuyFrameView];
}

- (void)initDataView {
    //开始锻炼按钮
    UIButton* startTrainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    startTrainBtn.frame = CGRectMake(APPCONFIG_UI_VIEW_PADDING, APPCONFIG_UI_SCREEN_VHEIGHT - APPCONFIG_UI_VIEW_PADDING  - TitleLabelWidth, APPCONFIG_UI_SCREEN_FWIDTH - APPCONFIG_UI_VIEW_PADDING * 2, TitleLabelWidth);
    //[startTrainBtn setBackgroundImage:[UIImage imageWithUIColor:themeGreyColor andCGSize:startTrainBtn.bounds.size] forState:UIControlStateDisabled];
    //[startTrainBtn setBackgroundImage:[UIImage imageWithUIColor:themePureBlueColor andCGSize:startTrainBtn.bounds.size] forState:UIControlStateNormal];
    [startTrainBtn setBackgroundColor:themePureBlueColor];
    startTrainBtn.layer.cornerRadius = 15.0f;
    //startTrainBtn.layer.masksToBounds = YES;
    startTrainBtn.layer.shadowOffset = CGSizeMake(0, 4);
    startTrainBtn.layer.shadowRadius = 0;
    startTrainBtn.layer.shadowOpacity = 1;
    startTrainBtn.layer.shadowColor = shadowBlueColor.CGColor;
    [startTrainBtn addTarget:self action:@selector(tappedStartTrainBtn) forControlEvents:UIControlEventTouchUpInside];
    [startTrainBtn setTitle:@"开始锻炼" forState:UIControlStateNormal];
    [startTrainBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    startTrainBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [_bodyView addSubview:startTrainBtn];
    
    //两个框
    CGFloat dayViewWidth = (APPCONFIG_UI_SCREEN_FWIDTH - APPCONFIG_UI_VIEW_PADDING * 2 - APPCONFIG_UI_VIEW_BETWEEN_PADDING) / 2.0f;
    //左边日历框
    UIView *leftDayView = [CommonUtil createViewWithFrame:CGRectMake(APPCONFIG_UI_VIEW_PADDING + LevelIconWidth / 4.0f, 0, dayViewWidth - LevelIconWidth / 4.0f, LevelViewHeight) andHasBorder:NO];
    leftDayView.layer.cornerRadius = 10.0f;
    [leftDayView topOfView:startTrainBtn withMargin:APPCONFIG_UI_VIEW_PADDING];
    [_bodyView addSubview:leftDayView];
    
    UIImageView *leftCalendarImage = [[UIImageView alloc] init];
    leftCalendarImage.frame = CGRectMake(APPCONFIG_UI_VIEW_PADDING, 0, LevelIconWidth, LevelIconWidth);
    leftCalendarImage.image = [UIImage imageNamed:@"CalendarIcon"];
    leftCalendarImage.contentMode = UIViewContentModeScaleAspectFit;
    leftCalendarImage.layer.cornerRadius = LevelIconWidth/2.0f;
    leftCalendarImage.layer.masksToBounds = YES;
    leftCalendarImage.layer.borderColor = [UIColor whiteColor].CGColor;
    leftCalendarImage.layer.borderWidth = 4.0f;
    [leftCalendarImage topOfView:startTrainBtn withMargin:APPCONFIG_UI_VIEW_PADDING];
    [_bodyView addSubview:leftCalendarImage];

    UILabel *leftDayTipLabel = [CommonUtil createLabelWithText:@"坚持天数" andTextColor:tipTitleLabelColor andFont:[UIFont systemFontOfSize:10] andTextAlignment:NSTextAlignmentRight];
    leftDayTipLabel.frame = CGRectMake(CGRectGetMaxX(leftDayView.frame) - APPCONFIG_UI_VIEW_BETWEEN_PADDING - DayLabelInset.right, 0, DayLabelInset.right, DayLabelInset.bottom);
    [leftDayTipLabel topOfView:leftDayView withMargin:3.0f];
    [_bodyView addSubview:leftDayTipLabel];
    
    leftHistoryDayLabel = [CommonUtil createLabelWithText:@"" andTextColor:tipTitleLabelColor andFont:[UIFont boldSystemFontOfSize:24] andTextAlignment:NSTextAlignmentCenter];
    leftHistoryDayLabel.frame = CGRectMake(20, 0, leftDayView.width - 20, leftDayView.height);
    [leftDayView addSubview:leftHistoryDayLabel];
    
    UIButton *leftDayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftDayButton setFrame:CGRectMake(APPCONFIG_UI_VIEW_PADDING, 0, dayViewWidth, LevelIconWidth)];
    [leftDayButton addTarget:self action:@selector(tappedLeftDayButton) forControlEvents:UIControlEventTouchUpInside];
    [leftDayButton topOfView:startTrainBtn withMargin:APPCONFIG_UI_VIEW_PADDING];
    [_bodyView addSubview:leftDayButton];

    //右边等级框
    levelProgressBar = [[WQProgressBar alloc] initWithFrame:CGRectMake(APPCONFIG_UI_SCREEN_FWIDTH - dayViewWidth - APPCONFIG_UI_VIEW_PADDING, CGRectGetMinY(leftCalendarImage.frame), dayViewWidth, LevelIconWidth)];
    [_bodyView addSubview:levelProgressBar];
    
    UIButton *rightDayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightDayButton setFrame:CGRectMake(APPCONFIG_UI_SCREEN_FWIDTH - dayViewWidth - APPCONFIG_UI_VIEW_PADDING, 0, dayViewWidth, LevelIconWidth)];
    [rightDayButton addTarget:self action:@selector(tappedRightDayButton) forControlEvents:UIControlEventTouchUpInside];
    [rightDayButton topOfView:startTrainBtn withMargin:APPCONFIG_UI_VIEW_PADDING];
    [_bodyView addSubview:rightDayButton];
    
    //最后加上阴影层
    _shadowView = [[UIButton alloc] initWithFrame:_bodyView.bounds];
    _shadowView.backgroundColor = popBackgroundColor;
    _shadowView.alpha = 0;
    [_shadowView addTarget:self action:@selector(tappedShadow) forControlEvents:UIControlEventTouchUpInside];
    [_bodyView addSubview:_shadowView];
}

- (void)initCalendar {
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, -CalendarViewHeight, APPCONFIG_UI_SCREEN_FWIDTH, CalendarViewHeight)];
    _headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_headView];
    
    _isPull = YES;
    
    NSDate* today = [NSDate date];
    
    UILabel* calendarDate = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 200, 20)];
    [calendarDate setTextColor:tipTitleLabelColor];
    [calendarDate setFont:[UIFont boldSystemFontOfSize:16]];
    [calendarDate setText:[NSString stringWithFormat:@"%lu.%.2lu", (unsigned long)today.year, (unsigned long)today.month]];
    [_headView addSubview:calendarDate];
    
    if ([today numberOfWeeksInMonth] == 6) {
        calendar = [[WQCalendar alloc] initWithFrame:CGRectMake(10, 40, _headView.width - 20, 245)];
        [_headView addSubview:calendar];
    } else {
        float tileWidth = (_headView.width - 20) / 7;
        CGFloat topPadding = CGRectGetMaxY(calendarDate.frame) + 10;
        for (int i = 0; i < 7; i++) {
            UILabel* calendarTitle = [[UILabel alloc] initWithFrame:CGRectMake(10 + i * tileWidth, topPadding, tileWidth, tileWidth - 10)];
            [calendarTitle setTextAlignment:NSTextAlignmentCenter];
            [calendarTitle setFont:[UIFont systemFontOfSize:16]];
            [_headView addSubview:calendarTitle];
            
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
        
        calendar = [[WQCalendar alloc] initWithFrame:CGRectMake(10, topPadding + tileWidth - 10, _headView.frame.size.width - 20, 245)];
        [_headView addSubview:calendar];
    }
}

#pragma mark - 弹窗相关 
- (void)addPopView {
    //先来个背景返回
    UIButton *popBackgroundButton = [[UIButton alloc] initWithFrame:self.view.bounds];
    [popBackgroundButton setBackgroundColor:popBackgroundColor];
    [self.view addSubview:popBackgroundButton];
    
    UIView *popView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width - 70, 200)];
    popView.backgroundColor = popContentColor;
    popView.center = CGPointMake(popBackgroundButton.center.x, popBackgroundButton.center.y - 30.0f);
    popView.layer.cornerRadius = 16;
    popView.layer.masksToBounds = YES;
    popView.layer.borderColor = themeBlueColor.CGColor;
    popView.layer.borderWidth = 2.0f;
    [popBackgroundButton addSubview:popView];
    
    UILabel *popLable = [[UILabel alloc] initWithFrame:CGRectMake(30, 20, popView.width - 60, 100)];
    [popLable setNumberOfLines:2];
    [popLable setTextAlignment:NSTextAlignmentCenter];
    [popLable setText:@"是否允许上传锻炼数据，查看自己的成绩排名？"];
    [popLable setTextColor:tipTitleLabelColor];
    [popView addSubview:popLable];
    
    UIButton *popViewCommitButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 113, popView.width - 100, 34)];
    popViewCommitButton.backgroundColor = themeBlueColor;
    popViewCommitButton.titleLabel.textColor = [UIColor whiteColor];
    popViewCommitButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    popViewCommitButton.layer.cornerRadius = 10;
    [popViewCommitButton setTitle:@"允许～" forState:UIControlStateNormal];
    [popViewCommitButton addTarget:self action:@selector(tappedPopCommit:) forControlEvents:UIControlEventTouchUpInside];
    [popView addSubview:popViewCommitButton];
    
    UIButton *popViewCancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    popViewCancelButton.frame = CGRectMake(50, 147, popView.width - 100, 34);
    [popViewCancelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    popViewCancelButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [popViewCancelButton setTitle:@"下次再说" forState:UIControlStateNormal];
    [popViewCancelButton addTarget:self action:@selector(tappedPopViewCancel:) forControlEvents:UIControlEventTouchUpInside];
    [popView addSubview:popViewCancelButton];
    
    UIView *popLine = [[UIView alloc] initWithFrame:CGRectMake(100, 170, popView.width - 200, 0.5f)];
    [popLine setBackgroundColor:[UIColor lightGrayColor]];
    [popView addSubview:popLine];
}

- (void)tappedPopViewCancel:(UIButton *)sender {
    [[[sender superview] superview] removeFromSuperview];
}

- (void)tappedPopCommit:(UIButton *)sender {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"AllowSendToServer"];
    
    [[[sender superview] superview] removeFromSuperview];
    
    [[AppCore sharedAppCore] networkUpdateAccount];
}

#pragma mark - Class Extention Delegate
- (void)tappedStartTrainBtn {
    ExerciseViewController* new = [[ExerciseViewController alloc] init];
    [self.navigationController pushViewController:new animated:YES];
}

- (void)tappedStoreBtn {
    StoreViewController *view = [[StoreViewController alloc] init];
    [view setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:view animated:YES];
}

- (void)tappedShareBtn {
    
}

- (void)tappedShadow {
    _isPull = true;
    [UIView animateWithDuration:0.5f animations:^{
        _headView.frame = CGRectMake(0, - CalendarViewHeight, APPCONFIG_UI_SCREEN_FWIDTH, CalendarViewHeight);
        _bodyView.frame = CGRectMake(0, 0, APPCONFIG_UI_SCREEN_FWIDTH, APPCONFIG_UI_SCREEN_VHEIGHT);
        _shadowView.alpha = 0;
    }];
}

- (void)tappedLeftDayButton {
    _isPull = false;
    [UIView animateWithDuration:0.5f animations:^{
        _headView.frame = CGRectMake(0, 0, APPCONFIG_UI_SCREEN_FWIDTH, CalendarViewHeight);
        _bodyView.frame = CGRectMake(0, CalendarViewHeight, APPCONFIG_UI_SCREEN_FWIDTH, APPCONFIG_UI_SCREEN_VHEIGHT);
        _shadowView.alpha = 1;
    }];
}

- (void)tappedRightDayButton {
    [self.tabBarController setSelectedIndex:1];
}

#pragma mark - Gesture Delegate
- (void) handlePan: (UIPanGestureRecognizer *)rec{
    float y = [rec translationInView:self.view].y;
    float speed = [rec velocityInView:self.view].y;
    
    CGRect tmpFrame;
    
    if (([rec state] == UIGestureRecognizerStateEnded) || ([rec state] == UIGestureRecognizerStateCancelled)) {
        if (_isPull) {
            if (y < 100 && speed < 1000.f) {
                [UIView animateWithDuration:0.2f animations:^{
                    _headView.frame = CGRectMake(0, - CalendarViewHeight, APPCONFIG_UI_SCREEN_FWIDTH, CalendarViewHeight);
                    _bodyView.frame = CGRectMake(0, 0, APPCONFIG_UI_SCREEN_FWIDTH, APPCONFIG_UI_SCREEN_VHEIGHT);
                    _shadowView.alpha = 0;
                }];
            } else {
                _isPull = false;
                [UIView animateWithDuration:0.2f animations:^{
                    _headView.frame = CGRectMake(0, 0, APPCONFIG_UI_SCREEN_FWIDTH, CalendarViewHeight);
                    _bodyView.frame = CGRectMake(0, CalendarViewHeight, APPCONFIG_UI_SCREEN_FWIDTH, APPCONFIG_UI_SCREEN_VHEIGHT);
                    _shadowView.alpha = 1;
                }];
            }
        } else {
            if (-y < 100 && -speed < 1000.f) {
                [UIView animateWithDuration:0.2f animations:^{
                    _headView.frame = CGRectMake(0, 0, APPCONFIG_UI_SCREEN_FWIDTH, CalendarViewHeight);
                    _bodyView.frame = CGRectMake(0, CalendarViewHeight, APPCONFIG_UI_SCREEN_FWIDTH, APPCONFIG_UI_SCREEN_VHEIGHT);
                    _shadowView.alpha = 1;
                }];
            } else {
                _isPull = true;
                [UIView animateWithDuration:0.2f animations:^{
                    _headView.frame = CGRectMake(0, - CalendarViewHeight, APPCONFIG_UI_SCREEN_FWIDTH, CalendarViewHeight);
                    _bodyView.frame = CGRectMake(0, 0, APPCONFIG_UI_SCREEN_FWIDTH, APPCONFIG_UI_SCREEN_VHEIGHT);
                    _shadowView.alpha = 0;
                }];
            }
        }
    } else if (_isPull) {
        if (y >= -20 && y <= CalendarViewHeight + 20) {
            tmpFrame = _bodyView.frame;
            tmpFrame.origin.y = y;
            _bodyView.frame = tmpFrame;
            tmpFrame = _headView.frame;
            tmpFrame.origin.y = y - CalendarViewHeight;
            _headView.frame = tmpFrame;
            
            _shadowView.alpha = fabsf(y) / CalendarViewHeight;
        }
    } else {
        if (y <= -20 && y >= -CalendarViewHeight - 20) {
            tmpFrame = _bodyView.frame;
            tmpFrame.origin.y = y + CalendarViewHeight;
            _bodyView.frame = tmpFrame;
            tmpFrame = _headView.frame;
            tmpFrame.origin.y = y;
            _headView.frame = tmpFrame;
            
            _shadowView.alpha = 1 - fabsf(y) / CalendarViewHeight;
        }
    }
}

@end
