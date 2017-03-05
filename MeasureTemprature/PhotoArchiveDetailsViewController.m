//
//  PhotoArchiveDetailsViewController.m
//  MeasureTemprature
//
//  Created by Akber Sayani on 19/09/2016.
//  Copyright © 2016 Akber Sayani. All rights reserved.
//

#import "PhotoArchiveDetailsViewController.h"
#import <MessageUI/MessageUI.h>

@interface PhotoArchiveDetailsViewController () <MFMailComposeViewControllerDelegate>

@property(nonatomic,weak) IBOutlet UIImageView *tempratureImageView;
@property(nonatomic,weak) IBOutlet UILabel *lblTemprature;
@property(nonatomic,weak) IBOutlet UILabel *lblDate;
@property(nonatomic,weak) IBOutlet UILabel *lblLocation;
@property(nonatomic,weak) IBOutlet UILabel *lblDescription;


@end

@implementation PhotoArchiveDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.photoarchive) {
        
        double temperatureInDegree = [self.photoarchive.temprature doubleValue];
        double temperatureInFahrenheit = (temperatureInDegree * 1.8) + 32;
        
        [self.tempratureImageView setImage:[UIImage imageWithContentsOfFile:self.photoarchive.imagePath]];
        
        [self.lblTemprature setText:[NSString stringWithFormat:@"%.f C / %.f F",
                                     temperatureInDegree, temperatureInFahrenheit]];
        [self.lblDate setText:[NSString stringWithFormat:@"Vom %@", self.photoarchive.date]];
        [self.lblLocation setText:[NSString stringWithFormat:@"Location: %@", self.photoarchive.location]];
        [self.lblDescription setText:self.photoarchive.details];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBtnTakeNewPhoto:(id)sender {
    [self performSegueWithIdentifier:@"pushToAddPhotoArchiveSegue" sender:self];
}

- (IBAction)onBtnSendEmail:(id)sender {
    NSString *emailTitle = @"Measure temprature";
    NSString *messageBody = [NSString stringWithFormat:@"Temperatur: %@\nDatum: %@\nLocation: %@\nBeschreibung: %@", self.lblTemprature.text, self.lblDate.text, self.lblLocation.text, self.lblDescription.text];
    NSArray *toRecipents = [NSArray arrayWithObject:@"support@test.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
//    NSString *filePath = self.photoarchive?self.photoarchive.imagePath:[[NSBundle mainBundle] pathForResource:@"imgHardware" ofType:@"png"];
    
    //    // Determine the file name and extension
    //    NSArray *filepart = [file componentsSeparatedByString:@"."];
    //    NSString *filename = [filepart objectAtIndex:0];
    //    NSString *extension = [filepart objectAtIndex:1];
    
    // Get the resource path and read the file using NSData
    //    NSString *filePath = [[NSBundle mainBundle] pathForResource:filename ofType:extension];
    //NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    
    NSData *fileData = UIImagePNGRepresentation(self.tempratureImageView.image);
    
    // Determine the MIME type
    NSString *mimeType = @"image/png";
    //    if ([extension isEqualToString:@"jpg"]) {
    //        mimeType = @"image/jpeg";
    //    } else if ([extension isEqualToString:@"png"]) {
    //        mimeType = @"image/png";
    //    } else if ([extension isEqualToString:@"doc"]) {
    //        mimeType = @"application/msword";
    //    } else if ([extension isEqualToString:@"ppt"]) {
    //        mimeType = @"application/vnd.ms-powerpoint";
    //    } else if ([extension isEqualToString:@"html"]) {
    //        mimeType = @"text/html";
    //    } else if ([extension isEqualToString:@"pdf"]) {
    //        mimeType = @"application/pdf";
    //    }
    
    // Add attachment
    [mc addAttachmentData:fileData mimeType:mimeType fileName:@"Photoarchive"];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
}

#pragma mark - MFMailComposeViewController

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
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
