//
//  TarBarViewController.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/2/25.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "TarBarViewController.h"

#import "IndexViewController.h"
#import "HistoryViewController.h"
#import "FriendsViewController.h"
#import "SettingsViewController.h"

@interface TarBarViewController ()

@end

@implementation TarBarViewController

- (id)init {
    self = [super init];
    if (self) {
        [self.tabBar setTintColor:themeBlueColor];
        
        UINavigationController* nav1 = [[UINavigationController alloc] initWithRootViewController:[[IndexViewController alloc] init]];
        UINavigationController* nav2 = [[UINavigationController alloc] initWithRootViewController:[[HistoryViewController alloc] init]];
        UINavigationController* nav3 = [[UINavigationController alloc] initWithRootViewController:[[FriendsViewController alloc] init]];
        UINavigationController* nav4 = [[UINavigationController alloc] initWithRootViewController:[[SettingsViewController alloc] init]];
        
        nav1.tabBarItem.title = @"小胖砸";
        nav1.tabBarItem.image = [UIImage imageNamed:@"tabIndexIcon"];
        
        nav2.tabBarItem.title = @"统计";
        nav2.tabBarItem.image = [UIImage imageNamed:@"tabHistoryIcon"];
        
        nav3.tabBarItem.title = @"萌胖圈";
        nav3.tabBarItem.image = [UIImage imageNamed:@"tabFriendsIcon"];
        
        nav4.tabBarItem.title = @"设置";
        nav4.tabBarItem.image = [UIImage imageNamed:@"tabSettingsIcon"];
        
        [self setViewControllers:[NSArray arrayWithObjects:nav1,nav2,nav3,nav4, nil]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
