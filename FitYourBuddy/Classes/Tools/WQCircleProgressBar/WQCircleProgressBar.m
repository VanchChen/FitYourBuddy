//
//  WQCircleProgressBar.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/2/25.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "WQCircleProgressBar.h"
#import "SoundTool.h"

@interface WQCircleProgressBar ()

// this contains list of paths to be animated through
@property (nonatomic, strong) NSMutableArray    *paths;

// the shaper layers used for display
@property (nonatomic, strong) CALayer           *largeCircleLayer;

// this is the layer used for animation
@property (nonatomic, strong) CAShapeLayer      *animatingLayer;

// this applies to the covering stroke (default: 2)
@property (nonatomic, assign) CGFloat           coverWidth;

// the last updatedPath
@property (nonatomic, strong) UIBezierPath      *lastUpdatedPath;
@property (nonatomic, assign) CGFloat           lastSourceAngle;

// this the animation duration (default: 0.5)
@property (nonatomic, assign) CGFloat           animationDuration;

// 预设的数值
@property (nonatomic, assign) CGFloat           radiusPercent;
@property (nonatomic, strong) UIColor           *fillColor;

// 动画准备
@property (nonatomic, assign) BOOL              isReady;
@property (nonatomic, strong) NSTimer           *timer;

// 标签框
@property (nonatomic, strong) UILabel           *readyLabel;
@property (nonatomic, strong) UILabel           *tintLabel;
@property (nonatomic, strong) UILabel           *countLabel;

@end

@implementation WQCircleProgressBar

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initAttributes];
    }
    return self;
}

- (void)initAttributes {
    self.backgroundColor = [UIColor clearColor];
    _isReady = NO;
    _allowSoundPlay = YES;
    
    self.radiusPercent = 0.5;
    _animatingLayer = [CAShapeLayer layer];
    
    // set the fill color
    _fillColor = [UIColor clearColor];
    _strokeColor = [UIColor whiteColor];
    _closedIndicatorBackgroundStrokeColor = [UIColor whiteColor];
    _coverWidth = 12.0;
    
    // add two circle border layer
    _largeCircleLayer = [CALayer layer];
    _largeCircleLayer.frame = CGRectMake(4.5f, 4.5f, self.frame.size.width - 9.0f, self.frame.size.height - 9.0f);
    _largeCircleLayer.backgroundColor = [UIColor whiteColor].CGColor;
    _largeCircleLayer.cornerRadius = _largeCircleLayer.bounds.size.width / 2;
    _largeCircleLayer.shadowColor = circleGreyColor.CGColor;
    _largeCircleLayer.shadowOffset = CGSizeMake(0, 4);
    _largeCircleLayer.shadowOpacity = 1;
    _largeCircleLayer.shadowRadius = 0;
    [self.layer addSublayer:_largeCircleLayer];
    
    _animatingLayer.frame = self.bounds;
    [self.layer addSublayer:_animatingLayer];
    
    // path array
    _paths = [NSMutableArray array];
    
    // animation duration
    _animationDuration = 0.5;
}

- (void)loadIndicator {
    // set the initial Path
    CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    CGFloat radius = (MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) * _radiusPercent) - self.coverWidth;
    UIBezierPath *initialPath = [UIBezierPath bezierPath]; //empty path
    [initialPath addArcWithCenter:center radius:radius startAngle:degreeToRadian(-90) endAngle:degreeToRadian(270) clockwise:YES]; //add the arc
    
    _animatingLayer.path = initialPath.CGPath;
    _animatingLayer.strokeColor = _strokeColor.CGColor;
    _animatingLayer.fillColor = _fillColor.CGColor;
    _animatingLayer.lineWidth = _coverWidth;
    self.lastSourceAngle = degreeToRadian(270);
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(fireReadyTimer) userInfo:nil repeats:YES];
    _readyLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _readyLabel.text = @"准备";
    _readyLabel.textColor = [UIColor blackColor];
    _readyLabel.textAlignment = NSTextAlignmentCenter;
    _readyLabel.font = [UIFont boldSystemFontOfSize:60];
    _readyLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_readyLabel];
    
    if (_allowSoundPlay) {
        [SoundTool playSoundWithReadyNum:4];
    }
}

- (void)changeFrame:(CGRect)frame {
    self.frame = frame;
    _largeCircleLayer.frame = CGRectMake(4.5f, 4.5f, self.frame.size.width - 9.0f, self.frame.size.height - 9.0f);
    _largeCircleLayer.cornerRadius = _largeCircleLayer.bounds.size.width / 2;
    _animatingLayer.frame = self.bounds;
    _readyLabel.frame = self.bounds;
    // set the initial Path
    CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    CGFloat radius = (MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) * _radiusPercent) - self.coverWidth;
    UIBezierPath *initialPath = [UIBezierPath bezierPath]; //empty path
    [initialPath addArcWithCenter:center radius:radius startAngle:degreeToRadian(-90) endAngle:degreeToRadian(270) clockwise:YES]; //add the arc
    _animatingLayer.path = initialPath.CGPath;
    [self setNeedsDisplay];
}

