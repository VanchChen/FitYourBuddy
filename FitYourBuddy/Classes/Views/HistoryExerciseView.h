//
//  HistoryExerciseView.h
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/4/1.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

@interface HistoryExerciseView : UIView

@property(nonatomic, assign) ExerciseType exerciseType;//锻炼类型

- (instancetype)initWithFrame:(CGRect)frame andExerciseType:(ExerciseType)type;
/**重载数据，但是有个问题就是不能更新跨天*/
- (void)reloadData;

@end
