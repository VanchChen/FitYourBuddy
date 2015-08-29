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

@interface SettingsTableCell : WQTableViewCell

@end

@implementation SettingsTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone; //取消点击效果
        self.backgroundColor = [UIColor clearColor];
        
        UIView *backgroundView = [CommonUtil createViewWithFrame:CGRectMake(20, 10, self.width - 40, 50)];
        backgroundView.layer.borderColor = settingBorderColor.CGColor;
        [self addSubview:backgroundView];
    }
    return self;
}

@end

@interface SettingsViewController ()

@property(nonatomic, strong) WQTableView *tableView;

@end

@implementation SettingsViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"设置"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"设置"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"设置";
    
    //[self initTable];
}

- (void)initTable {
    self.tableView = [[WQTableView alloc] initWithStyle:NO];
    self.tableView.frame = CGRectMake(0, 0, self.view.width, APPCONFIG_UI_SCREEN_VHEIGHT);
    self.tableView.backgroundColor = indexBackgroundColor;
    //self.tableView.ctrl = self;
    [self.view addSubview:self.tableView];
    
    __weak typeof(self) __weakMe = self;
    
    self.tableView.headerForSection = ^UIView *(WQTableView *tableView, NSInteger section) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 30)];
        return view;
    };
    
    //计算单元格的高度
    self.tableView.heightForRow = ^CGFloat(WQTableView *tableView, NSIndexPath *indexPath) {
        return 70.0f;
    };
    
    //单元格点击事件
    self.tableView.didSelectRow = ^(WQTableView *table, NSIndexPath *indexPath) {
        switch (indexPath.row) {
            case 0:{
                NSString *str = [NSString stringWithFormat:@"%@",
                                 @"itms-apps://itunes.apple.com/cn/app/xin-ze-ling/id873925170?mt=8" ];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                break;
            }
            case 1:{
                SettingsDetailViewController *vc = [SettingsDetailViewController createSettingsDetailWithType:DetailTypeTeam];
                [__weakMe.navigationController pushViewController:vc animated:YES];
                break;
            }
            case 2:{
                SettingsDetailViewController *vc = [SettingsDetailViewController createSettingsDetailWithType:DetailTypeSupport];
                [__weakMe.navigationController pushViewController:vc animated:YES];
                break;
            }
            default:
                break;
        }
    };
    
    //单元格样式
    self.tableView.modifiRowClass = ^Class(WQTableView *table, Class originClass, NSIndexPath *indexPath) {
        return [SettingsTableCell class];
    };
    //一定要在modifiRowClass后取消分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

@end
