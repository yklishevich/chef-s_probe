//
//  PhotoArchiveViewCell.m
//  MeasureTemprature
//
//  Created by Akber Sayani on 19/09/2016.
//  Copyright © 2016 Akber Sayani. All rights reserved.
//

#import "PhotoArchiveViewCell.h"

@implementation PhotoArchiveViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadImageFromPath:(NSString *)path {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tempratureImageView setImage:image];
        });
        
    });
}

@end
