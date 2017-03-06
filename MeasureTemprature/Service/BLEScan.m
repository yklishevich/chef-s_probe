//
//  BLEScan.m
//  MeasureTemprature
//
//  Created by Akber Sayani on 27/10/2016.
//  Copyright © 2016 Akber Sayani. All rights reserved.
//

#import "BLEScan.h"
#import "ZHBLEStoredPeripherals.h"
#import "NSData+HexString.h"
#import "Constants.h"
#import "UtilitiesHelper.h"
#import "AppDelegate.h"
#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "AlarmScheduler.h"

#define WEAKSELF  typeof(self) __weak weakSelf = self;

@interface BLEScan()

@property(nonatomic,strong) NSTimer *timer;

@end

@implementation BLEScan

+ (instancetype)sharedInstance {
    static BLEScan *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[BLEScan alloc] init];
    });
    
    return _sharedInstance;
}

- (void)initScanConfiguration {
    NSDictionary * opts = nil;
    if ([[UIDevice currentDevice].systemVersion floatValue]>=7.0) {
        opts = @{CBCentralManagerOptionShowPowerAlertKey:@YES};
    }
    
    self.central = [ZHBLECentral sharedZHBLECentral];
    NSArray *storedArray = [ZHBLEStoredPeripherals genIdentifiers];
    NSLog(@"storedIdentifier:%@",storedArray);
    NSArray *peripherayArray = nil;
    if (storedArray.count>0) {
        peripherayArray = [self.central retrievePeriphearlsWithIdentifiers:storedArray];
    }
    //self.connectedDeviceArray = [NSMutableArray arrayWithArray:peripherayArray];
    
    self.findDeviceArray = [NSMutableArray array];
    if (self.central.state != CBCentralManagerStatePoweredOn) {
        __weak id weakSelf = self;
        self.central.onStateChanged = ^(NSError *error){
            [weakSelf scan];
        };
    }

}

- (void)scan {
    WEAKSELF;
    NSArray *identifiers = [ZHBLEStoredPeripherals genIdentifiers];
    NSLog(@"identifiers:%@",identifiers);
    
//    NSArray *conectedPeripherals = [self.central retrievePeriphearlsWithIdentifiers:identifiers];
//    NSLog(@"have connceted peripheral:%@",conectedPeripherals);
//    [conectedPeripherals enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop){
//        ZHBLEPeripheral *peripheral = obj;
//        [weakSelf addPeripheralToConnectedDevice:peripheral];
//    }];
    
    //CBUUID *uuid = [CBUUID UUIDWithString:TRANSFER_SERVICE_UUID];// You can use it test custom services
    NSArray *uuids = nil;//@[uuid];
    
#warning uncomment
//    [self.central scanPeripheralWithServices:uuids
//                                     options:@{CBCentralManagerScanOptionAllowDuplicatesKey: @(YES)}
//                                   onUpdated:^(ZHBLEPeripheral *peripheral,NSDictionary *data){
//        if (peripheral) {
//            
//            peripheral.advertisementData = data;
//            [weakSelf addPeripheralToFindDevice:peripheral];
//        }
//    }];    
}

- (void)addPeripheralToFindDevice:(ZHBLEPeripheral *)peripheral {
    NSAssert(peripheral !=nil, @"peripheral can not nil");
    
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (self.connectedDevice) {
        if ([[peripheral.identifier UUIDString] isEqualToString:[self.connectedDevice.identifier UUIDString]]) {
            
            double temprature = [UtilitiesHelper getTempratureFromAdvertisementData:peripheral.advertisementData];
            if (temprature != appdelegate.deviceTemprature) {
                // change in temprature
                appdelegate.deviceTemprature = temprature;
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TEMPRATURE_CHANGED
                                                                    object:self];
            }
            
            if (!appdelegate.isAlertOff && appdelegate.thresholdTemprature > 0) {
                
                double preThresholdTemprature = appdelegate.thresholdTemprature - 2.0;
                
                if (temprature == preThresholdTemprature || temprature >= appdelegate.thresholdTemprature) {
                    [[AlarmScheduler scheduler] soundAlarmWithVibrate:true];                }
            }
        }
    }
    
    NSInteger index=0;
    for (ZHBLEPeripheral *ZHBlePeripheral in self.findDeviceArray) {
        if ([[peripheral.identifier UUIDString] isEqualToString:[ZHBlePeripheral.identifier UUIDString]]) {
            [self.findDeviceArray replaceObjectAtIndex:index withObject:peripheral];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DEVICE_FOUND
                                                                object:self];
            return;
        }
        index++;
    }
    
    [self.findDeviceArray addObject:peripheral];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DEVICE_FOUND
                                                        object:self];
}

- (void)startScan {
    [self scan];
}

- (void)stopScan {
    [self.central stopScan];
}

- (void)startDummyScan {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                  target:self
                                                selector:@selector(foundAdvertisementData)
                                                userInfo:nil repeats:YES];
}

- (void)stopDummyScan {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)foundAdvertisementData {
    
    NSDictionary *data = @{@"kCBAdvDataIsConnectable":@(1),
                           @"kCBAdvDataLocalName":@"Temp. meas",
                           @"kCBAdvDataManufacturerData":[NSData dataWithHexString:@"440106ff7900ffac000001010061"]};
    
    ZHBLEPeripheral *peripheral = [[ZHBLEPeripheral alloc] init];
    peripheral.identifier = [[NSUUID UUID] initWithUUIDString:@"E621E1F8-C36C-495A-93FC-0C247A3E6E5F"];
    peripheral.name = @"dummy device";
    peripheral.advertisementData = data;
    
    [self addPeripheralToFindDevice:peripheral];
}



@end
