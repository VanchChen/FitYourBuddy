//
//  WorkOutViewController.h
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/7/5.
//  Copyright (c) 2015年 xpz. All rights reserved.
//
#import "WQCircleProgressBar.h"
#import "CompleteViewController.h"

@interface WorkOutViewController : BaseViewController

@property (nonatomic, assign) ExerciseType          exerciseType;

@property (nonatomic, assign) NSInteger             count;
@property (nonatomic, assign) NSInteger             targetNum;
@property (nonatomic, assign) NSInteger             maxExerciseNum;

@property (nonatomic, strong) UIView                *navBarView;
@property (nonatomic, strong) UILabel               *titleLabel;
@property (nonatomic, strong) UIButton              *soundButton;
@property (nonatomic, strong) UIView                *todayTargetView;
@property (nonatomic, strong) UIView                *maxRecordView;
@property (nonatomic, strong) UILabel               *recordLabel;
@property (nonatomic, strong) UIButton              *saveButton;
@property (nonatomic, strong) UIView                *coverView;
@property (nonatomic, strong) WQCircleProgressBar   *closedIndicator;

- (void)addPanGesture;

@end
