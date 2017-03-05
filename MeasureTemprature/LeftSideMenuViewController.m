//
//  LeftSideMenuViewController.m
//  MeasureTemprature
//
//  Created by Akber Sayani on 15/09/2016.
//  Copyright © 2016 Akber Sayani. All rights reserved.
//

#import "LeftSideMenuViewController.h"
#import "LeftSideMenuViewCell.h"
#import "UIViewController+MMDrawerController.h"
#import "ViewController.h"
#import "MeasuredTempratureViewController.h"
#import "PhotoArchiveViewController.h"
#import "AboutUsViewController.h"
#import "HelpViewController.h"
#import "AppDelegate.h"
#import "Constants.h"

@interface LeftSideMenuViewController () <UITableViewDataSource, UITableViewDelegate> {
    NSUInteger userSelection;
}

@property(nonatomic,weak) IBOutlet UITableView *tableView;

@property(nonatomic,strong) NSArray *arrItems;
@property(nonatomic,strong) NSArray *arrImages;

@end

@implementation LeftSideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.arrItems = [NSArray arrayWithObjects:
                     @"Start",
                     @"Temperatur",
                     @"Wareneingangskontrolle",
                     @"Anleitung",
                     @"Zubehör",
                     @"Verkaufsstellen",
                     @"Videos",
                     @"Website",
                     @"Impressum", nil];
    
    self.arrImages = [NSArray arrayWithObjects:
                      @"imgSidebarHomeIcon",
                      @"imgSidebarTempratureIcon",
                      @"imgSidebarCameraIcon",
                      @"imgSidebarAnleitungIcon",
                      @"imgSidebarVersionenIcon",
                      @"imgSidebarVerkaufsstellenIcon",
                      @"imgSidebarHelpIcon",
                      @"imgSidebarWebsiteIcon",
                      @"imgSidebarInfoIcon", nil];
    
    [self.tableView setContentInset:UIEdgeInsetsMake(24.0, 0, 0, 0)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LeftSideMenuViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LeftSideMenuCellIdentifier"];
    cell.backgroundColor = [UIColor clearColor];
    cell.sideImageView.image = [UIImage imageNamed:[self.arrImages objectAtIndex:indexPath.row]];
    cell.lblTitle.text = [self.arrItems objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIStoryboard* storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    UINavigationController *navController = (UINavigationController *)self.mm_drawerController.centerViewController;
    
    if (indexPath.row == 0) {
        if (![navController.topViewController isKindOfClass:[ViewController class]]) {
            ViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
            [self.mm_drawerController setCenterViewController:[[UINavigationController alloc]
                                                               initWithRootViewController:controller]];
        }
    }
    else if (indexPath.row == 1) {
        //MeasuredTempratureViewController
        UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"MeasuredTempratureViewController"];
        
        [navController pushViewController:controller animated:YES];
    }
    else if (indexPath.row == 2) {
        //PhotoArchiveViewController
        UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"PhotoArchiveViewController"];
        
        [navController pushViewController:controller animated:YES];
    }
    else if (indexPath.row == 3) {
        HelpViewController *controller = [storyboard
                                        instantiateViewControllerWithIdentifier:@"HelpViewController"];
        
        controller.contentType = kLoadPDF;
        [navController pushViewController:controller animated:YES];
    }
    else if (indexPath.row == 4) {
        AboutUsViewController *controller = [storyboard
                                             instantiateViewControllerWithIdentifier:@"AboutUsViewController"];
        
        controller.webContentType = kLoadVersionen;
        [navController pushViewController:controller animated:YES];
    }
    else if (indexPath.row == 5) {
        AboutUsViewController *controller = [storyboard
                                             instantiateViewControllerWithIdentifier:@"AboutUsViewController"];
        
        controller.webContentType = kLoadVerkaufsstellen;
        [navController pushViewController:controller animated:YES];
    }
    else if (indexPath.row == 6) {
        HelpViewController *controller = [storyboard
                                        instantiateViewControllerWithIdentifier:@"HelpViewController"];
        
        controller.contentType = kLoadVideo;
        [navController pushViewController:controller animated:YES];
    }
    else if (indexPath.row == 7) {
        AboutUsViewController *controller = [storyboard
                                             instantiateViewControllerWithIdentifier:@"AboutUsViewController"];
        
        controller.webContentType = kLoadFromURL;
        controller.loadURL = kWebsiteUrl;
        [navController pushViewController:controller animated:YES];
    }
    else if (indexPath.row == 8) {
        AboutUsViewController *controller = [storyboard
                                             instantiateViewControllerWithIdentifier:@"AboutUsViewController"];

        controller.webContentType = kLoadAboutUs;
        [navController pushViewController:controller animated:YES];
    }

    [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
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
