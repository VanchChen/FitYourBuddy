//
//  ExerciseCoreDataHelper.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/3/8.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "ExerciseCoreDataHelper.h"
#import "AppDelegate.h"

@implementation ExerciseCoreDataHelper

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
    
    //排序和取一个
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"num" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setFetchLimit:1];
    
    NSArray *objects = [context executeFetchRequest:fetchRequest error:error];
    
    if (objects == nil || [objects count] == 0) {
        return 0;
    } else {
        return [[[objects firstObject] valueForKey:@"num"] integerValue];
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
    [theLine setValue:[NSString stringWithFormat:@"%d", num] forKey:@"num"];
    [theLine setValue:[NSString stringWithFormat:@"%d", type] forKey:@"type"];
    
    if (![context save:error]) {
        return false;
    }
    
    return true;
}

@end
