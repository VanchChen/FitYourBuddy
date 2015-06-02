//
//  WQCalendar.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/2/20.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "WQCalendar.h"

static NSInteger const titleTag = 100;              //单元格起始tag

@interface WQCalendar ()

@property (nonatomic, assign)   float                   tileWidth;  //单元格宽度
@property (nonatomic, assign)   NSInteger               row;        //行数

@end

@implementation WQCalendar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _tileWidth = frame.size.width / 7;
        NSDate* date = [[NSDate date] firstDayOfTheMonth];
        _row = (int)date.numberOfWeeksInMonth;
        NSInteger dayCount = date.weekday;
        dayCount = dayCount - (dayCount - 1) * 2;
        NSInteger lastday = [[date lastDayOfTheMonth] day] + 1;
        
        for (int i = 0; i < _row; i++) {
            for (int j = 0; j < 7; j++) {
                WQCalendarTile* tile = [[WQCalendarTile alloc] initWithFrame:CGRectMake(j * _tileWidth, i * _tileWidth, _tileWidth, _tileWidth)];
                if (j == 0 || j == 6) [tile setTileColor:themeRedColor];
                else [tile setTileColor:themeBlueColor];
                
                [tile setTag:(titleTag + dayCount)];
                
                if (dayCount > 0 && dayCount < lastday) [tile setTileDay:dayCount];
                dayCount++;
                
                [self addSubview:tile];
            }
        }
        
        [self reloadData];
    }
    return self;
}

- (void)reloadData {
    NSError *error;
    NSArray *dayArray = [ExerciseCoreDataHelper getMonthExerciseDayByDate:[NSDate date] withError:&error];
    NSInteger tmpDay;
    WQCalendarTile *tile;
    for (id obj in dayArray) {
        tmpDay = [obj integerValue];
        tile = (WQCalendarTile *)[self viewWithTag:(titleTag + tmpDay)];
        [tile setHasCircle:YES];
    }
}

@end
