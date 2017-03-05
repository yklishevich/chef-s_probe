//
//  BaseSharedPreference.h
//  MeasureTemprature
//
//  Created by Akber Sayani on 19/09/2016.
//  Copyright © 2016 Akber Sayani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotoArchive.h"

@interface BaseSharedPreference : NSObject

+ (instancetype)sharedInstance;

- (NSArray *)getPhotoArchives;
- (void)savePhotoArchive:(PhotoArchive *)photoarchive;
- (void)updatPhotoAchives:(NSArray *)photoArchives;

@end
