//
//  AppCore.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/8/13.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "AppCore.h"

#import "Exercise.h"

#import "DataLoader.h"
#import "DataItemResult.h"

static int const kMultiteNetWorkCount = 20;          //并行的网络请求数

@implementation AppCore

SINGLETON_IMPLEMENT(AppCore)

- (void)dealloc {
    [_appCoreQueue cancelAllOperations];
    _appCoreQueue = nil;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.appTablePageSize = 20;
        self.appLaunchDate = [NSString today];
        
        self.appCoreQueue = [[NSOperationQueue alloc] init];
        self.appCoreQueue.maxConcurrentOperationCount = kMultiteNetWorkCount;
    }
    return self;
}

#pragma mark - 网络请求
- (void)networkUpdateAccount {
    NSError *error;
    NSDictionary *account = [AccountCoreDataHelper getAccountDictionaryWithError:&error];
    
    NSString *tmpString;
    NSMutableString *url = [[NSMutableString alloc] initWithString:APPCONFIG_CONN_HEAD];
    [url appendString:APPCONFIG_CONN_SERVER];
    [url appendString:APPCONFIG_CONN_AGENT];
    [url appendString:@"/updateAccount?"];
    [url appendString:[NSString stringWithFormat:@"clientID=%@",account[@"clientID"]]];
    [url appendString:[NSString stringWithFormat:@"&name=%@",account[@"name"]]];
    [url appendString:[NSString stringWithFormat:@"&level=%@",account[@"level"]]];
    tmpString = account[@"exp"];
    if (tmpString.length > 8) {
        tmpString = [tmpString substringToIndex:7];
    }
    [url appendString:[NSString stringWithFormat:@"&exp=%@",tmpString]];
    [url appendString:[NSString stringWithFormat:@"&count=%@",account[@"count"]]];
    [url appendString:[NSString stringWithFormat:@"&lastDate=%@",account[@"lastLaunchDate"]]];
    [url appendString:[NSString stringWithFormat:@"&gender=%@",account[@"gender"]]];
    [url appendString:[NSString stringWithFormat:@"&sitUpLevel=%@",account[@"sitUpLevel"]]];
    [url appendString:[NSString stringWithFormat:@"&pushUpLevel=%@",account[@"pushUpLevel"]]];
    [url appendString:[NSString stringWithFormat:@"&squatLevel=%@",account[@"squatLevel"]]];
    [url appendString:[NSString stringWithFormat:@"&walkLevel=%@",account[@"walkLevel"]]];
    [url appendString:[NSString stringWithFormat:@"&coin=%@",account[@"coin"]]];
    [url appendString:[NSString stringWithFormat:@"&hair=%@",account[@"hair"]]];
    [url appendString:[NSString stringWithFormat:@"&eye=%@",account[@"eye"]]];
    [url appendString:[NSString stringWithFormat:@"&mouth=%@",account[@"mouth"]]];
    [url appendString:[NSString stringWithFormat:@"&clothes=%@",account[@"clothes"]]];
    
    //查找构筑json
    NSArray *array = [ExerciseCoreDataHelper getExerciseByDate:account[@"lastUpdateDate"] withError:&error];
    NSMutableString *jsonString = [NSMutableString new];
    if (array && array.count > 0) {
        [jsonString appendString:@"{\"Exercise\":["];
        for (Exercise *ex in array){
            [jsonString appendString:@"{"];
            [jsonString appendString:[NSString stringWithFormat:@"\"type\":\"%@\",", ex.type]];
            [jsonString appendString:[NSString stringWithFormat:@"\"num\":\"%@\",", ex.num]];
            [jsonString appendString:[NSString stringWithFormat:@"\"date\":\"%@\"", ex.date]];
            [jsonString appendString:@"},"];
        }
        jsonString = [[jsonString substringToIndex:jsonString.length-1] mutableCopy];
        [jsonString appendString:@"]}"];
    } else {
        [jsonString appendString:@"[]"];
    }
    
    [url appendString:[NSString stringWithFormat:@"&json=%@",jsonString]];
    
    DataLoader *loader = [[DataLoader alloc] initWithURL:url
                                              httpMethod:Method_POST
                                                complete:^(DataItemResult *result) {
                                                    if (result.hasError) {
                                                        NSLog(@"%@", result.message);
                                                        return;
                                                    }
                                                    
                                                    [AccountCoreDataHelper setDataByName:@"lastUpdateDate" andData:[NSString today] withError:nil];
                                                }];
    loader = nil;
}

@end
