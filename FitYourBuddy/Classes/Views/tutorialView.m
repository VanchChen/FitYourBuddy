//
//  tutorialView.m
//  FitYourBuddy
//
//  Created by ZhengKenneth on 15/8/21.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "tutorialView.h"

@interface tutorialView ()

@property (nonatomic, assign) ExerciseType type;
@property (nonatomic, copy)   CompleteBlock block;

@end

@implementation tutorialView

- (instancetype)initWithExerciseType:(ExerciseType)ExType complete:(CompleteBlock)block {
    self.type = ExType;
    self.block = block;
    
    switch (ExType) {
        case ExerciseTypePushUp:
            self = [super initWithFrame:CGRectMake(0, 0, APPCONFIG_UI_SCREEN_FWIDTH, APPCONFIG_UI_SCREEN_FHEIGHT)];
            break;
        case ExerciseTypeSquat:
            self = [super initWithFrame:CGRectMake(0, 0, APPCONFIG_UI_SCREEN_FHEIGHT, APPCONFIG_UI_SCREEN_FWIDTH)];
            break;
        case ExerciseTypeSitUp:
            self = [super initWithFrame:CGRectMake(0, 0, APPCONFIG_UI_SCREEN_FHEIGHT, APPCONFIG_UI_SCREEN_FWIDTH)];
            break;
            
        default:
            break;
    }
    if (self) {
        UIButton *maskBtn = [[UIButton alloc]initWithFrame:self.frame];
        maskBtn.backgroundColor = [UIColor colorWithWhite:0.396 alpha:0.700];
        [maskBtn addTarget:self action:@selector(maskClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:maskBtn];
        
        UIImageView *tutoPic = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 250 * APPCONFIG_UI_SCREEN_FWIDTH / 375, 250 * APPCONFIG_UI_SCREEN_FWIDTH / 375)];
        tutoPic.center = CGPointMake(0.5 * self.frame.size.width, 0.5 * self.frame.size.height);
        [tutoPic setContentMode:UIViewContentModeScaleAspectFit];
        switch (ExType) {
            case ExerciseTypePushUp:
                tutoPic.image = [UIImage imageNamed:@"PushUpTut"];
                break;
            case ExerciseTypeSquat:
                tutoPic.image = [UIImage imageNamed:@"SquatTut"];
                break;
            case ExerciseTypeSitUp:
                tutoPic.image = [UIImage imageNamed:@"SitUpTut"];
                break;
                
            default:
                break;
        }
        [self addSubview:tutoPic];
    }
    return self;
}

- (void)maskClick {
    //看完教程标记一下，下次不弹教程
    NSString *hasLaunchedOnce = [NSString string];
    switch (self.type) {
        case ExerciseTypePushUp:
            hasLaunchedOnce = @"PushUpHasLaunchedOnce";
            break;
        case ExerciseTypeSitUp:
            hasLaunchedOnce = @"SitUpHasLaunchedOnce";
            break;
        case ExerciseTypeSquat:
            hasLaunchedOnce = @"SquatHasLaunchedOnce";
            break;
        default:
            break;
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:hasLaunchedOnce];
    
    if (self.block) {
        self.block(self);
    }
}

@end
