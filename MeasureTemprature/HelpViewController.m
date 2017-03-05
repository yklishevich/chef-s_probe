//
//  HelpViewController.m
//  MeasureTemprature
//
//  Created by Akber Sayani on 25/09/2016.
//  Copyright © 2016 Akber Sayani. All rights reserved.
//

#import "HelpViewController.h"
#import "VideoViewCell.h"
#import "HiLife.h"
#import "HilifeConcrete.h"
#import "Anleitung.h"
#import "AnleitungConcrete.h"
#import "Constants.h"
#import "UtilitiesHelper.h"
#import "AboutUsViewController.h"

@interface HelpViewController () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic,weak) IBOutlet UITableView *tableView;

@property(nonatomic,strong) NSArray *arrHilife;
@property(nonatomic,strong) NSArray *arrAnleitung;

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100.0;
    
    self.tableView.tableFooterView = nil;
    
    if (self.contentType == kLoadPDF) {
        [self getPDFs];
    } else
        if (self.contentType == kLoadVideo) {
            [self getVideos];
        }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getVideos {
    
    [HiLife getHiLife:@{@"action":kWebGetHilife}
        WithURLString:@""
               onView:self.view
             response:^(HiLife *response, NSError *error) {
                 if (response) {
                     self.arrHilife = response.hilife;
                     [self.tableView reloadData];
                 }
                 else {
                     if (error) {
                         [UtilitiesHelper showErrorAlert:error];
                     }
                 }
             }];
}

- (void)getPDFs {
    
    [Anleitung getAnleitung:@{@"action":kWebGetAnleitung}
              WithURLString:@""
                     onView:self.view
                   response:^(Anleitung *response, NSError *error) {
                       if (response) {
                           self.arrAnleitung = response.hilife;
                           [self.tableView reloadData];
                       } else
                           if (error) {
                               [UtilitiesHelper showErrorAlert:error];
                           }
                   }];
}

- (NSString *)getVideoIdFromURL:(NSString *)urlString {
    
    NSString *videoURL = urlString;
    NSURLComponents *components = [NSURLComponents componentsWithString:videoURL];
    NSString *videoId = nil;
    for(NSURLQueryItem *item in components.queryItems)
    {
        if([item.name isEqualToString:@"v"])
            videoId = item.value;
    }
    
    return videoId;
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (self.contentType) {
        case kLoadPDF:
            return self.arrAnleitung.count;
    
        case kLoadVideo:
            return self.arrHilife.count;
        
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.contentType == kLoadPDF) {
        static NSString *identifier = @"PDFCellIdentifier";
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                       reuseIdentifier:identifier];
        
        AnleitungConcrete *objAnleitung = [self.arrAnleitung objectAtIndex:indexPath.row];
        cell.textLabel.text = objAnleitung.descriptionText;
        cell.textLabel.font = [UIFont systemFontOfSize:17.0];
        
        return cell;
        
    } else
        if (self.contentType == kLoadVideo) {
            static NSString *identifier = @"VideoCellIdentifier";
            VideoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier
                                                                  forIndexPath:indexPath];
            
            HilifeConcrete *hilife = [self.arrHilife objectAtIndex:indexPath.row];
            if (hilife.video
                && hilife.video.length > 0) {
                
                NSString *videoId = [self getVideoIdFromURL:hilife.video];
                if (videoId) {
                    [cell loadVideoFromId:videoId];
                }
            }
            
            cell.lblText.text = hilife.text;
            return cell;
        }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = 44.0;
    
    if (self.contentType == kLoadVideo) {
        
        HilifeConcrete *hilife = [self.arrHilife objectAtIndex:indexPath.row];
        
        UIFont *font = [UIFont systemFontOfSize:17.0];
        
        CGSize constrainedSize = CGSizeMake(tableView.frame.size.width - 24.0, FLT_MAX);
        CGRect labelRect = [hilife.text boundingRectWithSize:constrainedSize
                                                     options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                  attributes:@{NSFontAttributeName:font}
                                                     context:nil];
        
        height += labelRect.size.height;
        
        if (hilife.video
            && hilife.video.length > 0) {
            CGFloat heightVideoPlayer = tableView.frame.size.width * 0.46; // 13:6 ratio
            height += heightVideoPlayer;
        }
        
    } else
        if (self.contentType == kLoadPDF) {
            AnleitungConcrete *objAnleitung = [self.arrAnleitung objectAtIndex:indexPath.row];
            
            UIFont *font = [UIFont systemFontOfSize:17.0];

            CGSize constrainedSize = CGSizeMake(tableView.frame.size.width - 24.0, FLT_MAX);
            CGRect labelRect = [objAnleitung.descriptionText boundingRectWithSize:constrainedSize
                                                         options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                      attributes:@{NSFontAttributeName:font}
                                                         context:nil];
            
            height += labelRect.size.height;
        }
    
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.contentType == kLoadPDF) {

        AnleitungConcrete *objAnleitung = [self.arrAnleitung objectAtIndex:indexPath.row];
        if ([UtilitiesHelper checkForEmptySpacesInString:objAnleitung.document]) {
            // Load pdf in a webview
            AboutUsViewController *controller = [self.storyboard
                                                 instantiateViewControllerWithIdentifier:@"AboutUsViewController"];

            controller.webContentType = kLoadFromURL;
            controller.loadURL = objAnleitung.document;
            [self.navigationController pushViewController:controller animated:YES];
            
        } else {
            [UtilitiesHelper showPromptAlertforTitle:@"Error"
                                         withMessage:@"PDF not found" forDelegate:nil];
        }
    }
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
