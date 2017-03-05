//
//  MeasuredTempratureViewController.m
//  MeasureTemprature
//
//  Created by Akber Sayani on 18/09/2016.
//  Copyright © 2016 Akber Sayani. All rights reserved.
//

#import "MeasuredTempratureViewController.h"
#import "ActionSheetPicker.h"
#import "Tempratures.h"
#import "TempratureConcrete.h"
#import "Constants.h"
#import "UtilitiesHelper.h"
#import "AppDelegate.h"
#import "UIImageView+AFNetworking.h"

@interface MeasuredTempratureViewController () <UIActionSheetDelegate, UITableViewDataSource, UITableViewDelegate>

@property(nonatomic,weak) IBOutlet UIView *tempratureView;
@property(nonatomic,weak) IBOutlet UILabel *lblDescription;
@property(nonatomic,weak) IBOutlet UIImageView *tempratureImageView;
@property(nonatomic,weak) IBOutlet UILabel *lblAertTemprature;
@property(nonatomic,weak) IBOutlet UILabel *lblDegreeTemprature;
@property(nonatomic,weak) IBOutlet UILabel *lblFahrenheitTemprature;
@property(nonatomic,weak) IBOutlet UILabel *lblAlertOff;

@property(nonatomic,strong) NSArray *tempratures;

@end

@implementation MeasuredTempratureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tempratureView.backgroundColor=[UIColor clearColor];
    self.tempratureView.layer.borderWidth=1.0;
    self.tempratureView.layer.borderColor=[UIColor blackColor].CGColor;
    self.tempratureView.layer.masksToBounds=YES;
    
    /* Change temprature notification */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedChangeTempratureNotification:)
                                                 name:NOTIFICATION_TEMPRATURE_CHANGED
                                               object:nil];
    
    [self getTempratures];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updateTempratureValues];
}

- (void)updateTempratureValues {
    
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    double tempratureInFahrenheit = (appdelegate.deviceTemprature * 1.8) + 32;
    self.lblDegreeTemprature.text = [NSString stringWithFormat:@"%.2f °C", appdelegate.deviceTemprature];
    self.lblFahrenheitTemprature.text = [NSString stringWithFormat:@"%.2f °F", tempratureInFahrenheit];
}

- (void)receivedChangeTempratureNotification:(NSNotification *)notification {
    
    [self updateTempratureValues];
}

- (void)getTempratures {
    [Tempratures getTemprature:@{@"action":kWebGetTempratures}
                 WithURLString:@""
                        onView:self.view
                      response:^(Tempratures *response, NSError *error) {
                          if (response) {
                              self.tempratures = response.hilife;
                              //[self.tableView reloadData];
                          }
                          else {
                              if (error) {
                                  [UtilitiesHelper showErrorAlert:error];
                              }
                          }
                      }];
}

- (void)addTemperatureValue {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Temperatur"
                                                                             message:@"Temperatur eingeben"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Temperatur in Grad";
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    
    UIAlertAction *addAction = [UIAlertAction actionWithTitle:@"Speichern" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

        UITextField *txtTemperature = alertController.textFields.firstObject;
        if ([UtilitiesHelper checkForEmptySpaces:txtTemperature]) {
            NSString *temperature = txtTemperature.text;
            
            appdelegate.thresholdTemprature = [temperature doubleValue];
            appdelegate.isAlertOff = NO;
            
            self.lblAlertOff.text = @"Alarm aus";
            self.lblAertTemprature.text = [NSString stringWithFormat:@"%@ °C", temperature];
            
            self.lblDescription.text = @"Benutzerdefinierte Temperatur";
            self.tempratureImageView.image = [UIImage imageNamed:@"imgTempraturePlaceholder"];
        }
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Abbrechen"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    [alertController addAction:addAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:NO completion:nil];
}

- (IBAction)onBtnSetAlarm:(id)sender {
    
    UIViewController *controller = [[UIViewController alloc] init];
    UITableView *alertTableView;
    CGRect rect;
    if (self.tempratures.count < 4) {
        rect = CGRectMake(0, 0, 280, 150);
        [controller setPreferredContentSize:rect.size];
        
    }
    else if (self.tempratures.count < 6){
        rect = CGRectMake(0, 0, 280, 200);
        [controller setPreferredContentSize:rect.size];
    }
    else {
        rect = CGRectMake(0, 0, 280, 250);
        [controller setPreferredContentSize:rect.size];
    }
    
    
    alertTableView = [[UITableView alloc]initWithFrame:rect];
    alertTableView.delegate = self;
    alertTableView.dataSource = self;
    alertTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    alertTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    alertTableView.userInteractionEnabled = YES;
    alertTableView.allowsSelection = YES;
    
    [controller.view addSubview:alertTableView];
    [controller.view bringSubviewToFront:alertTableView];
    [controller.view setUserInteractionEnabled:YES];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Wählen Sie Ihre Temperatur"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController setValue:controller forKey:@"contentViewController"];
    
    UIAlertAction *addAction = [UIAlertAction actionWithTitle:@"Eigene Temperatur eingeben"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          NSLog(@"Add Other value");
                                                          [self addTemperatureValue];
                                                      }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Abbrechen"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action) {
                                                                NSLog(@"User canncelled");
                                                         }];
    
    
    [alertController addAction:addAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)onBtnAlertOff:(id)sender {
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appdelegate.isAlertOff = !appdelegate.isAlertOff;
    self.lblAlertOff.text = (appdelegate.isAlertOff)?@"Alarm ein":@"Alarm aus";
    
    NSString *mesg = (appdelegate.isAlertOff)?@"Alarm ausschalten erfolgreich":@"Alarm ist erfolgreich aktiviert";
    [UtilitiesHelper showPromptAlertforTitle:@"Hinweis"
                                 withMessage:mesg
                                 forDelegate:nil];
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tempratures count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Identifier = @"TempratureCellIdentifier";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:Identifier];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    
    TempratureConcrete *objTemprature = [self.tempratures objectAtIndex:indexPath.row];
    cell.textLabel.text = objTemprature.descriptionText;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TempratureConcrete *objTemprature = [self.tempratures objectAtIndex:indexPath.row];
    
    [self dismissViewControllerAnimated:YES completion:^{
        // Updates values
        AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appdelegate.thresholdTemprature = [objTemprature.degree doubleValue];
        appdelegate.isAlertOff = NO;
        
        self.lblAlertOff.text = @"Alarm aus";
        self.lblAertTemprature.text = [NSString stringWithFormat:@"%@ °C", objTemprature.degree];
        self.lblDescription.text = objTemprature.descriptionText;
        [self.tempratureImageView setImageWithURL:[NSURL URLWithString:objTemprature.image]
                                 placeholderImage:[UIImage imageNamed:@"imgPlaceholder"]];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
