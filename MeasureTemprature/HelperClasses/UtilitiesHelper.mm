
//  UtilitiesHelper.m
//  InstaFlip
//
//  Created by Muhammad Waqas Khalid on 8/29/13.
//
//

#import "UtilitiesHelper.h"
#import "DecodeUtils.hpp"
#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>

@implementation UtilitiesHelper

+ (void)showLoader:(NSString *)title forView:(UIView *)view  setMode:(MBProgressHUDMode)mode delegate:(id)vwDelegate
{
    if(view == nil) return;
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    [progressHUD setMode:mode];
    [progressHUD setDimBackground:YES];
    [progressHUD setLabelText:title];
    [progressHUD setMinShowTime:1.0];
}

+ (void)showCustomLoaderView:(UIView *)customView onView:(UIView *)view WithTitle:(NSString *)title
{
    if(view == nil) return;
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    [progressHUD setCustomView:customView];
    [progressHUD setMode:MBProgressHUDModeCustomView];
    [progressHUD setLabelText:title];
    [progressHUD setDimBackground:YES];
    //    [progressHUD setMinShowTime:1.0];
}

+ (void)hideLoader:(UIView *)forView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideAllHUDsForView:forView animated:YES];
    });
}

+ (BOOL)checkForEmptySpaces:(UITextField *)textField  {
    
    NSString *rawString = textField.text;
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmed = [rawString stringByTrimmingCharactersInSet:whitespace];
    if ([trimmed length] == 0) {
        textField.text = @"";
        return NO;
    }
    
    return YES;
}

+ (BOOL)checkForEmptySpacesInString:(NSString *)rawString {
    
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmed = [rawString stringByTrimmingCharactersInSet:whitespace];
    if ([trimmed length] == 0) {
        return NO;
    }
    return YES;
    
}

+ (BOOL)checkForEmptySpacesInTextView:(UITextView *)textView {

    NSString *rawString = textView.text;
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmed = [rawString stringByTrimmingCharactersInSet:whitespace];
    if ([trimmed length] == 0) {
        textView.text = @"";
        return NO;
    }
    return YES;
}

+ (void)showTextInputAlertforTitle:(NSString *)title withMessage:(NSString *)message forDelegate:(id)deleg {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:deleg cancelButtonTitle:@"OK" otherButtonTitles:nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];
}

+ (void)showPromptAlertforTitle:(NSString *)title withMessage:(NSString *)message forDelegate:(id)deleg {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:deleg cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alertView show];
}

+ (void)showConformationPromptAlertforTitle:(NSString *)title withMessage:(NSString *)message forDelegate:(id)deleg {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:deleg cancelButtonTitle:@"NO" otherButtonTitles:@"YES",nil];
    
    [alertView show];
}

+ (void)showErrorAlert:(NSError *)error {
    
    [UtilitiesHelper showPromptAlertforTitle:@"Error"
                                 withMessage:[error localizedDescription]
                                 forDelegate:nil];
}

+ (BOOL)validateEmail:(NSString *)checkEmail {
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkEmail];
}

+ (BOOL)validateFullName:(NSString *)checkFullName {
    NSString *regex = @"[a-zA-Z]{2,}+(\\s{1}[a-zA-Z]{2,}+)+";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:checkFullName];
}

+ (BOOL)checkAlphabets:(NSString *)text {
    NSString *regex = @"[a-zA-Z][a-zA-Z ]+";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:text];
}

+ (BOOL)checkFaxNumber:(NSString *)text {
    NSString *regex = @"^[0-9\\-\\+]{6,12}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:text];
}

+ (BOOL)checkPhoneNumber:(NSString *)text {
    NSString *regex = @"^[0-9\\-\\+]{9,15}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:text];
}

+ (BOOL)checkPassword:(NSString *)text {
    NSString *regex = @"^\\w*(?=\\w*\\d)(?=\\w*[a-z])(?=\\w*[A-Z])\\w*$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:text];
}

+ (BOOL)isReachable {

//    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
//    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
//    if (networkStatus == NotReachable) {
//        
//         [UtilitiesHelper showPromptAlertforTitle:@"Message"
//                                      withMessage:@"Please check your network connection and try again."
//                                      forDelegate:nil];
//        return NO;
//        
//    } else {
//        
//        return YES;
//    }
    
    return YES;
}

+ (void)setExclusiveTouchToChildrenOf:(NSArray *)subviews {
    for (UIView *v in subviews) {
        [self setExclusiveTouchToChildrenOf:v.subviews];
        if ([v isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)v;
            [btn setExclusiveTouch:YES];
        }
        else if ([v isKindOfClass:[UICollectionViewCell class]]) {
            [v setExclusiveTouch:YES];
        }
        else {
            [v setExclusiveTouch:YES];
        }
        
    }
}

+ (void)writeJsonToFile:(id)responseString withFileName:(NSString*)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, fileName];
    NSLog(@"filePath %@", filePath);
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) { // if file is not exist, create it.
        NSError *error;
        [responseString writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
        
    }
    else
    {
        NSError *error;
        [[NSFileManager defaultManager] removeItemAtPath: filePath error: &error];
        
        [responseString writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    }
    
}

+ (id)readJsonFromFile:(NSString*)fileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:fileName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:myPathDocs])
    {
        return NULL;
    }
    
    //Load from File
    NSString *myString = [[NSString alloc] initWithContentsOfFile:myPathDocs encoding:NSUTF8StringEncoding error:NULL];
    NSLog(@"string ===> %@",myString);
    return myString;
}

+ (NSString*)getNumbersFromString:(NSString*)String {
    
    NSArray* Array = [String componentsSeparatedByCharactersInSet:
                      [[NSCharacterSet decimalDigitCharacterSet] invertedSet]];
    
    NSString* returnString = [Array componentsJoinedByString:@""];
    
    return (returnString);
}

+ (UIImage*)drawText:(NSString*)text inImage:(UIImage*)image{
    
    UIFont *font = [UIFont boldSystemFontOfSize:80.0];
    UIColor *textColor = [UIColor whiteColor];
    NSDictionary *attr = @{NSForegroundColorAttributeName:textColor, NSFontAttributeName:font};
    CGSize textSize = [text sizeWithAttributes:attr];
    
    //CGRect textRect = CGRectMake(imageSize.width - textSize.width - paddingX, imageSize.height - textSize.height - paddingY, textSize.width, textSize.height);
    
    // Create the image
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0,0,image.size.width,image.size.height)];
    CGRect rect = CGRectMake(0, image.size.height - textSize.height,
                             textSize.width, textSize.height);
    [[UIColor colorWithWhite:0 alpha:0.7] set];
    CGContextFillRect(UIGraphicsGetCurrentContext(),
                      CGRectMake(rect.origin.x, rect.origin.y, image.size.width, textSize.height));
    if([text respondsToSelector:@selector(drawInRect:withAttributes:)]) {
        //iOS 7+
        [text drawInRect:rect withAttributes:attr];
    }
    else {
        //legacy support
        [[UIColor whiteColor] set];
        [text drawInRect:CGRectIntegral(rect) withFont:font];
    }
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (double)getTempratureFromAdvertisementData:(NSDictionary *)advertisementData {
    NSData *manufacturerData = [advertisementData objectForKey:@"kCBAdvDataManufacturerData"];
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

+ (BOOL)isInternetConnected {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    
    return networkStatus != NotReachable;
}


@end

