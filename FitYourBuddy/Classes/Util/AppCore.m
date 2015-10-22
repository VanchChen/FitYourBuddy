//
//  AppCore.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/8/13.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "AppCore.h"
#import <objc/runtime.h>

#import "Exercise.h"

#import "DataLoader.h"
#import "DataItemResult.h"

#import "WelcomeViewController.h"
#import "TarBarViewController.h"

static int const kMultiteNetWorkCount = 20;          //并行的网络请求数

@interface AppCore ()

@property (nonatomic, copy) NSString *readyToWork;  //准备好要展现的class

@end

@implementation AppCore

SINGLETON_IMPLEMENT(AppCore)

- (void)dealloc {
    [_appCoreQueue cancelAllOperations];
    _appCoreQueue = nil;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _appTablePageSize = 20;
        _appLaunchDate = [NSString today];
        
        _appCoreQueue = [[NSOperationQueue alloc] init];
        _appCoreQueue.maxConcurrentOperationCount = kMultiteNetWorkCount;
        
        _readyToWork = nil;
    }
    return self;
}

#pragma mark - 网络请求
- (void)networkUpdateAccount {
    BOOL allowSendToServer = [[NSUserDefaults standardUserDefaults] boolForKey:@"AllowSendToServer"];
    if (!allowSendToServer) {
        return;
    }
    
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

#pragma mark - 跳转页面
/**跳转到欢迎页面*/
- (void)jumpToWelcomeViewController {
    WelcomeViewController* welcomeView = [[WelcomeViewController alloc] init];
    [[[[UIApplication sharedApplication] delegate] window] setRootViewController:welcomeView];
}

/**跳转到首页*/
- (void)jumpToIndexViewController {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    TarBarViewController* tabBarController = [[TarBarViewController alloc] init];
    [[[[UIApplication sharedApplication] delegate] window] setRootViewController:tabBarController];
}

/**跳转到某一个页面，现是跳转到锻炼页面，present的形式*/
- (void)presentViewControllerByClass:(NSString *)className {
    _readyToWork = className;
    [self checkPresent];
}

/**检查是否有跳转*/
- (void)checkPresent {
    if (_readyToWork.length > 0) {
        UIViewController *rootVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
        if ([rootVC isKindOfClass:[TarBarViewController class]]) {
            UINavigationController *navController = [(TarBarViewController *)rootVC selectedViewController];
            Class cls = objc_getClass([_readyToWork UTF8String]);
            id newViewController = [[cls alloc] init];
            [navController presentViewController:newViewController animated:YES completion:nil];
            _readyToWork = nil;
        }
    }
}

@end
