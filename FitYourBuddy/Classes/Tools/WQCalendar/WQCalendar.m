//
//  WQCalendar.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/2/20.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "WQCalendar.h"

@interface WQCalendar ()
{
    float               tileWidth;
    int                 row;
}

@end

@implementation WQCalendar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        tileWidth = frame.size.width / 7;
        NSDate* date = [[NSDate date] firstDayOfTheMonth];
        row = (int)date.numberOfWeeksInMonth;
        NSInteger dayCount = date.weekday;
        dayCount = dayCount - (dayCount - 1) * 2;
        NSInteger lastday = [[date lastDayOfTheMonth] day] + 1;
        
        for (int i = 0; i < row; i++) {
            for (int j = 0; j < 7; j++) {
                WQCalendarTile* tile = [[WQCalendarTile alloc] initWithFrame:CGRectMake(j * tileWidth, i * tileWidth, tileWidth, tileWidth)];
                if (j == 0 || j == 6) [tile setTileColor:themeRedColor];
                else [tile setTileColor:themeBlueColor];
                
                if (dayCount > 0 && dayCount < lastday) [tile setTileDay:dayCount];
                dayCount++;
                
                [self addSubview:tile];
            }
        }
    }
    return self;
}

@end
