//
//  WQAnimateLabel.h
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/6/1.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQAnimateLabel : UIView

- (void)setText:(NSString *)text;
- (void)setTextColor:(UIColor *)textColor;
- (void)setTextAlignment:(NSTextAlignment)textAlignment;
- (void)setFont:(UIFont *)font;

/**
 *  Change Label Text Num With Animation.
 *
 *  @param num1 Origin Num
 *  @param num2 After Num
 */
- (void)changeLabelFromNum1:(NSInteger)num1 toNum2:(NSInteger)num2;

@end
