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
        [self.tabBar setBackgroundImage:[UIImage imageWithUIColor:tarBarColor andCGSize:self.tabBar.frame.size]];
        [self.tabBar setOpaque:NO];
        [self.tabBar setTranslucent:NO];
        
        [self.tabBar setTintColor:[UIColor whiteColor]];//
        [self.tabBar setBarTintColor:[UIColor whiteColor]];
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
        UINavigationController* nav1 = [[UINavigationController alloc] initWithRootViewController:[[IndexViewController alloc] init]];
        UINavigationController* nav2 = [[UINavigationController alloc] initWithRootViewController:[[HistoryViewController alloc] init]];
        UINavigationController* nav3 = [[UINavigationController alloc] initWithRootViewController:[[FriendsViewController alloc] init]];
        UINavigationController* nav4 = [[UINavigationController alloc] initWithRootViewController:[[SettingsViewController alloc] init]];
        
        nav1.tabBarItem.title = @"";
        nav1.tabBarItem.image = [UIImage imageNamed:@"tabIndexSelectedIcon"];
        nav1.tabBarItem.selectedImage = [UIImage imageNamed:@"tabIndexIcon"];
        nav1.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
        
        nav2.tabBarItem.title = @"";
        nav2.tabBarItem.image = [UIImage imageNamed:@"tabHistorySelectedIcon"];
        nav2.tabBarItem.selectedImage = [UIImage imageNamed:@"tabHistoryIcon"];
        nav2.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
        
        nav3.tabBarItem.title = @"";
        nav3.tabBarItem.image = [UIImage imageNamed:@"tabFriendsSelectedIcon"];
        nav3.tabBarItem.selectedImage = [UIImage imageNamed:@"tabFriendsIcon"];
        nav3.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
        
        nav4.tabBarItem.title = @"";
        nav4.tabBarItem.image = [UIImage imageNamed:@"tabSettingsSelectedIcon"];
        nav4.tabBarItem.selectedImage = [UIImage imageNamed:@"tabSettingsIcon"];
        nav4.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
        
        [self setViewControllers:@[nav1,nav2,nav3,nav4]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(completeVCDidTappedButon) name:@"CompleteTapNote" object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CompleteTapNote" object:nil];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)completeVCDidTappedButon {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