#pragma mark Helper Methods
- (NSArray *)keyframePathsWithDuration:(CGFloat)duration lastUpdatedAngle:(CGFloat)lastUpdatedAngle newAngle:(CGFloat)newAngle radius:(CGFloat)radius {
    NSUInteger frameCount = ceil(duration * 60);
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:frameCount + 1];
    for (int frame = 0; frame <= frameCount; frame++)
    {
        CGFloat startAngle = degreeToRadian(-90);
        CGFloat endAngle = lastUpdatedAngle + (((newAngle - lastUpdatedAngle) * frame) / frameCount);
        
        [array addObject:(id)([self pathWithStartAngle:startAngle endAngle:endAngle radius:radius].CGPath)];
    }
    
    return [NSArray arrayWithArray:array];
}

- (UIBezierPath *)pathWithStartAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle radius:(CGFloat)radius {
    BOOL clockwise = startAngle < endAngle;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    
    [path addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:clockwise];
    return path;
}

- (void)fireReadyTimer {
    CGFloat angle = roundf(radianToDegree(_lastSourceAngle));
    [self updateWithTotalBytes:360 downloadedBytes:angle];
    if (angle == 0) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)drawRect:(CGRect)rect {
    CGContextClearRect(UIGraphicsGetCurrentContext(), self.frame);
    
    CGFloat radius = (MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))/2) - self.coverWidth;
    
    CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    UIBezierPath *coverPath = [UIBezierPath bezierPath]; //empty path
    [coverPath setLineWidth:_coverWidth];
    [coverPath addArcWithCenter:center radius:radius startAngle:0 endAngle:2*M_PI clockwise:YES]; //add the arc
    [_closedIndicatorBackgroundStrokeColor set];
    [coverPath setLineWidth:self.coverWidth];
    [coverPath stroke];
}

#pragma mark - update indicator
- (void)updateWithTotalBytes:(CGFloat)bytes downloadedBytes:(CGFloat)downloadedBytes {
    _lastUpdatedPath = [UIBezierPath bezierPathWithCGPath:_animatingLayer.path];
    
    [_paths removeAllObjects];
    
    CGFloat destinationAngle = [self destinationAngleForRatio:(downloadedBytes/bytes)];
    CGFloat radius = (MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) * _radiusPercent) - self.coverWidth;
    [_paths addObjectsFromArray:[self keyframePathsWithDuration:self.animationDuration lastUpdatedAngle:self.lastSourceAngle newAngle:destinationAngle  radius:radius]];
    
    _animatingLayer.path = (__bridge CGPathRef)((id)_paths[(_paths.count -1)]);
    self.lastSourceAngle = destinationAngle;
    self.countLabel.text = [NSString stringWithFormat:@"%d", (int)downloadedBytes];
    
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    [pathAnimation setDelegate:self];
    [pathAnimation setValues:_paths];
    [pathAnimation setDuration:self.animationDuration];
    [pathAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [pathAnimation setRemovedOnCompletion:YES];
    [_animatingLayer addAnimation:pathAnimation forKey:@"path"];
}

- (CGFloat)destinationAngleForRatio:(CGFloat)ratio {
    return (degreeToRadian((360*ratio) - 90));
}

float degreeToRadian(float degree) {
    return ((degree * M_PI)/180.0f);
}

float radianToDegree(float radian) {
    return ((radian * 180.0f)/M_PI);
}

#pragma mark Setter Methods
- (void)setIndicatorAnimationDuration:(CGFloat)duration {
    self.animationDuration = duration;
}

#pragma mark Animation Delegate
- (void)animationDidStart:(CAAnimation *)anim {
    if (_isReady && _allowSoundPlay) {
        [SoundTool playSoundWithExerciseNum:_countLabel.text.integerValue];
    }
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    CGFloat angle = roundf(radianToDegree(self.lastSourceAngle));
    if (!_isReady) {
        if (angle == -90) {
            _isReady = YES;
        }
        NSInteger num = (angle / 90) + 1;
        if (num > 0) {
            _readyLabel.text = [NSString stringWithFormat:@"%ld", (long)num];
            if (_allowSoundPlay) {
                [SoundTool playSoundWithReadyNum:num];
            }
        } else {
            [_readyLabel removeFromSuperview];
            _readyLabel = nil;
            
            _tintLabel = [[UILabel alloc] init];
            _tintLabel.frame = CGRectMake(0, 0, self.width, self.height / 2.0f);
            _tintLabel.text = @"已完成";
            _tintLabel.textColor = [UIColor blackColor];
            _tintLabel.textAlignment = NSTextAlignmentCenter;
            _tintLabel.font = [UIFont boldSystemFontOfSize:20];
            _tintLabel.adjustsFontSizeToFitWidth = YES;
            [self addSubview:_tintLabel];
            
            _countLabel = [[UILabel alloc] init];
            _countLabel.frame = self.bounds;
            _countLabel.text = @"0";
            _countLabel.textColor = [UIColor blackColor];
            _countLabel.textAlignment = NSTextAlignmentCenter;
            _countLabel.font = [UIFont boldSystemFontOfSize:60];
            _countLabel.adjustsFontSizeToFitWidth = YES;
            [self addSubview:_countLabel];
            
            if (self.progressDidReadyBlock) {
                self.progressDidReadyBlock(self);
            }
        }
    }
}

@end