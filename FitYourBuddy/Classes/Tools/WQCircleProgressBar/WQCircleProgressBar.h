//
//  WQCircleProgressBar.h
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/2/25.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface WQCircleProgressBar : UIView

/** 笔触颜色 */
@property (nonatomic, strong) UIColor *strokeColor;
/** 进度条背景色 */
@property (nonatomic, strong) UIColor *closedIndicatorBackgroundStrokeColor;

/** 准备动画 */
- (void)loadIndicator;
/** 更新进度条 */
- (void)updateWithTotalBytes:(CGFloat)bytes downloadedBytes:(CGFloat)downloadedBytes;

/** 设置每次进度动画时间 */
- (void)setIndicatorAnimationDuration:(CGFloat)duration;

/** 是否允许播放音乐 */
@property (nonatomic, assign) BOOL      allowSoundPlay;

typedef void (^progressDidReady) (WQCircleProgressBar *progressBar);
/** 进度条倒计时，0为准备完毕 */
@property (nonatomic, copy)   progressDidReady progressDidReadyBlock;

@end