//
//  AccountCoreDataHelper.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/3/8.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "AccountCoreDataHelper.h"
#import "AppDelegate.h"

@implementation AccountCoreDataHelper

static AccountCoreDataHelper *sharedAccountCoreDataHelper = nil;
+ (AccountCoreDataHelper *)sharedAccountCoreDataHelper {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedAccountCoreDataHelper = [[self alloc] init];
        
    });
    return sharedAccountCoreDataHelper;                   
}

+ (BOOL)initAccountWithName:(NSString *)name andGender:(NSString *)gender andError:(NSError **)error
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Account" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSArray *objects = [context executeFetchRequest:fetchRequest error:error];
    
    if (objects == nil || [objects count] == 0) {
        NSManagedObject *theLine = nil;
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           name,@"name",
                                           @"1",@"level",
                                           @"0",@"exp",
                                           @"0",@"count",
                                           @"",@"date",
                                           gender,@"gender",
                                           @"1",@"sitUpLevel",
                                           @"1",@"pushUpLevel",
                                           @"1",@"squatLevel",
                                           @"1",@"walkLevel",
                                           @"100",@"coin",
                                           @"0",@"hair",
                                           @"0",@"eye",
                                           @"0",@"mouth",
                                           @"0",@"clothes",
                                           @"",@"lastLaunchDate",
                                           nil];
        for (NSString *key in dictionary)
        {
            theLine = [NSEntityDescription insertNewObjectForEntityForName:@"Account" inManagedObjectContext:context];
            
            [theLine setValue:key forKey:@"name"];
            [theLine setValue:dictionary[key] forKey:@"data"];
            
            if (![context save:error]) {
                return false;
            }
        }
        
        return true;
    }
    
    return false;
}

+ (NSString *)getDataByName:(NSString *)name withError:(NSError **)error
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Account" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@",  name];
    [fetchRequest setPredicate:predicate];
    
    NSArray *objects = [context executeFetchRequest:fetchRequest error:error];
    
    if (objects == nil || [objects count] == 0) {
        return nil;
    } else {
        NSManagedObject *theLine = [objects firstObject];
        return [theLine valueForKey:@"data"];
    }
}

//根据字段保存某一条数据
+ (BOOL)setDataByName:(NSString *)name andData:(NSString *)data withError:(NSError **)error
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Account" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@",  name];
    [fetchRequest setPredicate:predicate];
    
    NSArray *objects = [context executeFetchRequest:fetchRequest error:error];
    
    if (objects == nil || [objects count] == 0) {
        return false;
    } else {
        NSManagedObject *theLine = [objects firstObject];
        
        [theLine setValue:data forKey:@"data"];
        
        if (![context save:error]) {
            return false;
        }
        
        return true;
    }
}

+ (NSDictionary *)getAccountDictionaryWithError:(NSError **)error
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Account" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSArray *objects = [context executeFetchRequest:fetchRequest error:error];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    for (NSManagedObject *obj in objects)
    {
        [dict setValue:[obj valueForKey:@"data"] forKey:[obj valueForKey:@"name"]];
    }
    
    return dict;
}

@end
