//
//  SoundTool.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/2/28.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "SoundTool.h"

@implementation SoundTool

/** 播放准备音效 */
+(void)playSoundWithReadyNum:(NSInteger)num {
    if (num == 4) {
        [self playSound:@"ready" type:@"mp3"];
    } else {
        [self playSound:[NSString stringWithFormat:@"%ld", (long)num] type:@"mp3"];
    }
}

/** 播放运动音效 */
+(void)playSoundWithExerciseNum:(NSInteger)num {
    if (num == 0) {
        return;
    }
    
    //NSArray *soundArray = @[@"c4",@"d4",@"e4",@"g4",@"a4",@"c5",@"a4",@"g4",@"e4",@"d4"];
    NSArray *canon = @[@"d4",@"a3",@"b3",@"f3#",@"g3",@"d3",@"g3",@"a3"];
    NSInteger mod = num % canon.count - 1;
    if (mod < 0) {
        mod += canon.count;
    }
    [self playSound:canon[mod] type:@"wav"];
}

+(void)playSound:(NSString *)soundname type:(NSString *)type{
    if (soundname.length > 0) {
        NSURL* system_sound_url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:soundname ofType:type]];
        SystemSoundID system_sound_id;
        
        AudioServicesCreateSystemSoundID(
                                         (__bridge CFURLRef)system_sound_url,
                                         &system_sound_id
                                         );
        
        // Register the sound completion callback.
        AudioServicesAddSystemSoundCompletion(
                                              system_sound_id,
                                              NULL, // uses the main run loop
                                              NULL, // uses kCFRunLoopDefaultMode
                                              MySoundFinishedPlayingCallback, // the name of our custom callback function
                                              NULL // for user data, but we don't need to do that in this case, so we just pass NULL
                                              );
        
        // Play the System Sound
        AudioServicesPlaySystemSound(system_sound_id);
    }
}


void MySoundFinishedPlayingCallback(SystemSoundID sound_id, void* user_data)
{
    AudioServicesDisposeSystemSoundID(sound_id);
}

@end
