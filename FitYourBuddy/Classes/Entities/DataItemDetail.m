//
//  DataItemDetail.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/7/4.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "DataItemDetail.h"

@implementation DataItemDetail

#pragma mark -
#pragma mark 生命周期
//初始化
- (id)init {
    self = [super init];
    
    if (nil != self) {
        self.dictData = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    DataItemDetail *itemCopy = [[DataItemDetail allocWithZone:zone]init];
    itemCopy.dictData = [self.dictData mutableCopy];
    return itemCopy;
}

+ (DataItemDetail *)detailFromDictionary:(NSDictionary *)dict {
    DataItemDetail *detail = [[DataItemDetail alloc] init];
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            DataItemDetail *subDetail = [DataItemDetail detailFromDictionary:obj];
            [detail setObject:subDetail forKey:key];
        }else if((NSNull *)obj != [NSNull null]){
            // 如果是NSNull，则不加入，以防崩溃
            [detail setObject:obj forKey:key];
        }
    }];
    return detail;
}

// 销毁时释放资源
- (void)dealloc {
#if !__has_feature(objc_arc)
    [self.dictData release];
    [super dealloc];
#endif
}

/** 往当前数据容器的后端追加另一个数据容器所有的数据 */
- (void)appendItems:(DataItemDetail *)detail {
    //数据不合法
    if (detail == nil) {
        return;
    }
    
    for (NSString *key in detail.dictData.allKeys) {
        self.dictData[key.lowercaseString] = detail.dictData[key.lowercaseString];
    }
}

#pragma mark -
#pragma mark 读取设置方法

- (BOOL)setArray:(NSArray *)array forKey:(NSString *)key {
    if (nil == self.dictData || key.length == 0) {
        return NO;
    }
    
    if (!array||[array isKindOfClass:[NSNull class]]) {
        array = [NSArray array];
    }
    
    self.dictData[key.lowercaseString] = array;
    
    return YES;
}

- (NSArray *)getArray:(NSString *)key {
    if (nil == self.dictData || key.length == 0) {
        return [NSArray array];
    }
    
    NSArray *array = self.dictData[key.lowercaseString];
    
    if (!array||[array isKindOfClass:[NSNull class]]) {
        return [NSArray array];
    }
    
    return array;
}

/** 设定属性字符串值 */
- (BOOL)setATTString:(NSAttributedString *)value forKey:(NSString *)key {
    if (nil == self.dictData || key.length == 0) {
        return NO;
    }
    
    //设置为空
    if (nil == value) {
        value = [[NSAttributedString alloc] initWithString:@""];
    }
    
    self.dictData[key.lowercaseString] = value;
    
    return YES;
}

/** 获取属性字符串值 */
- (NSAttributedString *)getATTString:(NSString *)key {
    if (nil == self.dictData || key.length == 0) {
        return [[NSAttributedString alloc] initWithString:@""];
    }
    
    NSAttributedString *value = self.dictData[key.lowercaseString];
    
    if (nil == value) {
        return [[NSAttributedString alloc] initWithString:@""];
    }
    
    return value;
}

/** 设定字符串值 */
- (BOOL)setString:(NSString *)value forKey:(NSString *)key {
    if (nil == self.dictData || key.length == 0) {
        return NO;
    }
    
    if (nil == value) {
        value = @"";
    }
    
    //转换成字符串存入
    if ([value isKindOfClass:[NSNumber class]]) {
        NSNumber *number = (NSNumber *)value;
        self.dictData[key.lowercaseString] = [NSString stringWithFormat:@"%@",number];
    } else if ([value isKindOfClass:[NSString class]]){
        self.dictData[key.lowercaseString] = value;
    } else {
        return NO;
    }
    return YES;
}

