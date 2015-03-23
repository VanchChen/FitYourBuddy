//
//  EBStepManager.m
//  EBStepCounter
//
//  Created by EggmanQi on 14-3-23.
//  Copyright (c) 2014年 EggBrain Studio. All rights reserved.
//

#import "EBStepManager.h"
#import "EBM7Manager.h"
#import "EBMotionManager.h"

@interface EBStepManager ()
{
    NSInteger        steps;
}

@property(nonatomic, strong)EBM7Manager         *m7;
@property(nonatomic, strong)EBMotionManager     *motion;
@property(nonatomic, strong)EBStepUpdateHandler handler;

@end

@implementation EBStepManager

+ (EBStepManager *)sharedManager
{
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    });
}

- (id) init
{
    if ( (self = [super init]) ) {
        
        self.motion = [EBMotionManager sharedManager];
        self.m7 = [EBM7Manager sharedManager];
        
        steps = 0;
    }
    return self;
}

#pragma mark -
- (void)startStepCounting:(EBStepUpdateHandler)handler
{
    _handler = handler;
    
//    if ([self.m7 isAvailable]) {
//        [self.m7 startWithHandler:^(NSInteger numberOfSteps, NSDate *timestamp, NSError *error) {
//           
//            steps = steps + numberOfSteps;
//            
//            if (_handler) {
//                _handler(steps, timestamp, error);
//            }
//        }];
//    }else {
        [self.motion startWithHandler:^(NSInteger numberOfSteps, NSDate *timestamp, NSError *error) {
            steps = steps + numberOfSteps;
            
            if (_handler) {
                _handler(steps, timestamp, error);
            }
        }];
    //}
}

- (void)stopStepCounting
{
    steps = 0;
    
    if ([self.m7 isAvailable]) {
        [self.m7 stop];
    }else {
        [self.motion stop];
    }
}



@end
