//
//  deviceListTableViewController.m
//  ZHBLE
//
//  Created by aimoke on 15/7/17.
//  Copyright (c) 2015年 zhuo. All rights reserved.
//


#define bleCellIdentifier @"searchBleCellIdentifier"

#import "DeviceListTableViewController.h"
#import "peripheralserviceTableViewController.h"
#import "Constants.h"
#import "DecodeUtils.hpp"
#import "ZHBLEStoredPeripherals.h"
#import "NSData+HexString.h"

@interface DeviceListTableViewController ()

@property(nonatomic,strong) NSTimer *timer;

@end

@implementation DeviceListTableViewController


#pragma mark - ViewLife cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Scan devices";
    
    [self initBarButtonItems];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
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
    self.connectedDeviceArray = [NSMutableArray arrayWithArray:peripherayArray];
    self.findDeviceArray = [NSMutableArray array];
    if (self.central.state != CBCentralManagerStatePoweredOn) {
        __weak id weakSelf = self;
        self.central.onStateChanged = ^(NSError *error){
            [weakSelf scan];
        };
    }
    
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
//                                                  target:self
//                                                selector:@selector(foundAdvertisementData)
//                                                userInfo:nil repeats:NO];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self scan];
    
    //[self performSelector:@selector(foundAdvertisementData) withObject:nil afterDelay:5.0];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.central stopScan];
    
//    if (self.timer) {
//        [self.timer invalidate];
//        self.timer = nil;
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initBarButtonItems {
    /* Create left barbutton */
    UIBarButtonItem *closeBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Close"
                                                                     style:UIBarButtonItemStyleDone
                                                                    target:self
                                                                    action:@selector(onClose:)];
    self.navigationItem.rightBarButtonItem = closeBarItem;
    
//    /* Create right barbutton */
//    UIBarButtonItem *skipBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Skip"
//                                                                    style:UIBarButtonItemStyleDone
//                                                                   target:self
//                                                                   action:@selector(onSkip:)];
//    self.navigationItem.rightBarButtonItem = skipBarItem;
}

- (void)foundAdvertisementData {
    
    NSDictionary *data = @{@"kCBAdvDataIsConnectable":@(1),
                           @"kCBAdvDataLocalName":@"Temp. meas",
                           @"kCBAdvDataManufacturerData":[NSData dataWithHexString:@"440106ff7900ffac000001010061"]};
    
    ZHBLEPeripheral *peripheral = [[ZHBLEPeripheral alloc] init];
    peripheral.name = @"dummy device";
    peripheral.advertisementData = data;
    
    [self addPeripheralToFindDevice:peripheral];
}

- (double)getTempratureValue:(NSDictionary *)data {
    
    NSData *manufacturerData = [data objectForKey:@"kCBAdvDataManufacturerData"];
    double result = 0;

    if (manufacturerData) {
        NSUInteger len = [manufacturerData length];
        Byte *byteData = (Byte*)malloc(len);
        memcpy(byteData, [manufacturerData bytes], len);
        
        short position;
        if (len >= 8) {
            DecodeUtils::DecodeMeasurement32(byteData[4], byteData[5], byteData[6], byteData[7], result, position);
        }
        
        free(byteData);
    }
    
    return result;
}

- (void)onClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//- (void)onSkip:(id)sender {
//    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TEMPRATRURE_RECEIVED
//                                                        object:self];
//}


#pragma mark - Public Interface
-(void)scan {
    WEAKSELF;
    NSArray *identifiers = [ZHBLEStoredPeripherals genIdentifiers];
    NSLog(@"identifiers:%@",identifiers);

    NSArray *conectedPeripherals = [self.central retrievePeriphearlsWithIdentifiers:identifiers];
    NSLog(@"have connceted peripheral:%@",conectedPeripherals);
    
    [conectedPeripherals enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop){
        ZHBLEPeripheral *peripheral = obj;
        [weakSelf addPeripheralToConnectedDevice:peripheral];
    }];
    
    //CBUUID *uuid = [CBUUID UUIDWithString:TRANSFER_SERVICE_UUID];// You can use it test custom services
    NSArray *uuids = nil;//@[uuid];
    
    [self.central scanPeripheralWithServices:uuids options:@{CBCentralManagerScanOptionAllowDuplicatesKey: @(YES)} onUpdated:^(ZHBLEPeripheral *peripheral,NSDictionary *data){
        if (peripheral) {
            
            peripheral.advertisementData = data;
            [weakSelf addPeripheralToFindDevice:peripheral];
        }
    }];
}

-(void)addPeripheralToFindDevice:(ZHBLEPeripheral *)peripheral {
    NSAssert(peripheral !=nil, @"peripheral can not nil");
    for (ZHBLEPeripheral *ZHBlePeripheral in self.findDeviceArray) {
        if ([[peripheral.identifier UUIDString] isEqualToString:[ZHBlePeripheral.identifier UUIDString]]) {
            return;
        }
    }
    for (ZHBLEPeripheral *ZHBlePeripheral in self.connectedDeviceArray) {
        if ([[peripheral.identifier UUIDString] isEqualToString:[ZHBlePeripheral.identifier UUIDString]]) {
            return;
        }
    }
    [self.findDeviceArray addObject:peripheral];
    [self.tableView reloadData];
    
}

