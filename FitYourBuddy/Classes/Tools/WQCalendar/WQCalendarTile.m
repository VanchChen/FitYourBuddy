//
//  WQCalendarTile.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/2/20.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "WQCalendarTile.h"

@interface WQCalendarTile ()

@property (nonatomic, strong)   UIColor*                 tileColor;
@property (nonatomic, assign)   NSUInteger               tileDay;

@end

@implementation WQCalendarTile

- (void)setTileColor:(UIColor *)tileColor
{
    UIView* tileView = [[UIView alloc] initWithFrame:CGRectMake(3, 3, self.frame.size.width - 6, self.frame.size.height - 6)];
    [tileView setBackgroundColor:tileColor];
    [self addSubview:tileView];
}

- (void)setTileDay:(NSUInteger)tileDay
{
    UILabel* tileLabel = [[UILabel alloc] initWithFrame:self.bounds];
    [tileLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)tileDay]];
    [tileLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [tileLabel setTextAlignment:NSTextAlignmentCenter];
    [tileLabel setTextColor:[UIColor whiteColor]];
    [self addSubview:tileLabel];
}

@end
