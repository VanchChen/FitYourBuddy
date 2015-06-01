//
//  WQAnimateLabel.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/6/1.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "WQAnimateLabel.h"

@interface WQAnimateLabel ()

@property (nonatomic, strong) UILabel   *textLabel;
@property (nonatomic, strong) UILabel   *changeLabel;
@property (nonatomic, strong) NSTimer   *timer;
@property (nonatomic, assign) CGFloat   animationDuration;
@property (nonatomic, assign) CGFloat   labelUpdateRate;
@property (nonatomic, assign) NSInteger labelUpdateNum;

@end

@implementation WQAnimateLabel

#pragma mark - Life Circle
- (instancetype)init {
    self = [super init];
    if (self) {
        [self customInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self customInit];
        
        _textLabel.frame = self.bounds;
        _changeLabel.frame = self.bounds;
    }
    return self;
}

- (void)dealloc {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)customInit {
    _animationDuration = 1.0f;
    _labelUpdateRate = 0.1f;
    
    _textLabel = [[UILabel alloc] init];
    _changeLabel = [[UILabel alloc] init];
    _changeLabel.alpha = 0;
    
    [self addSubview:_textLabel];
    [self addSubview:_changeLabel];
}

#pragma mark - Outter Method
- (void)changeLabelFromNum1:(NSInteger)num1 toNum2:(NSInteger)num2 {
    _textLabel.text = [NSString stringWithFormat:@"%ld", (long)num1];
    NSInteger changeNum = num2 - num1;
    if (changeNum == 0) {
        return;
    }
    
    NSString *changeString = [NSString stringWithFormat:@"%ld", (long)changeNum];
    if (changeNum > 0) {
        changeString = [NSString stringWithFormat:@"+%@",changeString];
    }
    _changeLabel.text = changeString;
    
    // calculate Update Rate
    changeNum = labs(changeNum);
    //if (changeNum <= _animationDuration / _labelUpdateRate) {
        _labelUpdateRate = _animationDuration / changeNum;
        _labelUpdateNum = 1;
    //} else {
        
    //}
    
    // start Timer
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:_labelUpdateRate target:self selector:@selector(fireTextTimer:) userInfo: [NSNumber numberWithInteger:num2] repeats:YES];
    
    // start Change Label Animation
    _changeLabel.alpha = 1;
    _changeLabel.frame = self.bounds;
    [UIView animateWithDuration:_animationDuration animations:^{
        _changeLabel.frame = CGRectMake(0, -self.frame.size.height, self.frame.size.width, self.frame.size.height);
        _changeLabel.alpha = 0;
    }];
}

#pragma mark - Animation Method
- (void)fireTextTimer:(NSTimer *)timer {
    NSInteger goalNum = [(NSNumber *)timer.userInfo integerValue];
    NSInteger currentNum = _textLabel.text.integerValue;
    
    if (currentNum < goalNum) {
        currentNum += _labelUpdateNum;
    } else {
        currentNum -= _labelUpdateNum;
    }
    
    _textLabel.text = [NSString stringWithFormat:@"%ld", (long)currentNum];
    if (currentNum == goalNum) {
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark - Setting Method
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    _textLabel.frame = self.bounds;
    _changeLabel.frame = self.bounds;
}

- (void)setText:(NSString *)text {
    _textLabel.text = text;
}
- (void)setTextColor:(UIColor *)textColor {
    _textLabel.textColor = textColor;
    _changeLabel.textColor = textColor;
}
- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    _textLabel.textAlignment = textAlignment;
    _changeLabel.textAlignment = textAlignment;
}
- (void)setFont:(UIFont *)font {
    _textLabel.font = font;
    _changeLabel.font = font;
    [self layoutIfNeeded];
}

@end
