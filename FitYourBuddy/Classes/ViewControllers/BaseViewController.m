//
//  BaseViewController.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/7/12.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "BaseViewController.h"
#import "AppCore.h"

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = indexBackgroundColor;
    
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //处理跳转
    //[[AppCore sharedAppCore] checkPresent];
}

@end
