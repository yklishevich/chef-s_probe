//
//  AlarmScheduler.h
//  MeasureTemprature
//
//  Created by Rostyslav.Stepanyak on 3/4/17.
//  Copyright © 2017 Akber Sayani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlarmScheduler : NSObject

/**
 * shared instance of the alarm schedule
 */
+ (AlarmScheduler *)scheduler;

/**
 * Starts playing the alarm with vibration
 * @param shouldVibrate Indicate if the vibration should be made along with the alarm sound
 */
- (void)soundAlarmWithVibrate:(BOOL)shouldVibrate;

@end
