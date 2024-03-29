//
//  DataItemResult.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/7/4.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "DataItemResult.h"
#import "DataItemDetail.h"

@implementation DataItemResult

#pragma mark -
#pragma mark 生命周期

/** 初始化变量 */
- (void)initVars {
    if (nil == _dataList) {
        _dataList = [[NSMutableArray alloc] initWithCapacity:0];
    }
}

/** 变量初始值合法性检查 */
- (void)checkVars {
    if(nil == _message){
        _message = @"";
    }
    
    if(nil == _itemUniqueKeyName){
        _itemUniqueKeyName = @"";
    }
    
    if(nil == _resultInfo){
        _resultInfo = [[DataItemDetail alloc] init];
    }
}

/** 初始化列表容器 */
- (id)init {
    self = [super init];
    
    if(nil != self){
        [self initVars];
        [self checkVars];
    }
    
    return self;
}

/** 销毁时释放资源 */
- (void)dealloc {
#if !__has_feature(objc_arc)
    [_message release];
    [_itemUniqueKeyName release];
    [_dataList release];
    [_resultInfo release];
    
    [super dealloc];
#endif
}

/** 获取一份和另一个result一模一样的拷贝 */
+ (DataItemResult *)resultFromAnother:(DataItemResult *)result {
    DataItemResult *tempResult = [[DataItemResult alloc] init];
    
    //确保数据有效性
    if (result) {
        //赋值属性
        tempResult.maxCount = result.maxCount;
        tempResult.statusCode = result.statusCode;
        tempResult.hasError = result.hasError;
        tempResult.message = result.message;
        tempResult.resultInfo = result.resultInfo;
        tempResult.dataList = result.dataList;
        tempResult.itemUniqueKeyName = result.itemUniqueKeyName;
        tempResult.rawData = result.rawData;
    }
    
    return tempResult;
}

#pragma mark -
#pragma mark 添加数据
/** 添加一个节点 */
- (void)addItem:(DataItemDetail *)item {
    if (nil == _dataList || nil == item) {
        return;
    }
    
    //判断数据是否有重复
    if(_itemUniqueKeyName && _itemUniqueKeyName.length > 0){
        NSString *checkValue = [item getString:_itemUniqueKeyName];
        
        for(DataItemDetail *tmpItem in _dataList){
            NSString *tempValue = [tmpItem getString:_itemUniqueKeyName];
            if (tempValue.length >0) {
                if([tempValue isEqualToString:checkValue]){
                    return;
                }
            }
        }
    }
    
    [_dataList addObject:item];
}

// 往当前列表容器的后端追加另一个列表容器所有的数据
- (void)appendItems:(DataItemResult *)result {
    //数据不合法
    assert(!(nil == result || result.hasError));
    if (nil == result || result.hasError) {
        return;
    }
    //最大
    self.maxCount = result.maxCount;
    self.statusCode = result.statusCode;
    self.message = result.message;
    self.itemUniqueKeyName = result.itemUniqueKeyName;
    
    //信息数据
    NSDictionary *itemInfo = result.resultInfo.dictData;
    for(NSString *key in [itemInfo allKeys]){
        NSString *value = (NSString *)itemInfo[key];
        [_resultInfo setString:value forKey:key];
    }
    
    //列表数据
    for(DataItemDetail *item in result.dataList) {
        [self addItem:item];
    }
    
    //这是很意外的情况，网络出错了，为了保险，这里这么做了
    //此处投资组合收益排行数据除第一页必然进入，因result中maxcount不提供，result.maxCount只是当前返回数据条数，执行上面self.maxCount = result.maxCount;必然导致此处进入 2015-1-20
    if (self.maxCount < [_dataList count]) {
        self.maxCount = [_dataList count];
    }
}

#pragma mark -
#pragma mark 常规处理
/** 获取当前节点数 */
- (NSUInteger)count {
    if (nil == _dataList) {
        return 0;
    }
    
    return [_dataList count];
}

/** 调试接口，在console中打印出当前对象包含的元素 */
- (void)dump {
    NSLog(@"Dump:==========  [basicInfo] ==========");
    NSLog(@"Dump:  .statusCode: %d", (int)self.statusCode);
    NSLog(@"Dump:  .maxCount:   %d", (int)self.maxCount);
    NSLog(@"Dump:  .hasError:   %@", _hasError   ? @"true" : @"false");
    NSLog(@"Dump:  .message:    %@", _message);
    
    if([_resultInfo count] > 0){
        NSLog(@"Dump:==========  [resultInfo] ==========");
        [_resultInfo dump];
    }
    
    NSUInteger dataListCount = self.dataList.count;
    
    if(dataListCount > 0){
        NSLog(@"Dump:==========  [dataList] ==========");
        
        for(int i=0; i< dataListCount; i++){
            NSLog(@"Dump: ----------  [item:%d] ----------", i +1);
            DataItemDetail *item = [_dataList objectAtIndex:i];
            [item dump];
        }
    }
    
    NSLog(@"Dump:-----------  [FINISHED] ----------\n\n");
}

/** 是否是一个有效的列表数据 */
- (BOOL)isValidListData {
    if(nil == _dataList || _hasError){
        return NO;
    }
    
    // 这里不要随便改，合法的搜索结果一定是结果数量不能为空的
    if([_dataList count] < 1){
        return NO;
    }
    
    return YES;
}

#pragma mark -
#pragma mark 设置数据

/** 把所有元素的指定键名的值都置成指定字符串值 */
- (BOOL)setAllItemsKey:(NSString *)key withString:(NSString *)value {
    if(nil == _dataList){
        return NO;
    }
    
    for(DataItemDetail *item in _dataList) {
        [item setString:value forKey:key];
    }
    
    return YES;
}

