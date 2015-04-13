//
//  WQCalendarTile.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/2/20.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "WQCalendarTile.h"

static CGFloat const tilePadding = 5.0f;            //边距

@interface WQCalendarTile ()

@property (nonatomic, strong)   UIColor                 *tileColor;
@property (nonatomic, assign)   NSUInteger              tileDay;
@property (nonatomic, strong)   UIImageView             *circleView;

@end

@implementation WQCalendarTile

- (void)setTileColor:(UIColor *)tileColor {
    UIView* tileView = [[UIView alloc] initWithFrame:CGRectMake(3, 3, self.frame.size.width - 6, self.frame.size.height - 6)];
    [tileView setBackgroundColor:tileColor];
    [self addSubview:tileView];
}

- (void)setTileDay:(NSUInteger)tileDay {
    UILabel* tileLabel = [[UILabel alloc] initWithFrame:self.bounds];
    [tileLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)tileDay]];
    [tileLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [tileLabel setTextAlignment:NSTextAlignmentCenter];
    [tileLabel setTextColor:[UIColor whiteColor]];
    [self addSubview:tileLabel];
}

- (void)setHasCircle:(BOOL)hasCircle {
    if (hasCircle) {
        if (_circleView) {
            return;
        } else {
            _circleView = [[UIImageView alloc] initWithFrame:CGRectMake(tilePadding, tilePadding, self.width - tilePadding * 2, self.height - tilePadding * 2)];
            _circleView.image = [UIImage imageNamed:@"CalendarCircleIcon"];
            [self addSubview:_circleView];
        }
    } else {
        if (_circleView) {
            [_circleView removeFromSuperview];
            _circleView = nil;
        } else {
            return;
        }
    }
}

@end
