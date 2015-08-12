//
//  NetworkReachability.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/8/12.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "NetworkReachability.h"
#import "CoreTelephony/CTTelephonyNetworkInfo.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>

static SCNetworkReachabilityRef __reachability = nil;
NetworkReachability GetNetworkReachability() {
    if(!__reachability) {
        struct sockaddr_in zeroAddress;
        bzero(&zeroAddress, sizeof(zeroAddress));
        zeroAddress.sin_len = sizeof(zeroAddress);
        zeroAddress.sin_family = AF_INET;
        __reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)&zeroAddress);
    }
    
    SCNetworkReachabilityFlags flags;
    if (__reachability && SCNetworkReachabilityGetFlags(__reachability, &flags)) {
        if ((flags & kSCNetworkReachabilityFlagsReachable) == 0) {
            return NetworkReachabilityNone;
        }
        
        NetworkReachability retVal = NetworkReachabilityNone;
        if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
        {
            // if target host is reachable and no connection is required
            //  then we'll assume (for now) that your on Wi-Fi
            retVal = NetworkReachabilityWifi;
        }
        
        if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
             (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0))
        {
            // ... and the connection is on-demand (or on-traffic) if the
            //     calling application is using the CFSocketStream or higher APIs
            
            if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
            {
                // ... and no [user] intervention is needed
                retVal = NetworkReachabilityWifi;
            }
        }
        
        if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
        {
            // ... but WWAN connections are OK if the calling application
            //     is using the CFNetwork (CFSocketStream?) APIs.
            retVal = NetworkReachabilityMobile;
        }
    }
    
    return NetworkReachabilityNone;
}

static CTTelephonyNetworkInfo * __telephonyNetworkInfo;
NetworkReachability GetAccurateNetworkReachability() {
    NetworkReachability reachability = GetNetworkReachability();
    if (reachability == NetworkReachabilityMobile) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
            if (!__telephonyNetworkInfo) {
                __telephonyNetworkInfo = [CTTelephonyNetworkInfo new];
            }
            NSString * radioAccessTechnology = __telephonyNetworkInfo.currentRadioAccessTechnology;
            if ([radioAccessTechnology isEqualToString:CTRadioAccessTechnologyGPRS] ||
                [radioAccessTechnology isEqualToString:CTRadioAccessTechnologyEdge] ||
                [radioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMA1x])
                reachability = NetworkReachabilityMobile2G;
            else if ([radioAccessTechnology isEqualToString:CTRadioAccessTechnologyLTE])
                reachability = NetworkReachabilityMobile4G;
            else
                reachability = NetworkReachabilityMobile3G;
        } else {
        }
    }
    return reachability;
}