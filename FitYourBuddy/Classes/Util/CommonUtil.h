//
//  CommonUtil.h
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/3/27.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import <Foundation/Foundation.h>

//存放公用方法
@interface CommonUtil : NSObject

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

/**创建标准圆角白底框（没有frame）*/
+ (UIView *)createView;
/**创建标准圆角白底框*/
+ (UIView *)createViewWithFrame:(CGRect)frame;
/**创建标准圆角白底框(没有边框)*/
+ (UIView *)createViewWithFrame:(CGRect)frame andHasBorder:(BOOL)hasBorder;

/**根据经验得到等级*/
+ (float)getExpFromLevel:(NSString *)level;

@end
