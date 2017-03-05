//
//  UtilitiesHelper.h
//  VotoMessenger
//
//  Created by Muhammad Waqas Khalid on 8/29/13.
//
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface UtilitiesHelper : NSObject {
}

+(void)showLoader:(NSString *)title forView:(UIView *)view  setMode:(MBProgressHUDMode)mode delegate:(id)vwDelegate;
+(void)showCustomLoaderView:(UIView *)customView onView:(UIView *)view WithTitle:(NSString *)title;
+(void)hideLoader:(UIView *)forView;

+(BOOL)isReachable;

+(void)showErrorAlert:(NSError *) error;
+(void)showPromptAlertforTitle:(NSString *)title withMessage:(NSString *)message forDelegate:(id)deleg;
+(void)showTextInputAlertforTitle:(NSString *)title withMessage:(NSString *)message forDelegate:(id)deleg;
+(void)showConformationPromptAlertforTitle:(NSString *)title withMessage:(NSString *)message forDelegate:(id)deleg;

+(BOOL)validateEmail:(NSString *)checkEmail;
+(BOOL)checkForEmptySpaces:(UITextField *)textField;
+(BOOL)validateFullName:(NSString *)checkFullName;
+(BOOL)checkForEmptySpacesInTextView : (UITextView *)textView;
+(BOOL)checkAlphabets:(NSString *)text;
+(BOOL)checkForEmptySpacesInString : (NSString *)rawString;
+(BOOL)checkPassword:(NSString *)text;
+(BOOL)checkPhoneNumber:(NSString *)text;
+(BOOL)checkFaxNumber:(NSString *)text;

+(void)setExclusiveTouchToChildrenOf:(NSArray *)subviews;

+(void)writeJsonToFile:(id)responseString withFileName:(NSString*)fileName;
+(id)readJsonFromFile:(NSString*)fileName;

+(NSString*)getNumbersFromString:(NSString*)String;
+(UIImage*)drawText:(NSString*)text inImage:(UIImage*)image;

+ (double)getTempratureFromAdvertisementData:(NSDictionary *)advertisementData;

+ (BOOL)isInternetConnected;

@end

