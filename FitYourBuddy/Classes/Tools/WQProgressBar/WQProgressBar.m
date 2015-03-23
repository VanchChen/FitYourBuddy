//
//  WQProgressBar.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/2/20.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "WQProgressBar.h"

@implementation WQProgressBar

- (id)initWithFrame:(CGRect)frame andRat:(float)rat withAnimation:(BOOL)animation
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 2;
        
        if (animation) {
            progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, frame.size.height)];
            [progressView setBackgroundColor:themeRedColor];
            [self addSubview:progressView];
            
            [UIView animateWithDuration:1 animations:^{
                [progressView setFrame:CGRectMake(0, 0, frame.size.width * rat, frame.size.height)];
            }];
        } else {
            progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width * rat, frame.size.height)];
            [progressView setBackgroundColor:themeRedColor];
            [self addSubview:progressView];
        }
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame fromStartRat:(float)startRat toEndRat:(float)endRat
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 2;
        
        progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width * startRat, frame.size.height)];
        [progressView setBackgroundColor:themeRedColor];
        [self addSubview:progressView];
        
        [UIView animateWithDuration:1 animations:^{
            [progressView setFrame:CGRectMake(0, 0, frame.size.width * endRat, frame.size.height)];
        }];
    }
    return self;
}

@end
