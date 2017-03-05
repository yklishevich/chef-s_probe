//
//  VideoViewCell.h
//  MeasureTemprature
//
//  Created by Akber Sayani on 25/09/2016.
//  Copyright © 2016 Akber Sayani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTPlayerView.h"

@interface VideoViewCell : UITableViewCell

@property(nonatomic,weak) IBOutlet UILabel *lblText;

@property(nonatomic,strong) UITableView *tableView;
- (void)loadVideoFromId:(NSString *)videoId;

@end
