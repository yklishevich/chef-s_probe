//
//  PhotoArchive.h
//  MeasureTemprature
//
//  Created by Akber Sayani on 19/09/2016.
//  Copyright © 2016 Akber Sayani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoArchive : NSObject

@property(nonatomic,strong) NSString *imagePath;
@property(nonatomic,strong) NSString *temprature;
@property(nonatomic,strong) NSString *date;
@property(nonatomic,strong) NSString *location;
@property(nonatomic,strong) NSString *details;

@end
