//
//  StoreCoreDataHelper.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/4/9.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "StoreCoreDataHelper.h"
#import "AppDelegate.h"
#import "Store.h"

@implementation StoreCoreDataHelper

/**初始化商店数据库*/
+ (BOOL)initStoreDataBaseWithError:(NSError **)error {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Store" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSArray *objects = [context executeFetchRequest:fetchRequest error:error];
    
    if (objects == nil || [objects count] == 0) {
        Store *store;
        NSArray *storeArray = @[@{@"index":@"0", @"type":@"0", @"hasBought":@"1", @"cost":@"0"},
                                @{@"index":@"1", @"type":@"0", @"hasBought":@"0", @"cost":@"20"},
                                @{@"index":@"2", @"type":@"0", @"hasBought":@"0", @"cost":@"20"},
                                @{@"index":@"3", @"type":@"0", @"hasBought":@"0", @"cost":@"20"},
                                @{@"index":@"4", @"type":@"0", @"hasBought":@"0", @"cost":@"20"},
                                @{@"index":@"5", @"type":@"0", @"hasBought":@"0", @"cost":@"20"},
                                @{@"index":@"0", @"type":@"1", @"hasBought":@"1", @"cost":@"0"},
                                @{@"index":@"1", @"type":@"1", @"hasBought":@"0", @"cost":@"20"},
                                @{@"index":@"2", @"type":@"1", @"hasBought":@"0", @"cost":@"20"},
                                @{@"index":@"3", @"type":@"1", @"hasBought":@"0", @"cost":@"20"},
                                @{@"index":@"4", @"type":@"1", @"hasBought":@"0", @"cost":@"20"},
                                @{@"index":@"5", @"type":@"1", @"hasBought":@"0", @"cost":@"20"},
                                @{@"index":@"0", @"type":@"2", @"hasBought":@"1", @"cost":@"0"},
                                @{@"index":@"1", @"type":@"2", @"hasBought":@"0", @"cost":@"20"},
                                @{@"index":@"2", @"type":@"2", @"hasBought":@"0", @"cost":@"20"},
                                @{@"index":@"3", @"type":@"2", @"hasBought":@"0", @"cost":@"20"},
                                @{@"index":@"4", @"type":@"2", @"hasBought":@"0", @"cost":@"20"},
                                @{@"index":@"5", @"type":@"2", @"hasBought":@"0", @"cost":@"20"},
                                @{@"index":@"0", @"type":@"3", @"hasBought":@"1", @"cost":@"0"}];
        for (NSDictionary* dict in storeArray) {
            store = [NSEntityDescription insertNewObjectForEntityForName:@"Store" inManagedObjectContext:context];
            store.index = dict[@"index"];
            store.type = dict[@"type"];
            store.hasBought = dict[@"hasBought"];
            store.cost = dict[@"cost"];
            
            if (![context save:error]) {
                return false;
            }
        }
        
        return true;
    }
    
    return false;
}

/**根据类型得到所有数据*/
+ (NSArray *)getArrayByStoreType:(StoreType)type andError:(NSError **)error {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Store" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    //过滤
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type = %@",  [NSString stringFromInteger:type]];
    [fetchRequest setPredicate:predicate];
    //排序
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"index" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    NSArray *objects = [context executeFetchRequest:fetchRequest error:error];
    if (objects == nil || [objects count] == 0) {
        return nil;
    } else {
        return objects;
    }
}

/**返回金币数*/
+ (NSInteger)getCoinCountByStoreType:(StoreType)type andIndex:(NSInteger)index andError:(NSError **)error {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Store" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    //过滤
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type = %@ and index = %@",  [NSString stringFromInteger:type], [NSString stringFromInteger:index]];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setFetchLimit:1];
    
    NSArray *objects = [context executeFetchRequest:fetchRequest error:error];
    if (objects == nil || [objects count] == 0) {
        return 0;
    } else {
        return [[[objects firstObject] valueForKey:@"cost"] integerValue];
    }
}

/**购买配件*/
+ (BOOL)buyPartByStoreType:(StoreType)type andIndex:(NSInteger)index andError:(NSError **)error {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Store" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    //过滤
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type = %@ and index = %@",  [NSString stringFromInteger:type], [NSString stringFromInteger:index]];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setFetchLimit:1];
    
    NSArray *objects = [context executeFetchRequest:fetchRequest error:error];
    if (objects == nil || [objects count] == 0) {
        return false;
    } else {
        Store *theLine = [objects firstObject];
        
        theLine.hasBought = @"1";
        
        if (![context save:error]) {
            return false;
        }
        
        return true;
    }
}

@end
