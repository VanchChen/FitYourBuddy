//
//  WQCircleProgressBar.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/2/25.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "WQCircleProgressBar.h"

@interface WQCircleProgressBar ()

// this contains list of paths to be animated through
@property(nonatomic, strong)NSMutableArray *paths;

// the shaper layers used for display
@property(nonatomic, strong)CAShapeLayer *indicateShapeLayer;
@property(nonatomic, strong)CAShapeLayer *coverLayer;

// this is the layer used for animation
@property(nonatomic, strong)CAShapeLayer *animatingLayer;

// the type of indicator
@property(nonatomic, assign)IndicatorType type;

// this applies to the covering stroke (default: 2)
@property(nonatomic, assign)CGFloat coverWidth;

// the last updatedPath
@property(nonatomic, strong)UIBezierPath *lastUpdatedPath;
@property(nonatomic, assign)CGFloat lastSourceAngle;

// this the animation duration (default: 0.5)
@property(nonatomic, assign)CGFloat animationDuration;

@end

@implementation WQCircleProgressBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _type = FilledIndicator;
        [self initAttributes];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame type:(IndicatorType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _type = type;
        [self initAttributes];
    }
    return self;
}

- (void)initAttributes
{
    // first set the radius percent attribute
    if(_type == ClosedIndicator)
    {
        self.radiusPercent = 0.5;
        _coverLayer = [CAShapeLayer layer];
        _animatingLayer = _coverLayer;
        
        // set the fill color
        _fillColor = [UIColor clearColor];
        _strokeColor = [UIColor whiteColor];
        _closedIndicatorBackgroundStrokeColor = [UIColor whiteColor];
        _coverWidth = 12.0;
        
        // add two circle border layer
        CALayer *largeCircleLayer = [CALayer layer];
        largeCircleLayer.frame = CGRectMake(4.5f, 4.5f, self.frame.size.width - 9.0f, self.frame.size.height - 9.0f);
        largeCircleLayer.borderColor = [UIColor whiteColor].CGColor;
        largeCircleLayer.borderWidth = 2.f;
        largeCircleLayer.cornerRadius = largeCircleLayer.bounds.size.width / 2;
        largeCircleLayer.masksToBounds = YES;
        [self.layer addSublayer:largeCircleLayer];
        
        CALayer *smallCircleLayer = [CALayer layer];
        smallCircleLayer.frame = CGRectMake(17.5f, 17.5f, self.frame.size.width - 35, self.frame.size.height - 35);
        smallCircleLayer.borderColor = [UIColor whiteColor].CGColor;
        smallCircleLayer.borderWidth = 2.f;
        smallCircleLayer.cornerRadius = smallCircleLayer.bounds.size.width / 2;
        smallCircleLayer.masksToBounds = YES;
        [self.layer addSublayer:smallCircleLayer];
    }
    else
    {
        if(_type == FilledIndicator)
        {
            // only indicateShapeLayer
            _indicateShapeLayer = [CAShapeLayer layer];
            _animatingLayer = _indicateShapeLayer;
            self.radiusPercent = 0.5;
            _coverWidth = 2.0;
        }
        else
        {
            // indicateShapeLayer and coverLayer
            _indicateShapeLayer = [CAShapeLayer layer];
            _coverLayer = [CAShapeLayer layer];
            _animatingLayer = _indicateShapeLayer;
            _coverWidth = 2.0;
            self.radiusPercent = 0.4;
        }
        
        // set the fill color
        _fillColor = [UIColor whiteColor];
        _strokeColor = [UIColor whiteColor];
        _closedIndicatorBackgroundStrokeColor = [UIColor clearColor];
    }
    
    _animatingLayer.frame = self.bounds;
    [self.layer addSublayer:_animatingLayer];
    
    // path array
    _paths = [NSMutableArray array];
    
    // animation duration
    _animationDuration = 0.5;
}

- (void)loadIndicator
{
    // set the initial Path
    CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    UIBezierPath *initialPath = [UIBezierPath bezierPath]; //empty path
    
    if(_type == ClosedIndicator)
    {
        [initialPath addArcWithCenter:center radius:(MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))) startAngle:degreeToRadian(-90) endAngle:degreeToRadian(-90) clockwise:YES]; //add the arc
    }
    else
    {
        if(_type == MixedIndictor)
        {
            [self setNeedsDisplay];
        }
        CGFloat radius = (MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))/2) * self.radiusPercent;
        [initialPath addArcWithCenter:center radius:radius startAngle:degreeToRadian(-90) endAngle:degreeToRadian(-90) clockwise:YES]; //add the arc
    }
    
    _animatingLayer.path = initialPath.CGPath;
    _animatingLayer.strokeColor = _strokeColor.CGColor;
    _animatingLayer.fillColor = _fillColor.CGColor;
    _animatingLayer.lineWidth = _coverWidth;
    self.lastSourceAngle = degreeToRadian(-90);
}

