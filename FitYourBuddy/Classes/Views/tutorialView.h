//
//  tutorialView.h
//  FitYourBuddy
//
//  Created by ZhengKenneth on 15/8/21.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class tutorialView;

typedef void (^CompleteBlock)(tutorialView *view);

@interface tutorialView : UIView

- (instancetype)initWithExerciseType:(ExerciseType)ExType complete:(CompleteBlock)block;

@end
