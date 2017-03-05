//
//  VideoViewCell.m
//  MeasureTemprature
//
//  Created by Akber Sayani on 25/09/2016.
//  Copyright © 2016 Akber Sayani. All rights reserved.
//

#import "VideoViewCell.h"
#import "UIView+UpdateAutoLayoutConstraints.h"


@interface VideoViewCell()

@property(nonatomic,strong) NSString *videoId;
@property(nonatomic,strong) IBOutlet YTPlayerView *playerView;

@end

@implementation VideoViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadVideoFromId:(NSString *)videoId {
    
    if (self.videoId == nil
        || ![self.videoId isEqualToString:videoId]) {
        
        self.videoId = videoId;
        [self.playerView loadWithVideoId:videoId];
    }
}

@end
