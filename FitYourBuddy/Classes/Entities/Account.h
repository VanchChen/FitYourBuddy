//
//  Account.h
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/4/4.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Account : NSManagedObject

@property (nonatomic, retain) NSString * data;
@property (nonatomic, retain) NSString * name;

@end
