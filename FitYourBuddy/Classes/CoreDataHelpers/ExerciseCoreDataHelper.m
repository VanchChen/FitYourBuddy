//
//  ExerciseCoreDataHelper.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/3/8.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "ExerciseCoreDataHelper.h"
#import "AppDelegate.h"
#import "Exercise.h"

@implementation ExerciseCoreDataHelper

/**根据类型得到锻炼天数（已废，现用数据库记录）*/
+ (NSInteger)getHistoryDayByType:(ExerciseType)type withError:(NSError **)error {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Exercise" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type = %d", type];
    [fetchRequest setPredicate:predicate];
    
    //排序
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSArray *objects = [context executeFetchRequest:fetchRequest error:error];
    NSString *lastDate = @"", *tmpDate;
    NSInteger count = 0;
    for (Exercise *exercise in objects) {
        tmpDate = [exercise.date formatDate];
        if (![tmpDate isEqualToString:lastDate]) { //日期不同则计数
            lastDate = tmpDate;
            count ++;
        }
    }
    
    return count;
}

//根据类型得到当天锻炼次数
+ (NSInteger)getTodayNumByType:(ExerciseType)type withError:(NSError **)error
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    return [self getNumByType:type andDate:[formatter stringFromDate:[NSDate date]] withError:error];
}

//根据类型得到锻炼次数
+ (NSInteger)getNumByType:(ExerciseType)type andDate:(NSString *)date withError:(NSError **)error
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Exercise" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type = %d and date CONTAINS[cd] %@", type, date];
    [fetchRequest setPredicate:predicate];
    
    NSArray *objects = [context executeFetchRequest:fetchRequest error:error];
    
    if (objects == nil || [objects count] == 0) {
        return 0;
    } else {
        NSInteger count = 0;
        
        for (NSManagedObject *obj in objects)
        {
            count += [[obj valueForKey:@"num"] integerValue];
        }
        
        return count;
    }
}

//根据类型得到单次最好成绩
+ (NSInteger)getBestNumByType:(ExerciseType)type withError:(NSError **)error
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Exercise" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    //过滤条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type = %d", type];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"num" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSArray *objects = [context executeFetchRequest:fetchRequest error:error];
    //先全部取出来后，再排序
    NSArray *array = [objects sortedArrayUsingComparator:^NSComparisonResult(Exercise *obj1, Exercise *obj2) {
        NSInteger num1 = [obj1.num integerValue];
        NSInteger num2 = [obj2.num integerValue];
        if (num1 > num2) {//倒序
            return NSOrderedAscending;
        }
        if (num1 == num2) {
            return NSOrderedSame;
        }
        return NSOrderedDescending;
    }];
    
    if (array == nil || [array count] == 0) {
        return 0;
    } else {
        return [[[array firstObject] valueForKey:@"num"] integerValue];
    }
}

//根据类型得到总记录
+ (NSInteger)getTotalNumByType:(ExerciseType)type withError:(NSError **)error {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Exercise" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    //过滤条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type = %d", type];
    [fetchRequest setPredicate:predicate];
    
    NSArray *objects = [context executeFetchRequest:fetchRequest error:error];
    
    if (objects == nil || [objects count] == 0) {
        return 0;
    } else {
        NSInteger count = 0;
        
        for (NSManagedObject *obj in objects)
        {
            count += [[obj valueForKey:@"num"] integerValue];
        }
        
        return count;
    }
}

//根据类型得到一周的数据
+ (NSDictionary *)getOneWeekNumByType:(ExerciseType)type withError:(NSError **)error {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Exercise" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *today = [[NSDate date] endOfDay];
    NSDate *dayFromLastWeek = today.associateDayOfThePreviousWeek.beginingOfDay;
    
    //过滤
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type = %d and date > %@ and date < %@", type, [formatter stringFromDate:dayFromLastWeek], [formatter stringFromDate:today]];
    [fetchRequest setPredicate:predicate];
    //按照日期正序排序
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSArray *objects = [context executeFetchRequest:fetchRequest error:error];
    
    if (objects == nil || [objects count] == 0) {
        return nil;
    } else {
        NSInteger count = 0;
        NSString *lastDate = @"", *tmpDate;
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithCapacity:7];
        
        for (NSManagedObject *obj in objects)
        {
            tmpDate = [[obj valueForKey:@"date"] formatDay];
            if ([tmpDate isEqualToString:lastDate] || lastDate.length == 0) {
                lastDate = tmpDate;
                count += [[obj valueForKey:@"num"] integerValue];
            } else {
                [dictionary setObject:[NSString getFromInteger:count] forKey:lastDate];
                
                lastDate = tmpDate;
                count = [[obj valueForKey:@"num"] integerValue];
            }
        }
        [dictionary setObject:[NSString getFromInteger:count] forKey:lastDate];
        
        if (dictionary.count > 0) {
            return dictionary;
        }
        
        return nil;;
    }
}

//根据类型存数据
+ (BOOL)addExerciseByType:(ExerciseType)type andNum:(NSInteger)num withError:(NSError **)error
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSManagedObject *theLine = [NSEntityDescription insertNewObjectForEntityForName:@"Exercise" inManagedObjectContext:context];
    
    [theLine setValue:[formatter stringFromDate:[NSDate date]] forKey:@"date"];
    [theLine setValue:[NSString getFromInteger:num] forKey:@"num"];
    [theLine setValue:[NSString getFromInteger:type] forKey:@"type"];
    
    if (![context save:error]) {
        return false;
    }
    
    return true;
}

@end
