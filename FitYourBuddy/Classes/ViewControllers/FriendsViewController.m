//
//  FriendsViewController.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/2/19.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "FriendsViewController.h"

#import "WQTableView.h"
#import "WQTableData.h"
#import "DataLoader.h"
#import "DataItemResult.h"

#import "FriendsTableViewCell.h"

static UIEdgeInsets const popViewInset       = (UIEdgeInsets){0,0,320,280};//弹出框，分别为（上，左，高，宽）
static CGFloat      const popIconWidth       = 40.0f;
static CGFloat      const popIconLeftPadding = 40.0f;

@interface FriendsViewController ()

@property (nonatomic, strong) UIButton          *staminaBtn;
@property (nonatomic, strong) UIButton          *strengthBtn;
@property (nonatomic, strong) WQTableView       *tableView;
@property (nonatomic, assign) NSInteger         clientID;

@property (nonatomic, strong) WQTableData       *staminaData;
@property (nonatomic, strong) WQTableData       *strengthData;

@end

@implementation FriendsViewController

#pragma mark - 生命循环

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"萌胖圈"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"萌胖圈"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"萌胖圈";
    
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
            
            [self.tableView removeSection:0];
            [self.tableView addSectionWithData:self.staminaData];
            
            if ([self.staminaData isLoadDataComplete]) {
                [self.tableView reloadData];
            } else {
                [self.staminaData refreshData];
            }
        } else {
            _staminaBtn.selected = NO;
            _strengthBtn.selected = YES;
            
            [self.tableView removeSection:0];
            [self.tableView addSectionWithData:self.strengthData];
            
            if ([self.strengthData isLoadDataComplete]) {
                [self.tableView reloadData];
            } else {
                [self.strengthData refreshData];
            }
        }
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
    UIImage *blueBlurImage = [UIImage imageWithUIColor:RGB_A(160, 209, 253, 1) andCGSize:CGSizeMake(segmentView.width / 2.0f, segmentView.height)];
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
    // 首先先拿客户端ID，这里需要保存是因为要和数据包比对区分我的位置
    self.clientID = [[AccountCoreDataHelper getDataByName:@"clientID" withError:nil] integerValue];
    
    self.tableView = [[WQTableView alloc] initWithStyle:YES];
    self.tableView.frame = CGRectMake(20, 50, self.view.width - 40, APPCONFIG_UI_SCREEN_VHEIGHT - 60);
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.layer.cornerRadius = 10;
    self.tableView.layer.masksToBounds = YES;
    self.tableView.layer.borderWidth = 1.0f;
    self.tableView.layer.borderColor = themePureBlueColor.CGColor;
    
    self.tableView.ctrl = self;
    self.tableView.isRefreshType = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    __weak typeof(self) __weakMe = self;
    
    //数据请求
    self.tableView.requestData = ^DataLoader *(WQTableData *tableData){
        NSMutableString *urlString = [[NSMutableString alloc] initWithString:APPCONFIG_CONN_HEAD];
        [urlString appendString:APPCONFIG_CONN_SERVER];
        [urlString appendString:APPCONFIG_CONN_AGENT];
        [urlString appendString:@"/getRankList?clientID="];
        [urlString appendString:[NSString stringFromInteger:__weakMe.clientID]];
        if (__weakMe.staminaBtn.selected) {
            [urlString appendString:@"&type=0"];
        } else {
            [urlString appendString:@"&type=1"];
        }
        
        //完成回调由table完成
        DataLoader *loader = [[DataLoader alloc] initWithURL:urlString httpMethod:Method_GET complete:nil];
        return loader;
    };
    
    //数据回调
    self.tableView.receiveData = ^(WQTableView *tableView, WQTableData *tableViewData, DataItemResult *result){
        if (result.hasError) {
            //显示出错cell，或者加载缓存
            NSLog(@"%@", result.message);
            return ;
        }
        
        //解析数据
        NSData *data = result.rawData;
        id jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if (jsonDict == nil) {
            result.hasError = YES;
            result.message = @"JSON数据解析失败!";
            return;
        }
        
        NSDictionary *dataDict = [NSDictionary dictionaryWithDictionary:(NSDictionary *)jsonDict];
        DataItemResult *newResult = [DataItemResult resultFromAnother:result];
        newResult.hasError = NO;
        
        NSArray *dataArray = dataDict[HTTP_PACKAGE_RESULT];
        if (dataArray && dataArray.count > 0) {
            newResult.maxCount = dataArray.count;
            
            [dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSDictionary *detailDict = (NSDictionary *)obj;
                DataItemDetail *detail = [DataItemDetail detailFromDictionary:detailDict];
                NSInteger detailClientID = [detailDict[Friends_List_ClientID] integerValue];
                if (detailClientID == __weakMe.clientID) {
                    [detail setBool:YES forKey:Friends_List_IsMe];
                } else {
                    [detail setBool:NO forKey:Friends_List_IsMe];
                }
                [newResult addItem:detail];
            }];
        }
        
        [tableViewData.tableDataResult appendItems:newResult];
    };
    
    //计算单元格的高度
    self.tableView.heightForRow = ^CGFloat(WQTableView *tableView, NSIndexPath *indexPath) {
        return 50.0f;
    };
    
    //单元格点击事件
    self.tableView.didSelectRow = ^(WQTableView *table, NSIndexPath *indexPath) {
        [__weakMe didSelectedCell:table indexPath:indexPath];
    };
    
    //单元格样式
    self.tableView.modifiRowClass = ^Class(WQTableView *table, Class originClass, NSIndexPath *indexPath) {
        if (__weakMe.staminaBtn.selected) {
            return [FriendsStaminaCell class];
        } else {
            return [FriendsStrengthCell class];
        }
    };
    
    //绑定tabledata
    self.staminaData = [WQTableData new];
    self.staminaData.mDataCellClass = [FriendsStaminaCell class];//默认值
    self.staminaData.mLoadingCellClass = [WQTableViewCell class];
    [self.tableView addSectionWithData:self.staminaData];
    
    [self.staminaData refreshData];
    
    //初始化另一个表的数据
    self.strengthData = [WQTableData new];
    self.strengthData.mDataCellClass = [FriendsStrengthCell class];
    self.strengthData.mLoadingCellClass = [WQTableViewCell class];
}

