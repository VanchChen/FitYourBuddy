//
//  CommonUtil.h
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/3/27.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

//存放公用方法
@interface CommonUtil : NSObject

#pragma mark - UILabel
/**建立标签*/
+ (UILabel *)createLabelWithText:(NSString *)text;
/**建立标签*/
+ (UILabel *)createLabelWithText:(NSString *)text andTextColor:(UIColor *)color;
/**建立标签*/
+ (UILabel *)createLabelWithText:(NSString *)text andFont:(UIFont *)font;
/**建立标签*/
+ (UILabel *)createLabelWithText:(NSString *)text andTextColor:(UIColor *)color andFont:(UIFont *)font;
/**建立标签*/
+ (UILabel *)createLabelWithText:(NSString *)text andTextColor:(UIColor *)color andFont:(UIFont *)font andTextAlignment:(NSTextAlignment)alignment;

#pragma mark - UIView
/**创建标准圆角白底框（没有frame）*/
+ (UIView *)createView;
/**创建标准圆角白底框*/
+ (UIView *)createViewWithFrame:(CGRect)frame;
/**创建标准圆角白底框(没有边框)*/
+ (UIView *)createViewWithFrame:(CGRect)frame andHasBorder:(BOOL)hasBorder;

#pragma mark - 规则，这里不应该有！！！应该与业务无关！！！
/**根据经验得到等级*/
+ (float)getExpFromLevel:(NSString *)level;
/**根据类型和等级得到目标数*/
+ (NSInteger)getTargetNumFromType:(ExerciseType)type andLevel:(NSInteger)level;

#pragma mark - 方便计算的方法
/**根据文字和字体返回可能的UILable尺寸*/
+ (CGSize)getLabelSizeByText:(NSString *)text andFont:(UIFont *)font;

@end