-(void)deletePeripheralInFindDevice:(ZHBLEPeripheral *)peripheral {
    NSAssert(peripheral !=nil, @"peripheral can not nil");
    for (ZHBLEPeripheral *ZHBlePeripheral in self.findDeviceArray) {
        if ([[peripheral.identifier UUIDString] isEqualToString:[ZHBlePeripheral.identifier UUIDString]]) {
            [self.findDeviceArray removeObject:ZHBlePeripheral];
            [self.tableView reloadData];
            return;
        }
    }
   
}

-(void)addPeripheralToConnectedDevice:(ZHBLEPeripheral *)peripheral {
    
    NSAssert(peripheral !=nil, @"peripheral can not nil");
    
    for (ZHBLEPeripheral *ZHBlePeripheral in self.connectedDeviceArray) {
        if ([[peripheral.identifier UUIDString] isEqualToString:[ZHBlePeripheral.identifier UUIDString]]) {
            return;
        }
    }
    [self.connectedDeviceArray addObject:peripheral];
    [self.tableView reloadData];

}

-(void)deletePeripheralInConnectedDevice:(ZHBLEPeripheral *)peripheral {
    NSAssert(peripheral !=nil, @"peripheral can not nil");
    
    for (ZHBLEPeripheral *ZHBlePeripheral in self.connectedDeviceArray) {
        if ([[peripheral.identifier UUIDString] isEqualToString:[ZHBlePeripheral.identifier  UUIDString] ]) {
            [self.connectedDeviceArray removeObject:ZHBlePeripheral];
            [self.tableView reloadData];
            return;
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return self.connectedDeviceArray.count;
            break;
        case 1:
           return  self.findDeviceArray.count;
            break;
            
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:bleCellIdentifier forIndexPath:indexPath];
    
    ZHBLEPeripheral *peripherial = nil;
    switch (indexPath.section) {
        case 0:
        {
            peripherial = [self.connectedDeviceArray objectAtIndex:indexPath.row];
            cell.detailTextLabel.text = @"Connected";
        }
            break;
        case 1:
        {
            peripherial = [self.findDeviceArray objectAtIndex:indexPath.row];
            cell.detailTextLabel.text = nil;
        }
            break;
            
        default:
            break;
    }
    if (peripherial.name && peripherial.name.length>0) {
         cell.textLabel.text = peripherial.name;
    }else
        cell.textLabel.text = [peripherial.identifier UUIDString];
   
    
    if (peripherial.advertisementData) {
        double tempValue = [self getTempratureValue:peripherial.advertisementData];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f", tempValue];
    }
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"My devices";
            break;
        case 1:
            return  @"Other devices";
            break;
            
        default:
            break;
    }
    return 0;

}

#pragma mark - tableview Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZHBLEPeripheral *peripheral = nil;
    switch (indexPath.section) {
        case 0:{
            peripheral = [self.connectedDeviceArray objectAtIndex:indexPath.row];
            //[self pushWithPeripheral:peripheral];
        }
            
            break;
        case 1:
        {
            peripheral = [self.findDeviceArray objectAtIndex:indexPath.row];
            
        }
            
            break;
        default:
            break;
    }
    
    if (peripheral
        && peripheral.advertisementData) {
        
        double tempratureInDegree = [self getTempratureValue:peripheral.advertisementData];
        
        NSDictionary* userInfo = @{@"temprature": @(tempratureInDegree)};
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TEMPRATRURE_RECEIVED
                                                            object:self
                                                          userInfo:userInfo];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Hinweis"
                                                            message:@"Anzeigendaten nicht gefunden"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
    }

/*
    ZHBLEPeripheral *peripheral = nil;
    switch (indexPath.section) {
        case 0:{
             peripheral = [self.connectedDeviceArray objectAtIndex:indexPath.row];
            //[self pushWithPeripheral:peripheral];
        }
           
            break;
         case 1:
        {
             peripheral = [self.findDeviceArray objectAtIndex:indexPath.row];
            
        }
           
            break;
        default:
            break;
    }
    WEAKSELF;
    [self.central connectPeripheral:peripheral options:nil onFinished:^(ZHBLEPeripheral *peripheral, NSError *error){
        weakSelf.connectedPeripheral = peripheral;
        [weakSelf deletePeripheralInFindDevice:peripheral];
        [weakSelf addPeripheralToConnectedDevice:peripheral];
       
        [peripheral.peripheral.services enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop){
            CBService *service = obj;
            NSLog(@"serviceUUID:%@",[service.UUID UUIDString]);
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Service UUID" message:[service.UUID UUIDString] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertView show];
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf pushWithPeripheral:peripheral];
            [self.tableView reloadData];
        });
    }onDisconnected:^(ZHBLEPeripheral *peripheral, NSError *error){
        [weakSelf deletePeripheralInConnectedDevice:peripheral];
        [ZHBLEStoredPeripherals deleteUUID:peripheral.identifier];
        NSString *errorString = [NSString stringWithFormat:@"%@",error];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Disconnected" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertView show];
            
        });
    }];
*/
}

#pragma mark - Push
-(void)pushWithPeripheral:(ZHBLEPeripheral *)peripheral {
    [self performSegueWithIdentifier:@"serviceViewController" sender:peripheral];
    
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    PeripheralserviceTableViewController *serviceVC = [segue destinationViewController];
    ZHBLEPeripheral *peripheral = (ZHBLEPeripheral*)sender;
    
    serviceVC.connectedPeripheral = peripheral;
    serviceVC.title = peripheral.name;
    
}


@end
