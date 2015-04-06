//
//  Exercise.h
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/4/4.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Exercise : NSManagedObject

@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * num;
@property (nonatomic, retain) NSString * type;

@end
