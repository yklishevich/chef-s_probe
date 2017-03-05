//
//  AddPhotoArchiveViewController.m
//  MeasureTemprature
//
//  Created by Akber Sayani on 19/09/2016.
//  Copyright © 2016 Akber Sayani. All rights reserved.
//

#import "AddPhotoArchiveViewController.h"
#import "UIPlaceHolderTextView.h"
#import "FDTakeController.h"
#import "UtilitiesHelper.h"
#import "ActionSheetPicker.h"
#import "PhotoArchive.h"
#import "AppDelegate.h"
#import "BaseSharedPreference.h"
#import "UIImage+OrientationFixed.h"

@interface AddPhotoArchiveViewController () <UITextFieldDelegate, FDTakeDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property(nonatomic,weak) IBOutlet UIImageView *tempratureImageView;
@property(nonatomic,weak) IBOutlet UIView *imagePlaceholderView;
@property(nonatomic,weak) IBOutlet UITextField *txtTemprature;
@property(nonatomic,weak) IBOutlet UITextField *txtDate;
@property(nonatomic,weak) IBOutlet UITextField *txtLocation;
@property(nonatomic,weak) IBOutlet UIPlaceHolderTextView *txtDescription;

@property NSString *tempratureValue;
@property NSString *saveImagePath;
@property UIImage *photo;
@property FDTakeController *takeController;

@end

@implementation AddPhotoArchiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.txtDescription.placeholder = @"Beschreibung";
    self.txtDescription.layer.cornerRadius = 4.0;
    self.txtDescription.layer.masksToBounds = YES;
    
    self.takeController = [[FDTakeController alloc] init];
    self.takeController.delegate = self;
    self.takeController.takePhotoText = @"Bild machen";
    self.takeController.chooseFromLibraryText = @"Aus Galerie wählen";
    self.takeController.cancelText = @"Abbrechen";
    self.takeController.allowsEditingPhoto = NO;
    
    self.txtTemprature.enabled = NO;
    self.txtDate.enabled = NO;
    
    [self setCurrentDateTime];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setCurrentDateTime {
    NSDate *date = [NSDate date];
    
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    [dateformater setDateFormat:@"dd.MM.yyyy HH:mm:ss"];
    self.txtDate.text = [dateformater stringFromDate:date];
}

- (void)setCurrentTemprature {
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.txtTemprature.text = [NSString stringWithFormat:@"%.2f C", appdelegate.deviceTemprature];
    
    self.tempratureValue = [NSString stringWithFormat:@"%.2f", appdelegate.deviceTemprature];
}

- (void)showDatePicker {
    [ActionSheetDatePicker showPickerWithTitle:@"Select date"
                                datePickerMode:UIDatePickerModeDateAndTime
                                  selectedDate:[NSDate date]
                                     doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
                                         NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
                                         [dateformater setDateFormat:@"dd.MM.yyyy HH:mm:ss"];
                                         self.txtDate.text = [dateformater stringFromDate:(NSDate *)selectedDate];
                                     }
                                   cancelBlock:^(ActionSheetDatePicker *picker) {
                                       NSLog(@"Cancel date selection");
                                   } origin:self.view];
}

- (NSString *)saveImage:(UIImage *)image {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filename = [NSString stringWithFormat:@"%f.png",[[NSDate date] timeIntervalSince1970]];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:filename];
    NSData* data = UIImagePNGRepresentation(image);
    [data writeToFile:path atomically:YES];
    
    return path;
}

- (IBAction)onBtnTakePhoto:(id)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:nil];
    
//    [self.takeController takePhotoOrChooseFromLibrary];
//    [self.takeController takePhotoOrChooseFromLibrary];
}

- (IBAction)onBtnSave:(id)sender {
    if ([UtilitiesHelper checkForEmptySpacesInString:self.tempratureValue]
        && [UtilitiesHelper checkForEmptySpaces:self.txtDate]) {
        
        if (self.photo) {
            
            NSString *text = [NSString stringWithFormat:@"Temperatur: %@\nDatum: %@\nLocation: %@\nBeschreibung: %@", self.tempratureValue, self.txtDate.text, self.txtLocation.text, self.txtDescription.text];
            
            //Add text on image
            UIImage *imageWithText = [UtilitiesHelper drawText:text inImage:self.photo];
            
            //Saved Image to photo album
            UIImageWriteToSavedPhotosAlbum(imageWithText, nil, nil, nil);
            
            NSString *path = [self saveImage:imageWithText];
            
            // Save photo in photoarchive
            PhotoArchive *photoArchive = [[PhotoArchive alloc] init];
            photoArchive.imagePath = path;
            photoArchive.temprature = self.tempratureValue;
            photoArchive.date = self.txtDate.text;
            photoArchive.location = self.txtLocation.text;
            photoArchive.details = self.txtDescription.text;
            
            [[BaseSharedPreference sharedInstance] savePhotoArchive:photoArchive];
            
            [UtilitiesHelper showPromptAlertforTitle:@"Hinweis"
                                         withMessage:@"Foto zum Archiv hinzugefügt" forDelegate:nil];
        }
        else {
            [UtilitiesHelper showPromptAlertforTitle:@"Hinweis"
                                         withMessage:@"Bitte addieren Sie ein Foto" forDelegate:nil];
        }
    }
    else {
        [UtilitiesHelper showPromptAlertforTitle:@"Hinweis"
                                     withMessage:@"Erforderliche Angaben nicht angegeben" forDelegate:nil];
    }
}

#pragma mark - FDTakeDelegate

- (void)takeController:(FDTakeController *)controller didCancelAfterAttempting:(BOOL)madeAttempt {
    if (madeAttempt) {
        NSLog(@"The take was cancelled after selecting media");
    } else {
        NSLog(@"The take was cancelled without selecting media");
    }
}

- (void)takeController:(FDTakeController *)controller gotPhoto:(UIImage *)photo withInfo:(NSDictionary *)info {
    
    photo = [photo normalizedImage];
    
    [self.tempratureImageView setImage:photo];
    self.imagePlaceholderView.hidden = YES;

    self.photo = photo;

    [self setCurrentTemprature];
}

#pragma mark - UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    chosenImage = [chosenImage normalizedImage];
    
    [self.tempratureImageView setImage:chosenImage];
    self.imagePlaceholderView.hidden = YES;

    self.photo = chosenImage;
    
    [self setCurrentTemprature];

    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if ([textField isEqual:self.txtDate]) {        
        [self.view endEditing:YES];
        [self showDatePicker];
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
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
