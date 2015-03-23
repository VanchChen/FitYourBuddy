//
//  UIView+Base.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/3/21.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "UIView+Base.h"

@implementation UIView (Base)
#pragma mark -
#pragma mark 位置
//设置起点的y值
- (void)setMinY:(CGFloat)top {
    CGRect rect = self.frame;
    
    rect.origin.y = top;
    
    self.frame = rect;
}

//设置起点的x值
- (void)setMinX:(CGFloat)left {
    CGRect rect = self.frame;
    
    rect.origin.x = left;
    
    self.frame = rect;
}

//在视图上方
- (void)topOfView:(UIView *)view {
    [self topOfView:view withMargin:0];
}

//在视图上方多少像素
- (void)topOfView:(UIView *)view withMargin:(CGFloat)margin {
    if (nil == view) {
        return;
    }
    
    CGRect rect = self.frame;
    
    rect.origin.y = view.frame.origin.y - self.frame.size.height - margin;
    
    self.frame = rect;
}

//在视图下方
- (void)bottomOfView:(UIView *)view {
    [self bottomOfView:view withMargin:0];
}

//在视图下方多少像素
- (void)bottomOfView:(UIView *)view withMargin:(CGFloat)margin {
    if (nil == view) {
        return;
    }
    
    CGRect rect = self.frame;
    
    rect.origin.y = view.frame.origin.y + view.frame.size.height + margin;
    
    self.frame = rect;
}

//在视图左方
- (void)leftOfView:(UIView *)view {
    [self leftOfView:view withMargin:0];
}

//在视图左方多少像素
- (void)leftOfView:(UIView *)view withMargin:(CGFloat)margin {
    [self leftOfView:view withMargin:margin sameVertical:NO];
}

//在视图左方多少像素并垂直居中
- (void)leftOfView:(UIView *)view withMargin:(CGFloat)margin sameVertical:(BOOL)same {
    if (nil == view) {
        return;
    }
    
    CGRect rect = self.frame;
    
    rect.origin.x = view.frame.origin.x - rect.size.width - margin;
    
    if (same) {
        rect.origin.y = view.frame.origin.y + (view.frame.size.height - rect.size.height) / 2;
    }
    
    self.frame = rect;
}

//在视图右方
- (void)rightOfView:(UIView *)view {
    [self rightOfView:view withMargin:0];
}

//在视图右方多少像素
- (void)rightOfView:(UIView *)view withMargin:(CGFloat)margin {
    [self rightOfView:view withMargin:margin sameVertical:NO];
}

//在视图右方多少像素并垂直居中
- (void)rightOfView:(UIView *)view withMargin:(CGFloat)margin sameVertical:(BOOL)same {
    if (nil == view) {
        return;
    }
    
    CGRect rect = self.frame;
    
    rect.origin.x = view.frame.origin.x + view.frame.size.width + margin;
    
    if (same) {
        rect.origin.y = view.frame.origin.y + (view.frame.size.height - rect.size.height) / 2;
    }
    
    self.frame = rect;
}

//在另一视图的水平中间
- (void)centerOfView:(UIView *)view {
    CGRect rect = self.frame;
    CGRect viewRect = view.frame;
    
    rect.origin.x = (viewRect.size.width - rect.size.width) / 2;
    
    self.frame = rect;
}

//在另一视图的垂直中间
- (void)verticalOfView:(UIView *)view {
    CGRect rect = self.frame;
    CGRect viewRect = view.frame;
    
    rect.origin.y = (viewRect.size.height - rect.size.height) / 2;
    
    self.frame = rect;
}

#pragma mark -
#pragma mark 大小
//设置视图宽
- (void)setWidth:(CGFloat)width {
    CGRect rect = self.frame;
    
    rect.size.width = width;
    
    self.frame = rect;
}

//设置视图高
- (void)setHeight:(CGFloat)height {
    CGRect rect = self.frame;
    
    rect.size.height = height;
    
    self.frame = rect;
}

#pragma mark -
#pragma mark 其他
//添加单机手势
- (UITapGestureRecognizer *)setTapGesture:(id)target action:(SEL)action {
    assert(nil != target);
    
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:tap];
    tap.delegate = target;
    return tap ;
}

/** 通过view获取controller */
- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]] && ![nextResponder isKindOfClass:[UINavigationController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    
    return nil;
}

@end
