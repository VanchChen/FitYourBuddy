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



@end
