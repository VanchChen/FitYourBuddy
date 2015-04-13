//
//  Store.h
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/4/9.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Store : NSManagedObject

@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * index;
@property (nonatomic, retain) NSString * hasBought;
@property (nonatomic, retain) NSString * cost;

@end
