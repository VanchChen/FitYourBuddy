//
//  SoundTool.h
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/2/28.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>

@interface SoundTool : NSObject

/** 播放准备音效 */
+(void)playSoundWithReadyNum:(NSInteger)num;

/** 播放运动音效 */
+(void)playSoundWithExerciseNum:(NSInteger)num;

/**
 *  播放音效
 *
 *  @param soundname 音乐文件名
 *  @param type      文件类型
 */
+(void)playSound:(NSString *)soundname type:(NSString *)type;

@end
