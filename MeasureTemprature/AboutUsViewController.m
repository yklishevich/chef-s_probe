//
//  AboutUsViewController.m
//  MeasureTemprature
//
//  Created by Akber Sayani on 24/09/2016.
//  Copyright © 2016 Akber Sayani. All rights reserved.
//

#import "AboutUsViewController.h"
#import "ServiceModel.h"
#import "Constants.h"
#import "UtilitiesHelper.h"
#import "Versionen.h"
#import "VersionenConcrete.h"
#import "AboutUs.h"
#import "AboutUsConcrete.h"

@interface AboutUsViewController () <UIWebViewDelegate>

@property(nonatomic,weak) IBOutlet UIWebView *webview;

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.webContentType == kLoadFromURL) {
        if ([UtilitiesHelper checkForEmptySpacesInString:self.loadURL]) {
            NSString *escapeURL = [self.loadURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:escapeURL]]];
        }
    } else
        if (self.webContentType == kLoadAboutUs) {
            [self getAboutUsHTML];
            
        } else
            if (self.webContentType == kLoadVersionen) {
                [self getVersionenHTML];
                
            } else
                if (self.webContentType == kLoadVerkaufsstellen) {
                    [self getVerkaufsstellenHTML];
                }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getAboutUsHTML {
    
    [AboutUs getAboutUs:@{@"action":kWebGetAboutUs}
          WithURLString:@""
                 onView:self.view
               response:^(AboutUs *response, NSError *error) {
                   if (response) {
                       
                       AboutUsConcrete *objAboutUs = response.aboutus;
                       [self.webview loadHTMLString:objAboutUs.text baseURL:nil];
                       
                   } else
                       if (error) {
                           [UtilitiesHelper showErrorAlert:error];
                       }
               }];
}

- (void)getVersionenHTML {
    
    [Versionen getVersionen:@{@"action":kWebGetVersionen}
              WithURLString:@""
                     onView:self.view
                   response:^(Versionen *response, NSError *error) {
                       if (response) {
                           if ([response.hilife count] > 0) {
                               
                               VersionenConcrete *objVersionen = [response.hilife firstObject];
                               [self.webview loadHTMLString:objVersionen.text baseURL:nil];
                           }
                       } else
                           if (error) {
                               [UtilitiesHelper showErrorAlert:error];
                           }
                   }];
}

- (void)getVerkaufsstellenHTML {
    
    [Versionen getVersionen:@{@"action":kWebGetVerkaufsstellen}
              WithURLString:@""
                     onView:self.view
                   response:^(Versionen *response, NSError *error) {
                       if (response) {
                           if ([response.hilife count] > 0) {
                               
                               VersionenConcrete *objVersionen = [response.hilife firstObject];
                               [self.webview loadHTMLString:objVersionen.text baseURL:nil];
                           }
                       } else
                           if (error) {
                               [UtilitiesHelper showErrorAlert:error];
                           }
                   }];

}

#pragma mark - UIWebView Delegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [UtilitiesHelper showLoader:@"Loading" forView:self.view setMode:MBProgressHUDModeIndeterminate delegate:nil];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UtilitiesHelper hideLoader:self.view];
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
