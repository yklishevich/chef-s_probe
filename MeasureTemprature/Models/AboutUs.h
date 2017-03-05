//
//  AboutUs.h
//  
//
//  Created by Akber Sayani on 06/11/2016.
//  Copyright (c) 2016 Sayani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServiceModel.h"

@class AboutUsConcrete;

@interface AboutUs : NSObject {
    AboutUsConcrete *aboutus;
    NSString *status;
}

@property (nonatomic, strong) AboutUsConcrete *aboutus;
@property (nonatomic, copy) NSString *status;

+ (AboutUs *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

+ (void)getAboutUs:(NSDictionary *)params
     WithURLString:(NSString *)urlPath
            onView:(UIView *)loaderOnView
          response:(void (^)(AboutUs *response, NSError *error))block;

@end
