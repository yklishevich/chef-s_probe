//
//  BaseSharedPreference.m
//  MeasureTemprature
//
//  Created by Akber Sayani on 19/09/2016.
//  Copyright © 2016 Akber Sayani. All rights reserved.
//

#import "BaseSharedPreference.h"
#import "NSUserDefaults+RMSaveCustomObject.h"

@implementation BaseSharedPreference

+ (instancetype)sharedInstance {
    
    static BaseSharedPreference *_sharedClient = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedClient = [[BaseSharedPreference alloc] init];
    });
    
    return _sharedClient;
}

- (NSArray *)getPhotoArchives {
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    id value = [userdefault rm_customObjectForKey:@"PhotoArchive"];
    return value?:[[NSArray alloc] init];
}

- (void)savePhotoArchive:(PhotoArchive *)photoarchive {
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    
    NSMutableArray *arrArchives = [[NSMutableArray alloc] init];
    [arrArchives addObjectsFromArray:[self getPhotoArchives]];
    [arrArchives addObject:photoarchive];
    
    [userdefault rm_setCustomObject:arrArchives forKey:@"PhotoArchive"];
}

- (void)updatPhotoAchives:(NSArray *)photoArchives {
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    
    [userdefault rm_setCustomObject:photoArchives forKey:@"PhotoArchive"];
}

@end
