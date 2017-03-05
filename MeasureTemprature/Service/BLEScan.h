//
//  BLEScan.h
//  MeasureTemprature
//
//  Created by Akber Sayani on 27/10/2016.
//  Copyright © 2016 Akber Sayani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHBLE.h"

@interface BLEScan : NSObject

@property(nonatomic,strong) NSMutableArray *findDeviceArray;
@property(nonatomic,strong) ZHBLEPeripheral *connectedDevice;
@property(nonatomic,strong) ZHBLECentral *central;

+ (instancetype)sharedInstance;
- (void)initScanConfiguration;
- (void)startScan;
- (void)stopScan;
- (void)startDummyScan;
- (void)stopDummyScan;

@end
