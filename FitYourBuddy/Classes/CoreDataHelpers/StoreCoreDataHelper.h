//
//  StoreCoreDataHelper.h
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/4/9.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

//帖子类型
typedef NS_ENUM(NSInteger, StoreType) {
    StoreTypeHair   = 0,
    StoreTypeEye    = 1,
    StoreTypeMouth  = 2,
    StoreTypeClothes= 3
};

@interface StoreCoreDataHelper : NSObject

/**初始化商店数据库*/
+ (BOOL)initStoreDataBaseWithError:(NSError **)error;

/**根据类型得到所有数据*/
+ (NSArray *)getArrayByStoreType:(StoreType)type andError:(NSError **)error;

/**返回金币数*/
+ (NSInteger)getCoinCountByStoreType:(StoreType)type andIndex:(NSInteger)index andError:(NSError **)error;

/**购买配件*/
+ (BOOL)buyPartByStoreType:(StoreType)type andIndex:(NSInteger)index andError:(NSError **)error;

@end