//获取字符串
- (NSString *)getString:(NSString *)key {
    if (nil == self.dictData || key.length == 0) {
        return @"";
    }
    
    NSString *value = self.dictData[key.lowercaseString];
    
    if (nil == value) {
        return @"";
    }
    
    if ([value isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%@", value];
    }
    
    if (![value isKindOfClass:[NSString class]]) {
        return @"";
    }
    
    return value;
}

/** 设定int值 */
- (BOOL)setInt:(NSInteger)value forKey:(NSString *)key {
    if (nil == self.dictData || key.length == 0) {
        return NO;
    }
    
    self.dictData[key.lowercaseString] = [NSNumber numberWithInteger:value];
    return YES;
}

/** 获取int值 */
- (int)getInt:(NSString *)key {
    if (nil == self.dictData || key.length == 0) {
        return 0;
    }
    
    NSString *value = self.dictData[key.lowercaseString];
    
    if (nil == value) {
        return 0;
    }
    
    return [value intValue];
}

/** 设定float值 */
- (BOOL)setFloat:(float)value forKey:(NSString *)key {
    if (nil == self.dictData || key.length == 0) {
        return NO;
    }
    
    self.dictData[key.lowercaseString] = [NSString stringWithFormat:@"%f", value];
    return YES;
}

/** 获取float值 */
- (float)getFloat:(NSString *)key {
    if (nil == self.dictData || key.length == 0) {
        return 0;
    }
    
    NSString *value = self.dictData[key.lowercaseString];
    
    if (nil == value) {
        return 0;
    }
    
    return [value floatValue];
}

/** 设定布尔值 */
- (BOOL)setBool:(BOOL)value forKey:(NSString *)key {
    if (nil == self.dictData || key.length == 0) {
        return NO;
    }
    
    self.dictData[key.lowercaseString] = [NSString stringWithFormat:@"%d", value ? 1:0];
    
    return YES;
}

/** 获取布尔值 */
- (BOOL)getBool:(NSString *)key {
    if (nil == self.dictData || key.length == 0) {
        return NO;
    }
    
    id value = self.dictData[key.lowercaseString];
    
    if ([value isKindOfClass:[NSString class]]) {
        if (nil == value) {
            return NO;
        }
        
        value = [value lowercaseString];
        
        if ([value isEqualToString:@"y"] || [value isEqualToString:@"on"] || [value isEqualToString:@"yes"] || [value isEqualToString:@"true"]) {
            return YES;
        }
        
        int intValue = [value intValue];
        
        if (intValue != 0) {
            return YES;
        }
    } else if ([value isKindOfClass:[NSNumber class]]) {
        int intValue = [value intValue];
        
        if (intValue != 0) {
            return YES;
        }
    }
    return NO;
}

/** 设定流数据 */
- (BOOL)setBin:(NSData *)value forKey:(NSString *)key {
    if (nil == self.dictData || key.length == 0) {
        return NO;
    }
    
    self.dictData[key.lowercaseString] = value;
    
    return YES;
}

/** 获取流数据 */
- (NSData *)getBin:(NSString *)key {
    if (nil == self.dictData || key.length == 0) {
        return 0;
    }
    
    id value = self.dictData[key.lowercaseString];
    
    if (![value isKindOfClass:[NSData class]]) {
        return [NSData data];
    }
    
    return (NSData *)value;
}

- (BOOL)setObject:(NSObject *)object forKey:(NSString *)key {
    if (object == nil || key == nil) {
        return NO;
    }
    self.dictData[key.lowercaseString] = object;
    return YES;
}

- (NSObject *)getObject:(NSString *)key {
    if (key.length == 0) {
        return nil;
    }
    return self.dictData[key.lowercaseString];
}

#pragma mark -
#pragma mark 其他方法
/** 键值对总数 */
- (NSUInteger)count {
    if (nil == self.dictData) {
        return 0;
    }
    
    return [self.dictData count];
}

/** 是否存在键值对 */
- (BOOL)hasKey:(NSString *)key {
    if (nil == self.dictData || nil == key) {
        return NO;
    }
    
    if (self.dictData[key.lowercaseString]) {
        return YES;
    }
    
    return NO;
}

/** 是否存在匹配的键值对 */
- (BOOL)hasKey:(NSString *)key withValue:(NSString *)value {
    if (nil == self.dictData || nil == key || nil == value) {
        return NO;
    }
    
    NSString *tmpValue = self.dictData[key.lowercaseString];
    
    if (nil == tmpValue) {
        return NO;
    }
    
    if (![tmpValue isEqualToString:value]) {
        return NO;
    }
    
    return YES;
}

/** 清除所有元素 */
- (void)clear {
    [self.dictData removeAllObjects];
}

/** 调试接口，在console中打印出当前对象包含的元素 */
- (void)dump {
    if (nil == self.dictData) {
        return;
    }
    
    NSArray *keys = [self.dictData allKeys];
    
    for (NSString *key in keys) {
        NSLog(@"Dump:  [%@] => %@", key, self.dictData[key.lowercaseString]);
    }
}

#pragma mark -
#pragma mark 序列 反序列
/** 当前对象序列化到NSData数据流中 */
- (NSData *)toData {
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [self encodeWithCoder:archiver];
    [archiver finishEncoding];
    
    return data;
}

/** 从NSData数据流中反序列化出一个 DataItemDetail 对象 */
+ (id)FromData:(NSData *)data {
    if (nil == data) {
        return nil;
    }
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    
    DataItemDetail *item = [[DataItemDetail alloc] initWithCoder:unarchiver];
    
    [unarchiver finishDecoding];
    
    return item;
}

/** 序列化函数 */
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.dictData];
}

/** 反序列化函数 */
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    if (nil != self) {
        self.dictData = [aDecoder decodeObject];
        
        if (nil == self.dictData) {
            self.dictData = [[NSMutableDictionary alloc] initWithCapacity:0];
        }
    }
    
    return self;
}

@end
