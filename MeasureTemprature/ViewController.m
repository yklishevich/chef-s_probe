//
//  ViewController.m
//  MeasureTemprature
//
//  Created by Akber Sayani on 15/09/2016.
//  Copyright © 2016 Akber Sayani. All rights reserved.
//

#import "ViewController.h"
#import "ServiceModel.h"
#import "Constants.h"
#import "UtilitiesHelper.h"
#import "AppDelegate.h"
#import "BLEScan.h"
#import "CZPickerView.h"
#import "MeasuredTempratureViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "UIImageView+AFNetworking.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource,
CZPickerViewDataSource, CZPickerViewDelegate> {
    
    NSUInteger userSelection;
}

@property(nonatomic,weak) IBOutlet UIImageView *imageView;
@property(nonatomic,weak) IBOutlet UILabel *lblText;
@property(nonatomic,strong) CZPickerView *devicePickerView;
@property(nonatomic,strong) NSArray *findDeviceArray;

//@property(nonatomic,strong) UITableView *tableViewScanDevices;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton* drawerButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,24,24)];
    [drawerButton setImage:[UIImage imageNamed:@"imgSideMenu"] forState:UIControlStateNormal];
    [drawerButton addTarget:self action:@selector(drawerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    drawerButton.exclusiveTouch = YES;
    
    UIBarButtonItem *drawerButtonItem = [[UIBarButtonItem alloc] initWithCustomView:drawerButton];
    self.navigationItem.leftBarButtonItem = drawerButtonItem;
    
    self.findDeviceArray = [[NSArray alloc] init];
    
    /* Initialize scan devices tableview */
//    self.tableViewScanDevices = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 280, 240)];
//    self.tableViewScanDevices.delegate = self;
//    self.tableViewScanDevices.dataSource = self;
//    self.tableViewScanDevices.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
//    self.tableViewScanDevices.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    self.tableViewScanDevices.userInteractionEnabled = YES;
//    self.tableViewScanDevices.allowsSelection = YES;
    
//    self.objScanner = [BLEScan sharedInstance];
//    [self.objScanner initScanConfiguration];
//    [self.objScanner startDummyScan];
    
    [[BLEScan sharedInstance] initScanConfiguration];
    //[[BLEScan sharedInstance] startDummyScan];
    
    /* Device found notification */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedDeviceFoundNotification:)
                                                 name:NOTIFICATION_DEVICE_FOUND
                                               object:nil];
    [self getImageAndText];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appdelegate.deviceTemprature == 0) {
        [self onShowDeviceList];
    }    
}

- (void)getImageAndText {
    [[ServiceModel sharedClient] POST:@""
                           parameters:@{@"action":kWebGetStartScreen}
                               onView:self.view
                              success:^(NSURLSessionDataTask *task, id responseObject) {
                                  
                                  if ([responseObject objectForKey:@"startscreen"]) {
                                      id objStartScreen = [responseObject objectForKey:@"startscreen"];
                                      
                                      if ([objStartScreen objectForKey:@"text"]) {
                                          self.lblText.text = [objStartScreen objectForKey:@"text"];
                                      }
                                      
                                      if ([objStartScreen objectForKey:@"image"]) {
                                          [self.imageView setImageWithURL:[NSURL URLWithString:
                                                                           [objStartScreen objectForKey:@"image"]]];
                                      }
                                  }
                                  
                              } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                  
                                  [UtilitiesHelper showErrorAlert:error];
                              }];
}

- (void)drawerButtonClicked:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)receivedDeviceFoundNotification:(NSNotification *)notification {
    //Scan device tableview reload.
    BLEScan *objScanner = [BLEScan sharedInstance];
    
    if (objScanner) {
        self.findDeviceArray = objScanner.findDeviceArray;
        [_devicePickerView reloadData];
        
        //[self.tableViewScanDevices reloadData];
    }
}

