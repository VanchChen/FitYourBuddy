//
//  WQProgressBar.h
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/2/20.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQProgressBar : UIView
{
    UIView* progressView;
}

- (id)initWithFrame:(CGRect)frame andRat:(float)rat withAnimation:(BOOL)animation;

- (id)initWithFrame:(CGRect)frame fromStartRat:(float)startRat toEndRat:(float)endRat;

@end
