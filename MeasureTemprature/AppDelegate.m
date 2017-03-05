//
//  AppDelegate.m
//  MeasureTemprature
//
//  Created by Akber Sayani on 15/09/2016.
//  Copyright © 2016 Akber Sayani. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "LeftSideMenuViewController.h"
#import "MMDrawerController.h"

#import <AVFoundation/AVFoundation.h>
#import "AlarmScheduler.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self setRootController];
    
    //NSError *setCategoryErr = nil;
    //NSError *activationErr  = nil;
    //[[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error:&setCategoryErr];
    //[[AVAudioSession sharedInstance] setActive:YES error:&activationErr];
    
    //prepare the sound
    [AlarmScheduler scheduler];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    /*UIBackgroundTaskIdentifier task = UIBackgroundTaskInvalid;
    task = [application beginBackgroundTaskWithName:@"Alert sound" expirationHandler:^{
        [application endBackgroundTask:task];
    }];*/
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)theEvent {
    
//    if (theEvent.type == UIEventTypeRemoteControl)  {
//        switch(theEvent.subtype)        {
//            case UIEventSubtypeRemoteControlPlay:
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"TogglePlayPause" object:nil];
//                break;
//            case UIEventSubtypeRemoteControlPause:
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"TogglePlayPause" object:nil];
//                break;
//            case UIEventSubtypeRemoteControlStop:
//                break;
//            case UIEventSubtypeRemoteControlTogglePlayPause:
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"TogglePlayPause" object:nil];
//                break;
//            default:
//                return;
//        }
//    }
}

#pragma mark - User Methods

- (void)setRootController {
    
    UIStoryboard* storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];

    ViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    
    UINavigationController *navigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:controller];
    
    LeftSideMenuViewController *leftMenuViewController = [storyboard instantiateViewControllerWithIdentifier:@"LeftSideMenuViewController"];
    
    MMDrawerController * drawerController = [[MMDrawerController alloc]
                                             initWithCenterViewController:navigationController
                                             leftDrawerViewController:leftMenuViewController
                                             rightDrawerViewController:nil];
    
    [drawerController setShowsShadow:NO];
    [drawerController setRestorationIdentifier:@"MMDrawer"];
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModePanningNavigationBar];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    self.window.rootViewController = drawerController;
}


@end