#pragma mark Helper Methods
- (NSArray *)keyframePathsWithDuration:(CGFloat)duration lastUpdatedAngle:(CGFloat)lastUpdatedAngle newAngle:(CGFloat)newAngle radius:(CGFloat)radius type:(IndicatorType)type
{
    NSUInteger frameCount = ceil(duration * 60);
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:frameCount + 1];
    for (int frame = 0; frame <= frameCount; frame++)
    {
        CGFloat startAngle = degreeToRadian(-90);
        CGFloat endAngle = lastUpdatedAngle + (((newAngle - lastUpdatedAngle) * frame) / frameCount);
        
        [array addObject:(id)([self pathWithStartAngle:startAngle endAngle:endAngle radius:radius type:type].CGPath)];
    }
    
    return [NSArray arrayWithArray:array];
}

- (UIBezierPath *)pathWithStartAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle radius:(CGFloat)radius type:(IndicatorType)type
{
    BOOL clockwise = startAngle < endAngle;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    
    if(type == ClosedIndicator)
    {
        [path addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:clockwise];
    }
    else
    {
        [path moveToPoint:center];
        [path addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:clockwise];
        [path closePath];
    }
    return path;
}

- (void)drawRect:(CGRect)rect
{
    if(_type == MixedIndictor)
    {
        CGFloat radius = MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))/2 - self.coverWidth;
        
        CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
        UIBezierPath *coverPath = [UIBezierPath bezierPath]; //empty path
        [coverPath setLineWidth:_coverWidth];
        [coverPath addArcWithCenter:center radius:radius startAngle:0 endAngle:2*M_PI clockwise:YES]; //add the arc
        
        [_strokeColor set];
        [coverPath stroke];
    }
    else if (_type == ClosedIndicator)
    {
        CGFloat radius = (MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))/2) - self.coverWidth;
        
        CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
        UIBezierPath *coverPath = [UIBezierPath bezierPath]; //empty path
        [coverPath setLineWidth:_coverWidth];
        [coverPath addArcWithCenter:center radius:radius startAngle:0 endAngle:2*M_PI clockwise:YES]; //add the arc
        [_closedIndicatorBackgroundStrokeColor set];
        [coverPath setLineWidth:self.coverWidth];
        [coverPath stroke];
    }
}

#pragma mark - update indicator
- (void)updateWithTotalBytes:(CGFloat)bytes downloadedBytes:(CGFloat)downloadedBytes
{
    _lastUpdatedPath = [UIBezierPath bezierPathWithCGPath:_animatingLayer.path];
    
    [_paths removeAllObjects];
    
    CGFloat destinationAngle = [self destinationAngleForRatio:(downloadedBytes/bytes)];
    CGFloat radius = (MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) * _radiusPercent) - self.coverWidth;
    [_paths addObjectsFromArray:[self keyframePathsWithDuration:self.animationDuration lastUpdatedAngle:self.lastSourceAngle newAngle:destinationAngle  radius:radius type:_type]];
    
    _animatingLayer.path = (__bridge CGPathRef)((id)_paths[(_paths.count -1)]);
    self.lastSourceAngle = destinationAngle;
    
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    [pathAnimation setValues:_paths];
    [pathAnimation setDuration:self.animationDuration];
    [pathAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [pathAnimation setRemovedOnCompletion:YES];
    [_animatingLayer addAnimation:pathAnimation forKey:@"path"];
}

- (CGFloat)destinationAngleForRatio:(CGFloat)ratio
{
    return (degreeToRadian((360*ratio) - 90));
}

float degreeToRadian(float degree)
{
    return ((degree * M_PI)/180.0f);
}

#pragma mark Setter Methods
- (void)setFillColor:(UIColor *)fillColor
{
    if(_type == ClosedIndicator)
        _fillColor = [UIColor clearColor];
    else
        _fillColor = fillColor;
}

- (void)setRadiusPercent:(CGFloat)radiusPercent
{
    if(_type == ClosedIndicator)
    {
        _radiusPercent = 0.5;
        return;
    }
    
    if(radiusPercent > 0.5 || radiusPercent < 0)
        return;
    else
        _radiusPercent = radiusPercent;
    
}

- (void)setIndicatorAnimationDuration:(CGFloat)duration
{
    self.animationDuration = duration;
}

@end