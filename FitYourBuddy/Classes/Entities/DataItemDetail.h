//
//  DataItemDetail.h
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/7/4.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

/*
 *   1. 单条数据容器
 *   2. 支持序列化和反序列化
 *   3. 警告：请勿轻易改动序列化和反序列化的机制，否则会引发数据不兼容的后果。
 */
@interface DataItemDetail : NSObject <NSCoding,NSCopying>

@property (nonatomic, strong) NSMutableDictionary *dictData;     //数据

/**
 从NSDictionary初始化
 如果dictionary里面有子dict，则子dict会变成DataItemDetail
 其他类型都以原本的形式加入detail
 
 @param dict dict
 
 @return detail
 */
+ (DataItemDetail *)detailFromDictionary:(NSDictionary *)dict;

/** 往当前数据容器的后端追加另一个数据容器所有的数据 */
- (void)appendItems:(DataItemDetail *)detail;

/** 设定数组 */
- (BOOL)setArray:(NSArray *)array forKey:(NSString *)aKey;
/** 获取数组 */
- (NSArray *)getArray:(NSString *)key;

/** 设定字符串值 */
- (BOOL)setString:(NSString *)value forKey:(NSString *)key;
/** 获取字符串值 */
- (NSString *)getString:(NSString *)key;

/** 设定int值 */
- (BOOL)setInt:(NSInteger)value forKey:(NSString *)key;
/** 获取int值 */
- (int)getInt:(NSString *)key;

/** 设定float值 */
- (BOOL)setFloat:(float)value forKey:(NSString *)key;
/** 获取float值 */
- (float)getFloat:(NSString *)key;

/** 设定布尔值 */
- (BOOL)setBool:(BOOL)value forKey:(NSString *)key;
/** 获取布尔值 */
- (BOOL)getBool:(NSString *)key;

/** 设定流数据 */
- (BOOL)setBin:(NSData *)value forKey:(NSString *)key;
/** 获取流数据 */
- (NSData *)getBin:(NSString *)key;

/** 通用设定一个数据，一般为自定义类变量 */
- (BOOL)setObject:(NSObject *)object forKey:(NSString *)key;
/** 获取流自定义类变量 */
- (NSObject *)getObject:(NSString *)key;

/** 设定属性字符串值 */
- (BOOL)setATTString:(NSAttributedString *)value forKey:(NSString *)key;
/** 获取属性字符串值 */
- (NSAttributedString *)getATTString:(NSString *)key;

/** 键值对总数 */
- (NSUInteger)count;

/** 是否存在键值对 */
- (BOOL)hasKey:(NSString *)key;

/** 是否存在匹配的键值对 */
- (BOOL)hasKey:(NSString *)key withValue:(NSString *)value;

/** 清除所有元素 */
- (void)clear;

/** 调试接口，在console中打印出当前对象包含的元素 */
- (void)dump;

/** 当前对象序列化到NSData数据流中 */
- (NSData *)toData;

/** 从NSData数据流中反序列化出一个 DataItemDetail 对象 */
+ (id)FromData:(NSData*)data;

@end
