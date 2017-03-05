//
//  Constants.h
//  MeasureTemprature
//
//  Created by Akber Sayani on 24/09/2013.
//  Copyright © 2013 Akber Sayani. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef ZHBLE_constant_h
#define ZHBLE_constant_h

#endif
#define TRANSFER_SERVICE_UUID               @"902DD287-69BE-4ADD-AACF-AA3C24D83B66"
#define TRANSFER_CHARACTERISTIC_UUID        @"6E345709-75EE-4988-A20E-7D4BBD129B08"

#define NOTIFICATION_TEMPRATRURE_RECEIVED   @"ReceivedTempratureNotification"
#define NOTIFICATION_DEVICE_FOUND           @"DeviceFoundNotification"
#define NOTIFICATION_TEMPRATURE_CHANGED     @"TempratureChangeNotification"

#define WEAKSELF  typeof(self) __weak weakSelf = self;

@interface Constants : NSObject

extern NSString *const kWebsiteUrl;

extern NSString *const kWebGetStartScreen;
extern NSString *const kWebGetAboutUs;
extern NSString *const kWebGetHilife;
extern NSString *const kWebGetTempratures;
extern NSString *const kWebGetAnleitung;
extern NSString *const kWebGetVersionen;
extern NSString *const kWebGetVerkaufsstellen;


@end
