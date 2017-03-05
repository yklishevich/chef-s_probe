//
//  PhotoArchiveViewCell.h
//  MeasureTemprature
//
//  Created by Akber Sayani on 19/09/2016.
//  Copyright © 2016 Akber Sayani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoArchiveViewCell : UITableViewCell

@property(nonatomic,weak) IBOutlet UIView *containerView;
@property(nonatomic,weak) IBOutlet UIImageView *tempratureImageView;
@property(nonatomic,weak) IBOutlet UILabel *lblTemprature;
@property(nonatomic,weak) IBOutlet UILabel *lblDate;
@property(nonatomic,weak) IBOutlet UILabel *lblLocation;
@property(nonatomic,weak) IBOutlet UILabel *lblDescription;

- (void)loadImageFromPath:(NSString *)path;

@end
