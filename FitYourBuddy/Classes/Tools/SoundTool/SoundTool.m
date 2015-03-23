//
//  SoundTool.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/2/28.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "SoundTool.h"

@implementation SoundTool

+(void)playsound:(NSString *)soundname{
    if (soundname.length > 0) {
        NSURL* system_sound_url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:soundname ofType:@"wav"]];
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
