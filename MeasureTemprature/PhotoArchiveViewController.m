//
//  PhotoArchiveViewController.m
//  MeasureTemprature
//
//  Created by Akber Sayani on 19/09/2016.
//  Copyright © 2016 Akber Sayani. All rights reserved.
//

#import "PhotoArchiveViewController.h"
#import "PhotoArchiveViewCell.h"
#import "BaseSharedPreference.h"
#import "PhotoArchive.h"
#import "PhotoArchiveDetailsViewController.h"

@interface PhotoArchiveViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,weak) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *photoArchives;

@end

@implementation PhotoArchiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.tableView setContentInset:UIEdgeInsetsMake(20, 0, 0, 0)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.photoArchives = [NSMutableArray arrayWithArray:[[BaseSharedPreference sharedInstance] getPhotoArchives]];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBtnTakeNewPhoto:(id)sender {
    [self performSegueWithIdentifier:@"pushToAddPhotoArchiveSegue" sender:self];    
}

//PhotoArchiveCellIdentifier
#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.photoArchives count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PhotoArchiveViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoArchiveCellIdentifier"];
    cell.backgroundColor = [UIColor clearColor]; // IPAD fixed
    cell.containerView.backgroundColor = [UIColor clearColor];
    if (indexPath.row % 2) { // For odd index
        cell.containerView.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0
                                                             alpha:1.0];
    }
    
    PhotoArchive *photoarchive = [self.photoArchives objectAtIndex:indexPath.row];
    
    double temperatureInDegree = [photoarchive.temprature doubleValue];
    double temperatureInFahrenheit = (temperatureInDegree * 1.8) + 32;
    
    //cell.tempratureImageView.image = [UIImage imageWithContentsOfFile:photoarchive.imagePath];
    [cell loadImageFromPath:photoarchive.imagePath];
    
    cell.lblTemprature.text = [NSString stringWithFormat:@"%.f °C / %.f °F",
                               temperatureInDegree, temperatureInFahrenheit];
    cell.lblDate.text = [NSString stringWithFormat:@"Vom %@", photoarchive.date];
    cell.lblLocation.text = [NSString stringWithFormat:@"Location: %@", photoarchive.location];
    cell.lblDescription.text = photoarchive.details;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"pushToPhotoArchiveDetailSegue" sender:indexPath];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //remove the deleted object from your data source
        [self.photoArchives removeObjectAtIndex:indexPath.row];
        
        //Update photoarchive basepreference
        [[BaseSharedPreference sharedInstance] updatPhotoAchives:self.photoArchives];
        
        [tableView reloadData];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"pushToPhotoArchiveDetailSegue"]) {
        NSIndexPath *indexPath = (NSIndexPath *)sender;
        PhotoArchive *photoarchive = [self.photoArchives objectAtIndex:indexPath.row];
        PhotoArchiveDetailsViewController *controller = [segue destinationViewController];
        controller.photoarchive = photoarchive;
    }
}

@end
