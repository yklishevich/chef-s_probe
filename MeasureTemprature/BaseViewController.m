//
//  BaseViewController.m
//  MeasureTemprature
//
//  Created by Akber Sayani on 17/11/2016.
//  Copyright © 2016 Akber Sayani. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if([[self.navigationController viewControllers] count] > 1){
        [self createBackButton];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createBackButton{
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"< Zurück"
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:@selector(backButtonClicked:)];
    
    
//    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [backButton setFrame:CGRectMake(0, 0, 60, 40)];
//    [backButton setTitle:@"Zurück" forState:UIControlStateNormal];
////    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0,0,0,0)];
////    [backButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
//    [backButton setImage:[UIImage imageNamed:@"imgBack"] forState:UIControlStateNormal];
//    [backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    backItem.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = backItem;
}

-(void)backButtonClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
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
