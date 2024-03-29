//
//  UIImage+Base.h
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/3/27.
//  Copyright (c) 2015年 xpz. All rights reserved.
//
@interface UIImage (Base)

/** 改变尺寸 */
-(UIImage *)transformToSize:(CGSize)newsize;

/** 根据颜色尺寸生成图片 */
+(UIImage *)imageWithUIColor:(UIColor *)color andCGSize:(CGSize)size;

/** 根据健身类型拿图标 */
+(UIImage *)imageWithExerciseType:(ExerciseType)type;

@end