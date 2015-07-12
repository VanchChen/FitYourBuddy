//
//  BaseViewController.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/7/12.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = indexBackgroundColor;
    
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

@end
