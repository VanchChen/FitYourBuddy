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
        [self.tabBar setBarTintColor:[UIColor whiteColor]];
        
        UINavigationController* nav1 = [[UINavigationController alloc] initWithRootViewController:[[IndexViewController alloc] init]];
        UINavigationController* nav2 = [[UINavigationController alloc] initWithRootViewController:[[HistoryViewController alloc] init]];
        UINavigationController* nav3 = [[UINavigationController alloc] initWithRootViewController:[[FriendsViewController alloc] init]];
        UINavigationController* nav4 = [[UINavigationController alloc] initWithRootViewController:[[SettingsViewController alloc] init]];
        
        
        nav1.tabBarItem.title = @"小胖砸";
        nav1.tabBarItem.image = [UIImage imageNamed:@"tabIndexSelectedIcon"];
        nav1.tabBarItem.selectedImage = [UIImage imageNamed:@"tabIndexIcon"];
        //nav1.tabBarItem.imageInsets = UIEdgeInsetsMake(2, 1, 0, 1);
        
        nav2.tabBarItem.title = @"统计";
        nav2.tabBarItem.image = [UIImage imageNamed:@"tabHistorySelectedIcon"];
        nav2.tabBarItem.selectedImage = [UIImage imageNamed:@"tabHistoryIcon"];
        //nav2.tabBarItem.imageInsets = UIEdgeInsetsMake(2, 1, 0, 1);
        
        nav3.tabBarItem.title = @"萌胖圈";
        nav3.tabBarItem.image = [UIImage imageNamed:@"tabFriendsSelectedIcon"];
        nav3.tabBarItem.selectedImage = [UIImage imageNamed:@"tabFriendsIcon"];
        //nav3.tabBarItem.imageInsets = UIEdgeInsetsMake(2, 1, 0, 1);
        
        nav4.tabBarItem.title = @"设置";
        nav4.tabBarItem.image = [UIImage imageNamed:@"tabSettingsSelectedIcon"];
        nav4.tabBarItem.selectedImage = [UIImage imageNamed:@"tabSettingsIcon"];
        //nav4.tabBarItem.imageInsets = UIEdgeInsetsMake(2, 1, 0, 1);
        
        [self setViewControllers:@[nav1,nav2,nav3,nav4]];
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
