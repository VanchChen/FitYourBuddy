//
//  SettingsViewController.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/2/19.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "SettingsViewController.h"

#import "WQTableView.h"
#import "SettingsDetailViewController.h"

//@interface SettingsTableCell : WQTableViewCell
//
//@end
//
//@implementation SettingsTableCell
//
//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        self.selectionStyle = UITableViewCellSelectionStyleNone; //取消点击效果
//        self.backgroundColor = [UIColor clearColor];
//
//        UIView *backgroundView = [CommonUtil createViewWithFrame:CGRectMake(20, 10, self.width - 40, 50)];
//        backgroundView.layer.borderColor = settingBorderColor.CGColor;
//        [self addSubview:backgroundView];
//    }
//    return self;
//}
//
//@end

@interface SettingsViewController () <UIAlertViewDelegate>

@property (nonatomic, strong) UIButton *btn1;
@property (nonatomic, strong) UIButton *btn2;
@property (nonatomic, strong) NSString *payAddress;
@property (nonatomic, strong) UIImageView *poemImg;
//@property(nonatomic, strong) WQTableView *tableView;

@end

@implementation SettingsViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"关于我们"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"关于我们"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"关于我们";
    
    [self setButtons];
    //[self initTable];
}

- (void)setButtons {
    _payAddress = @"540985254@qq.com";
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, APPCONFIG_UI_SCREEN_FWIDTH, APPCONFIG_UI_SCREEN_FHEIGHT)];
    scrollView.contentSize = CGSizeMake(scrollView.width, scrollView.height + 1);
    [self.view addSubview:scrollView];
    
    _btn1 = [[UIButton alloc]initWithFrame:CGRectMake(30, 25, APPCONFIG_UI_SCREEN_FWIDTH - 60, 60)];
    _btn1.layer.cornerRadius = 15;
    _btn1.layer.borderWidth = 2;
    _btn1.layer.borderColor = themeDeepBlueColor.CGColor;
    _btn1.backgroundColor = [UIColor whiteColor];
    [_btn1 setTitleColor:tipTitleLabelColor forState:UIControlStateNormal];
    [_btn1 setTitle:@"给我们评分" forState:UIControlStateNormal];
    [_btn1 addTarget:self action:@selector(rollToRate) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:_btn1];
    
    _btn2 = [[UIButton alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(_btn1.frame) + 25, APPCONFIG_UI_SCREEN_FWIDTH - 60, 90)];
    _btn2.layer.cornerRadius = 15;
    _btn2.layer.borderWidth = 2;
    _btn2.layer.borderColor = themeDeepBlueColor.CGColor;
    _btn2.backgroundColor = [UIColor whiteColor];
    [_btn2 setTitleColor:tipTitleLabelColor forState:UIControlStateNormal];
    _btn2.titleLabel.numberOfLines = 3;
    _btn2.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_btn2 setTitle:[NSString stringWithFormat:@"通过支付宝支持我们:\n%@", _payAddress] forState:UIControlStateNormal];
    [_btn2 addTarget:self action:@selector(payUsAlert) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:_btn2];
    
    _poemImg = [[UIImageView alloc]initWithFrame:CGRectMake(35, CGRectGetMaxY(_btn2.frame) + 20, APPCONFIG_UI_SCREEN_FWIDTH - 60, APPCONFIG_UI_SCREEN_FHEIGHT - CGRectGetMaxY(_btn2.frame) - APPCONFIG_UI_TABBAR_HEIGHT - APPCONFIG_UI_NAVIGATIONBAR_HEIGHT - APPCONFIG_UI_STATUSBAR_HEIGHT - 40)];
    [_poemImg setContentMode:UIViewContentModeScaleAspectFit];
    _poemImg.image = [UIImage imageNamed:@"PoemImage"];
    [scrollView addSubview:_poemImg];
}

- (void)rollToRate {
    NSString *str = [NSString stringWithFormat:@"%@",
                     @"itms-apps://itunes.apple.com/cn/app/tian-tian-qu-jian-shen-zui/id1035157441?mt=8" ];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (void)payUsAlert {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _payAddress;
    UIAlertView *payAlert = [[UIAlertView alloc]initWithTitle:@"支持我们" message:@"支付宝帐号已复制" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
    [payAlert show];
}

//- (void)initTable {
//    self.tableView = [[WQTableView alloc] initWithStyle:NO];
//    self.tableView.frame = CGRectMake(0, 0, self.view.width, APPCONFIG_UI_SCREEN_VHEIGHT);
//    self.tableView.backgroundColor = indexBackgroundColor;
//    //self.tableView.ctrl = self;
//    [self.view addSubview:self.tableView];
//
//    __weak typeof(self) __weakMe = self;
//
//    self.tableView.headerForSection = ^UIView *(WQTableView *tableView, NSInteger section) {
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 30)];
//        return view;
//    };
//
//
//
//    //计算单元格的高度
//    self.tableView.heightForRow = ^CGFloat(WQTableView *tableView, NSIndexPath *indexPath) {
//        return 70.0f;
//    };
//
//    //单元格点击事件
//    self.tableView.didSelectRow = ^(WQTableView *table, NSIndexPath *indexPath) {
//        switch (indexPath.row) {
//            case 0:{
//                NSString *str = [NSString stringWithFormat:@"%@",
//                                 @"itms-apps://itunes.apple.com/cn/app/xin-ze-ling/id873925170?mt=8" ];
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
//                break;
//            }
//            case 1:{
//                SettingsDetailViewController *vc = [SettingsDetailViewController createSettingsDetailWithType:DetailTypeTeam];
//                [__weakMe.navigationController pushViewController:vc animated:YES];
//                break;
//            }
//            case 2:{
//                SettingsDetailViewController *vc = [SettingsDetailViewController createSettingsDetailWithType:DetailTypeSupport];
//                [__weakMe.navigationController pushViewController:vc animated:YES];
//                break;
//            }
//            default:
//                break;
//        }
//    };
//
//    //单元格样式
//    self.tableView.modifiRowClass = ^Class(WQTableView *table, Class originClass, NSIndexPath *indexPath) {
//        return [SettingsTableCell class];
//    };
//    //一定要在modifiRowClass后取消分割线
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//}

@end
