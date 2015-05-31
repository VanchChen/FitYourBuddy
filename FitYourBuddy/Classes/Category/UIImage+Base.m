//
//  UIImage+Base.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/3/27.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "UIImage+Base.h"

@implementation UIImage (Base)

-(UIImage *)transformToSize:(CGSize)newsize {
    //根据要显示的大小等比例算出缩放后的图片大小
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    
    float verticalRadio = newsize.height*1.0/height;
    float horizontalRadio = newsize.width*1.0/width;
    
    float radio = 1;
    if(verticalRadio>1 && horizontalRadio>1)
    {
        radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;
    }
    else
    {
        radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;
    }
    
    width = width*radio;
    height = height*radio;
    
    int xPos = (newsize.width - width)/2;
    int yPos = (newsize.height-height)/2;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(newsize);
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(xPos, yPos, width, height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

/** 根据颜色尺寸生成图片 */
+(UIImage *)imageWithUIColor:(UIColor *)color andCGSize:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

/** 根据健身类型拿图标 */
+(UIImage *)imageWithExerciseType:(ExerciseType)type {
    switch (type) {
        case ExerciseTypeSitUp: {
            return [UIImage imageNamed:@"SitUpIcon"];
            break;
        }
        case ExerciseTypePushUp: {
            return [UIImage imageNamed:@"PushUpIcon"];
            break;
        }
        case ExerciseTypeSquat: {
            return [UIImage imageNamed:@"SquatIcon"];
            break;
        }
        case ExerciseTypeWalk: {
            return [UIImage imageNamed:@"WalkIcon"];
            break;
        }
        default: {
            break;
        }
    }
}

@end
