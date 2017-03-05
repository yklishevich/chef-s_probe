//
//  AppDelegate.h
//  MeasureTemprature
//
//  Created by Akber Sayani on 15/09/2016.
//  Copyright © 2016 Akber Sayani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic,assign) BOOL isAlertOff;
@property(nonatomic,assign) double deviceTemprature;
@property(nonatomic,assign) double thresholdTemprature;

@end

