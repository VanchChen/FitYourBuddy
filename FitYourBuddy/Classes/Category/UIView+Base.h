//
//  UIView+Base.h
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/3/21.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

@interface UIView (Base)

/**移动到兄弟view的上方*/
- (void)topOfView:(UIView *)view;

/**移动到兄弟view的上方，指定间距*/
- (void)topOfView:(UIView *)view withMargin:(CGFloat)margin;

/**移动到兄弟view的上方，指定间距，并且指定是否水平居中*/
- (void)topOfView:(UIView *)view withMargin:(CGFloat)margin sameHorizontal:(BOOL)same;

/**移动到兄弟view的下方*/
- (void)bottomOfView:(UIView *)view;

/**移动到兄弟view的下方，指定间距*/
- (void)bottomOfView:(UIView *)view withMargin:(CGFloat)margin;

/**移动到兄弟view的下方，指定间距，并且指定是否水平居中*/
- (void)bottomOfView:(UIView *)view withMargin:(CGFloat)margin sameHorizontal:(BOOL)same;

/**移动到兄弟view的左方*/
- (void)leftOfView:(UIView *)view;

/**移动到兄弟view的左方，指定间距*/
- (void)leftOfView:(UIView *)view withMargin:(CGFloat)margin;

/**移动到兄弟view的左方，指定间距，并且指定是否垂直居中*/
- (void)leftOfView:(UIView *)view withMargin:(CGFloat)margin sameVertical:(BOOL)same;

/**在视图右方*/
- (void)rightOfView:(UIView *)view;

/**移动到兄弟view的右方*/
- (void)rightOfView:(UIView *)view withMargin:(CGFloat)margin;

/**移动到兄弟view的右方，指定间距，并且指定是否垂直居中*/
- (void)rightOfView:(UIView *)view withMargin:(CGFloat)margin sameVertical:(BOOL)same;

/**设置视图宽*/
- (void)setWidth:(CGFloat)width;

/**设置视图高*/
- (void)setHeight:(CGFloat)height;

/**获得视图宽*/
- (CGFloat)width;

/**获得视图高*/
- (CGFloat)height;

/**设置起点的y值*/
- (void)setMinY:(CGFloat)top;

/**设置起点的x值*/
- (void)setMinX:(CGFloat)left;

/**在另一视图的水平中间*/
- (void)centerOfView:(UIView *)view;

/**在另一视图的垂直中间*/
- (void)verticalOfView:(UIView *)view;

//添加单机手势
- (UITapGestureRecognizer *)setTapGesture:(id)target action:(SEL)action;

/** 通过view获取controller */
- (UIViewController *)viewController;

@end