#pragma mark - WQTableView Method
/** 点击单元格 */
- (void)didSelectedCell:(WQTableView *)table indexPath:(NSIndexPath *)indexPath {
    //获取数据
    DataItemDetail *detail = [table dataOfIndexPath:indexPath];
    NSString *name = [detail getString:Friends_List_Name];
    NSString *count = [detail getString:Friends_List_Count];
    NSString *level = [detail getString:Friends_List_Level];
    NSString *gender = [detail getString:Friends_List_Gender];
    NSString *eye = [detail getString:Friends_List_Eye];
    NSString *mouth = [detail getString:Friends_List_Mouth];
    NSString *fight = [detail getString:Friends_List_Fight];
    
    if ([detail getBool:Friends_List_IsMe]) {
        //如果是自己的话，则取本地数据
        count = [AccountCoreDataHelper getDataByName:@"count" withError:nil];
        level = [AccountCoreDataHelper getDataByName:@"level" withError:nil];
        eye = [AccountCoreDataHelper getDataByName:@"eye" withError:nil];
        mouth = [AccountCoreDataHelper getDataByName:@"mouth" withError:nil];
        NSString *exp = [AccountCoreDataHelper getDataByName:@"exp" withError:nil];
        fight = [NSString stringWithFormat:@"%.f",([exp floatValue] / [count floatValue]) * 100];
    }
    
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
    
    UILabel *nameLabel = [CommonUtil createLabelWithText:name andFont:[UIFont systemFontOfSize:20.0f]];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.frame = CGRectMake(0, 10, popView.width, 30.0f);
    [popView addSubview:nameLabel];
    
    UIView *nameImage = [self createFatGuyWithFrame:CGRectMake(0, CGRectGetMaxY(nameLabel.frame) + 10.0f, popView.width, 200)
                                              level:level
                                             gender:gender
                                                eye:eye
                                              mouth:mouth];
    [popView addSubview:nameImage];
    
    UIImageView *calendarImage = [[UIImageView alloc] initWithFrame:CGRectMake(popIconLeftPadding, CGRectGetMaxY(nameImage.frame) + 10.0f, popIconWidth, popIconWidth)];
    calendarImage.image = [UIImage imageNamed:@"CalendarIcon"];
    [popView addSubview:calendarImage];
    
    if (self.staminaBtn.selected) {
        fight = [NSString stringWithFormat:@"%@天", count];
    } else {
        fight = [NSString stringWithFormat:@"%@瓦", fight];
    }
    
    UILabel *calendarLabel = [CommonUtil createLabelWithText:fight];
    calendarLabel.frame = CGRectMake(0, 0, 50, popIconWidth);
    [calendarLabel rightOfView:calendarImage withMargin:APPCONFIG_UI_VIEW_BETWEEN_PADDING sameVertical:YES];
    [popView addSubview:calendarLabel];
    
    UILabel *outLineLabel = [CommonUtil createLabelWithText:[NSString stringWithFormat:@"等级：%@",level]];
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

#pragma mark - 绘制小胖子
- (UIView *)createFatGuyWithFrame:(CGRect)frame level:(NSString *)level gender:(NSString *)gender eye:(NSString *)eye mouth:(NSString *)mouth {
    UIImage *bodyImagePict = [UIImage imageNamed:[NSString stringWithFormat:@"body_%@_%@",gender, level]];
    UIImage *eyeImagePict = [UIImage imageNamed:[NSString stringWithFormat:@"eye_tn_%@_%@",gender, eye]];
    UIImage *mouthImagePict = [UIImage imageNamed:[NSString stringWithFormat:@"mouth_tn_%@_%@",gender, mouth]];
    
    UIView *view = [UIView new];
    [view setFrame:frame];
    
    CGRect bodyRect, eyeRect, mouthRect;
    CGFloat eyeGap, mouthGap;
    
    eyeGap = 40;
    mouthGap = 65;
    
    bodyRect = CGRectMake(0, 0, bodyImagePict.size.width, bodyImagePict.size.height);
    eyeRect = CGRectMake(0, 0, eyeImagePict.size.width, eyeImagePict.size.height);
    mouthRect = CGRectMake(0, 0, mouthImagePict.size.width, mouthImagePict.size.height);
    
    //体型
    UIImageView *bodyImage = [[UIImageView alloc] initWithFrame:bodyRect];
    [bodyImage setImage:bodyImagePict];
    [bodyImage setCenter:CGPointMake(view.width / 2.0f, view.height / 2.0f)];
    [view addSubview:bodyImage];
    
    //眼睛
    UIImageView *_eyeImage = [[UIImageView alloc] initWithFrame:eyeRect];
    [_eyeImage setImage:eyeImagePict];
    _eyeImage.center = CGPointMake(view.width / 2.0f - 1.0f, eyeGap);
    [view addSubview:_eyeImage];
    
    //嘴巴
    UIImageView *_mouthImage = [[UIImageView alloc] initWithFrame:mouthRect];
    [_mouthImage setImage:mouthImagePict];
    _mouthImage.center = CGPointMake(view.width / 2.0f - 1.0f, mouthGap);
    [view addSubview:_mouthImage];
    
    return view;
}

@end
