//
// 抄袭于王默编写的DataItemResult，学习为主，赞赞赞
// by 弱鸡的陈文琦

@class DataItemDetail;

@interface DataItemResult : NSObject <NSCoding>
/** 列表中的数据元素个数 */
@property (nonatomic, assign) NSUInteger        maxCount;
/** 返回的状态码 */
@property (nonatomic, assign) NSInteger         statusCode;
/** 是否有错误 */
@property (nonatomic, assign) BOOL              hasError;
/** 错误提示信息 */
@property (nonatomic, copy)   NSString          *message;
/** 数据解释信息 */
@property (nonatomic, strong) DataItemDetail    *resultInfo;
/** 数据列表 */
@property (nonatomic, strong) NSMutableArray    *dataList;
/** 数据唯一标识，可能用于数据去重 */
@property (nonatomic, copy)   NSString          *itemUniqueKeyName;
/** 对应的网络原数据 */
@property (nonatomic, retain) NSData            *rawData;

/** 获取一份和另一个result一模一样的拷贝 */
+ (DataItemResult *)resultFromAnother:(DataItemResult *)result;
/** 获取当前节点数 */
- (NSUInteger)count;
/** 添加一个节点 */
- (void)addItem:(DataItemDetail *)item;
/** 往当前列表容器的后端追加另一个列表容器所有的数据 */
- (void)appendItems:(DataItemResult *)items;
/** 设定当前主键 */
- (void)setItemUniqueKeyName:(NSString *)key;
/** 是否是一个有效的列表数据 */
- (BOOL)isValidListData;
/** 把所有元素的指定键名的值都置成指定字符串值 */
- (BOOL)setAllItemsKey:(NSString *)key withString:(NSString *)value;
/** 把所有元素的指定键名的值都置成布尔值 */
- (BOOL)setAllItemsKey:(NSString *)key withBool:(BOOL)value;
/** 把所有元素的指定键名的值都置成浮点数值 */
- (BOOL)setAllItemsKey:(NSString *)key withFloat:(CGFloat)value;
/** 把所有元素的指定键名的值都置成整数型值 */
- (BOOL)setAllItemsKey:(NSString *)key withInt:(int)value;
/** 获取指定键名对应的元素队列 */
- (NSArray *)arrayForKey:(NSString *)key;
/** 清除所有元素，不包括数据适配器容器中的数据 */
- (void)clear;
/** 删除所有对象 */
- (void)removeItems;
/** 删除一个对象 */
- (void)removeItem:(DataItemDetail *)item;
/** 设置指定位置 (index) 的 DataItemDetail 对象 */
- (BOOL)setItem:(DataItemDetail *)item atIndex:(NSUInteger)index;
/** 获得指定位置 (index) 的 DataItemDetail 对象 */
- (DataItemDetail *)getItem:(NSUInteger)index;
/** 调试接口，在console中打印出当前对象包含的元素 */
- (void)dump;
/** 当前对象序列化到NSData数据流中 */
- (NSData *)toData;
/** 从NSData数据流中反序列化出一个 DataItemResult 对象 */
+ (DataItemResult *)FromData:(NSData*)data;

@end
