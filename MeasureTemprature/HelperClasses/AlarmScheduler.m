//
//  AlarmScheduler.m
//  MeasureTemprature
//
//  Created by Rostyslav.Stepanyak on 3/4/17.
//  Copyright © 2017 Akber Sayani. All rights reserved.
//

#import "AlarmScheduler.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface AlarmScheduler()<AVAudioPlayerDelegate>
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic) BOOL shouldVibrate;

@end

@implementation AlarmScheduler

#pragma mark - lifecycle

+ (AlarmScheduler *)scheduler {
    static AlarmScheduler *sharedScheduler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedScheduler = [AlarmScheduler new];
    });
    
    return sharedScheduler;
}

- (id)init {
    self = [super init];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *source = [[NSBundle mainBundle] pathForResource:@"beep1dot5sec" ofType:@"mp3"];
        NSError *error;
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:source]
                                                                  error:&error];
        self.audioPlayer.delegate = self;
        self.audioPlayer.numberOfLoops = 0;
        self.audioPlayer.volume = 1.0;
        [self.audioPlayer prepareToPlay];
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:NULL];
    });
    
    return self;
}

/**
 * Starts playing the alarm with vibration
 * @param shouldVibrate Indicate if the vibration should be made along with the alarm sound
 */
- (void)soundAlarmWithVibrate:(BOOL)shouldVibrate {
    __weak AlarmScheduler *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (weakSelf.audioPlayer.isPlaying) {
            //do nothing, it's still playing
        }
        else {
            [weakSelf.audioPlayer play];
            _shouldVibrate = shouldVibrate;
            
            if(shouldVibrate)
                AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        }
    });
}

- (void)stopAlarm {
    __weak AlarmScheduler *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.audioPlayer stop];
        _shouldVibrate = false;
    });
    
}

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player
                       successfully:(BOOL)flag {
    
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player
                                 error:(NSError * __nullable)error {
    
}


@end
