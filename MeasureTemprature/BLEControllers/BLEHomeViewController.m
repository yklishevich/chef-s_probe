//
//  BLEHomeViewController.m
//  MeasureTemprature
//
//  Created by Akber Sayani on 25/09/2016.
//  Copyright © 2016 Akber Sayani. All rights reserved.
//

#import "BLEHomeViewController.h"
#import "Constants.h"

@implementation BLEHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.tableFooterView = [UIView new];
    self.title = @"BLE Scanner";
    
    /* Create left barbutton */
    UIBarButtonItem *closeBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Close"
                                                                     style:UIBarButtonItemStyleDone
                                                                    target:self
                                                                    action:@selector(onClose:)];
    self.navigationItem.leftBarButtonItem = closeBarItem;
    
    /* Create right barbutton */
    UIBarButtonItem *skipBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Skip"
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(onSkip:)];
    self.navigationItem.rightBarButtonItem = skipBarItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onSkip:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TEMPRATRURE_RECEIVED
                                                        object:self];
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
