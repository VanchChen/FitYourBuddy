//
//  CommonUtil.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/3/27.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "CommonUtil.h"

@implementation CommonUtil

#pragma mark - UILabel
#define defaultFont [UIFont systemFontOfSize:17.0f]
#define defaultColor [UIColor blackColor]

+ (UILabel *)createLabelWithText:(NSString *)text {
    return [self createLabelWithText:text andFont:defaultFont];
}

+ (UILabel *)createLabelWithText:(NSString *)text andTextColor:(UIColor *)color {
    return [self createLabelWithText:text andTextColor:color andFont:defaultFont];
}

+ (UILabel *)createLabelWithText:(NSString *)text andFont:(UIFont *)font {
    return [self createLabelWithText:text andTextColor:defaultColor andFont:font];
}

+ (UILabel *)createLabelWithText:(NSString *)text andTextColor:(UIColor *)color andFont:(UIFont *)font {
    return [self createLabelWithText:text andTextColor:color andFont:font andTextAlignment:NSTextAlignmentLeft];
}

+ (UILabel *)createLabelWithText:(NSString *)text andTextColor:(UIColor *)color andFont:(UIFont *)font andTextAlignment:(NSTextAlignment)alignment {
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.text = text;
    label.textColor = color;
    label.font = font;
    label.textAlignment = alignment;
    
    return label;
}

#pragma mark - UIView
/**创建标准圆角白底框（没有frame）*/
+ (UIView *)createView {
    return [self createViewWithFrame:CGRectZero andHasBorder:YES];
}

/**创建标准圆角白底框*/
+ (UIView *)createViewWithFrame:(CGRect)frame {
    return [self createViewWithFrame:frame andHasBorder:YES];
}

/**创建标准圆角白底框(没有边框)*/
+ (UIView *)createViewWithFrame:(CGRect)frame andHasBorder:(BOOL)hasBorder {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.layer.cornerRadius = 15;
    view.layer.masksToBounds = YES;
    if (hasBorder) {
        view.layer.borderColor = themeGreyColor.CGColor;
        view.layer.borderWidth = 1.0f;
    }
    
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

#pragma mark - Level & Exp
+ (float)getExpFromLevel:(NSString *)level {
    int l = [level intValue];
    switch (l) {
        case 1:
            return 200;
            break;
        case 2:
            return 1000;
            break;
        case 3:
            return 4000;
            break;
        case 4:
            return 12000;
            break;
        default:
            return 0;
            break;
    }
}

/**根据类型和等级得到目标数*/
+ (NSInteger)getTargetNumFromType:(ExerciseType)type andLevel:(NSInteger)level {
    NSInteger targetNum = 0;
    switch (type) {
        case ExerciseTypePushUp:
            targetNum = level - 1 + 10;
            break;
        case ExerciseTypeSitUp:
            targetNum = level - 1 + 20;
            break;
        case ExerciseTypeSquat:
            targetNum = level - 1 + 20;
            break;
        case ExerciseTypeWalk:
            targetNum = (level - 1) * 100 + 1000;
            break;
        default:
            break;
    }
    return targetNum;
}

@end
