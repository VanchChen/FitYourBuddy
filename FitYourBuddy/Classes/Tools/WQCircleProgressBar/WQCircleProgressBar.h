//
//  WQCircleProgressBar.h
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/2/25.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum {
    ClosedIndicator=0,
    FilledIndicator,
    MixedIndictor,
}IndicatorType;

@interface WQCircleProgressBar : UIView

// this value should be 0 to 0.5 (default: (kRMFilledIndicator = 0.5), (kRMMixedIndictor = 0.4))
@property(nonatomic, assign)CGFloat radiusPercent;

// used to fill the downloaded percent slice (default: (kRMFilledIndicator = white), (kRMMixedIndictor = white))
@property(nonatomic, strong)UIColor *fillColor;

// used to stroke the covering slice (default: (kRMClosedIndicator = white), (kRMMixedIndictor = white))
@property(nonatomic, strong)UIColor *strokeColor;

// used to stroke the background path the covering slice (default: (kRMClosedIndicator = gray))
@property(nonatomic, strong)UIColor *closedIndicatorBackgroundStrokeColor;

// init with frame and type
// if() - (id)initWithFrame:(CGRect)frame is used the default type = kRMFilledIndicator
- (id)initWithFrame:(CGRect)frame type:(IndicatorType)type;

// prepare the download indicator
- (void)loadIndicator;

// update the downloadIndicator
- (void)setIndicatorAnimationDuration:(CGFloat)duration;

// update the downloadIndicator
- (void)updateWithTotalBytes:(CGFloat)bytes downloadedBytes:(CGFloat)downloadedBytes;

@end