/** 把所有元素的指定键名的值都置成布尔值 */
- (BOOL)setAllItemsKey:(NSString *)key withBool:(BOOL)value {
    if(nil == _dataList){
        return NO;
    }
    
    for(DataItemDetail *item in _dataList) {
        [item setBool:value forKey:key];
    }
    
    return YES;
}

/** 把所有元素的指定键名的值都置成浮点数值 */
- (BOOL)setAllItemsKey:(NSString *)key withFloat:(CGFloat)value {
    if(nil == _dataList){
        return NO;
    }
    
    for(DataItemDetail *item in _dataList) {
        [item setFloat:value forKey:key];
    }
    
    return YES;
}

/** 把所有元素的指定键名的值都置成整数型值 */
- (BOOL)setAllItemsKey:(NSString *)key withInt:(int)value {
    if(nil == _dataList){
        return NO;
    }
    
    for(DataItemDetail *item in _dataList) {
        [item setInt:value forKey:key];
    }
    
    return YES;
}

#pragma mark -
#pragma mark 删除数据
/** 清除所有元素，不包括数据适配器容器中的数据 */
- (void)clear {
    [_resultInfo clear];
    
    [_dataList removeAllObjects];
    
    _statusCode = 0;
    _maxCount = 0;
    _hasError = NO;
    self.message = @"";
}

/** 删除所有对象 */
- (void)removeItems{
    if (nil == _dataList || [_dataList count] < 1) {
        return;
    }
    
    [_dataList removeAllObjects];
}


/** 删除一个对象 */
- (void)removeItem:(DataItemDetail *)item {
    if (nil == _dataList || nil == item || [_dataList count] < 1) {
        return;
    }
    
    [_dataList removeObject:item];
}

#pragma mark -
#pragma mark 获取数据

/** 获取指定键名对应的元素队列 */
- (NSArray *)arrayForKey:(NSString *)key {
    NSMutableArray *aArray = [[NSMutableArray alloc] init];
    for(int i = 0; i<self.dataList.count; i++) {
        DataItemDetail *item = [self getItem:i];
        NSString *string = [item getString:key];
        if (string.length == 0) {
            string = @"";
        }
        [aArray addObject:string];
    }
    
    return aArray;
}


/** 设置指定位置 (index) 的 DataItemDetail 对象 */
- (BOOL)setItem:(DataItemDetail *)item atIndex:(NSUInteger)index {
    if (nil == _dataList || index >= [_dataList count]) {
        return NO;
    }
    
    self.dataList[index] = item;
    
    return YES;
}

/** 获得指定位置 (index) 的 DataItemDetail 对象 */
- (DataItemDetail *)getItem:(NSUInteger)index {
    if (nil == _dataList || index >= [_dataList count]) {
        return nil;
    }
    
    return self.dataList[index];
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

/** 从NSData数据流中反序列化出一个 DataItemResult 对象 */
+ (DataItemResult *)FromData:(NSData*)data {
    if (nil == data) {
        return nil;
    }
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    
    DataItemResult *items = [[DataItemResult alloc] initWithCoder:unarchiver];
    
    [unarchiver finishDecoding];
    
    return items;
}

/** 反序列化函数 */
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    if(nil != self){
        [self initVars];
        
        _maxCount = [aDecoder decodeIntegerForKey:@"maxCount"];
        
        _statusCode = [aDecoder decodeIntegerForKey:@"statusCode"];
        
        _hasError = [aDecoder decodeBoolForKey:@"hasError"];
        
        _itemUniqueKeyName = [aDecoder decodeObjectForKey:@"itemUniqueKeyName"];
        _message = [aDecoder decodeObjectForKey:@"errorMessage"];
        
        _resultInfo = [DataItemDetail FromData:[aDecoder decodeObjectForKey:@"resultInfo"]];
        
        NSString *dataDetailClassString = [aDecoder decodeObjectForKey:@"itemDetailClass"];
        Class dataDetailClass = NULL;
        if (nil == dataDetailClassString) {
            dataDetailClass = [DataItemDetail class];
        }else{
            dataDetailClass = NSClassFromString(dataDetailClassString);
        }
        
        assert([dataDetailClass isSubclassOfClass:[DataItemDetail class]]);
        
        NSMutableArray *saveList = [aDecoder decodeObjectForKey:@"dataList"];
        
        if (nil != saveList) {
            for(NSData *data in saveList){
                [_dataList addObject:[dataDetailClass FromData:data]];
            }
        }
        
        [self checkVars];
    }
    
    return self;
}

/** 序列化函数 */
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:_maxCount forKey:@"maxCount"];
    [aCoder encodeInteger:_statusCode forKey:@"statusCode"];
    
    [aCoder encodeBool:_hasError forKey:@"hasError"];
    
    [aCoder encodeObject:_itemUniqueKeyName forKey:@"itemUniqueKeyName"];
    [aCoder encodeObject:_message forKey:@"errorMessage"];
    
    [aCoder encodeObject:[_resultInfo toData] forKey:@"resultInfo"];
    
    NSMutableArray *saveList = [NSMutableArray arrayWithCapacity:0];
    
    if (_dataList.count > 0) {
        [aCoder encodeObject:NSStringFromClass([_dataList[0] class]) forKey:@"itemDetailClass"];
    }
    
    for(DataItemDetail *item in _dataList){
        @autoreleasepool {
            [saveList addObject:[item toData]];
            
        }
    }
    
    [aCoder encodeObject:saveList forKey:@"dataList"];
}

@end