- (void)onShowDeviceList {
    _devicePickerView = [[CZPickerView alloc] initWithHeaderTitle:@"Messgerät wählen"
                                                cancelButtonTitle:@"Abbrechen" confirmButtonTitle:@"bestätigen"];
    _devicePickerView.delegate = self;
    _devicePickerView.dataSource = self;
    _devicePickerView.needFooterView = YES;
    
    [_devicePickerView show];
    
//    UIViewController *controller = [[UIViewController alloc] init];
//    [controller.view addSubview:self.tableViewScanDevices];
//    [controller.view bringSubviewToFront:self.tableViewScanDevices];
//    [controller.view setUserInteractionEnabled:YES];
//    [controller setPreferredContentSize:self.tableViewScanDevices.frame.size];
//    
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Messgerät wählen"
//                                                                             message:nil
//                                                                      preferredStyle:UIAlertControllerStyleAlert];
//    
//    [alertController setValue:controller forKey:@"contentViewController"];
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Abbrechen"
//                                                           style:UIAlertActionStyleCancel
//                                                         handler:^(UIAlertAction *action) {
//                                                             NSLog(@"User canncelled");
//                                                         }];
//    [alertController addAction:cancelAction];
//    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)onBtnGetTemprature:(id)sender {
    userSelection = 1;
    
    [self performSegueWithIdentifier:@"pushToMeasuredTempratureSegue" sender:nil];
}

- (IBAction)onBtnPhotoArchive:(id)sender {
    userSelection = 2;
    
    [self performSegueWithIdentifier:@"pushToPhotoArchiveSegue" sender:self];
}

#pragma mark - CZPickerView Delegate

- (NSString *)czpickerView:(CZPickerView *)pickerView titleForRow:(NSInteger)row{
    ZHBLEPeripheral *peripherial = [self.findDeviceArray objectAtIndex:row];
    
    NSString *deviceName = @"";
    if (peripherial) {
        deviceName = peripherial.name;
    }

    return deviceName;
}

- (UIImage *)czpickerView:(CZPickerView *)pickerView imageForRow:(NSInteger)row {
    return nil;
}

- (NSInteger)numberOfRowsInPickerView:(CZPickerView *)pickerView {
    return self.findDeviceArray.count;
}

- (void)czpickerView:(CZPickerView *)pickerView didConfirmWithItemAtRow:(NSInteger)row {
    ZHBLEPeripheral *peripherial = [self.findDeviceArray objectAtIndex:row];
    if (peripherial) {
        if (peripherial.advertisementData) {
            double temprature = [UtilitiesHelper getTempratureFromAdvertisementData:peripherial.advertisementData];
            
            AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            appdelegate.deviceTemprature = temprature;
            
            BLEScan *bleScan = [BLEScan sharedInstance];
            bleScan.connectedDevice = peripherial;
        }
        else {
            [UtilitiesHelper showPromptAlertforTitle:@"Error"
                                         withMessage:@"Advertisement data not found"
                                         forDelegate:nil];
        }
    }
}

- (void)czpickerView:(CZPickerView *)pickerView didConfirmWithItemsAtRows:(NSArray *)rows {
    for (NSNumber *n in rows) {
        NSInteger row = [n integerValue];
        NSLog(@"%@ is chosen!", self.findDeviceArray[row]);
    }
}

- (void)czpickerViewDidClickCancelButton:(CZPickerView *)pickerView {
    //[self.navigationController setNavigationBarHidden:YES];
    NSLog(@"Canceled.");
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.findDeviceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:bleCellIdentifier forIndexPath:indexPath];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:@"DEVICECELLIDENTIFIER"];

    ZHBLEPeripheral *peripherial = [self.findDeviceArray objectAtIndex:indexPath.row];
    if (peripherial) {
        cell.textLabel.text = peripherial.name;
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

#pragma mark - tableview Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    ZHBLEPeripheral *peripherial = [self.findDeviceArray objectAtIndex:indexPath.row];
    if (peripherial) {
        if (peripherial.advertisementData) {
            [self dismissViewControllerAnimated:NO completion:^{
                double temprature = [UtilitiesHelper getTempratureFromAdvertisementData:peripherial.advertisementData];
                
                AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                appdelegate.deviceTemprature = temprature;
                
                BLEScan *bleScan = [BLEScan sharedInstance];
                bleScan.connectedDevice = peripherial;
            }];
        }
        else {
            [UtilitiesHelper showPromptAlertforTitle:@"Error"
                                         withMessage:@"Advertisement data not found"
                                         forDelegate:nil];
        }
    }
}

 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"pushToMeasuredTempratureSegue"]) {
//        
//        MeasuredTempratureViewController *controller = [segue destinationViewController];
//        if (sender) {
//            NSNumber *temprature = (NSNumber *)sender;
//            controller.temprature = temprature.doubleValue;
//        }
//    }
}


@end
