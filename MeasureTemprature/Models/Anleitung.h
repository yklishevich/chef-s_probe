//
//  Anleitung.h
//  
//
//  Created by Akber Sayani on 06/11/2016.
//  Copyright (c) 2016 Sayani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServiceModel.h"

@interface Anleitung : NSObject {
    NSArray *hilife;
    NSString *status;
}

@property (nonatomic, copy) NSArray *hilife;
@property (nonatomic, copy) NSString *status;

+ (Anleitung *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

+ (void)getAnleitung:(NSDictionary *)params
       WithURLString:(NSString *)urlPath
              onView:(UIView *)loaderOnView
            response:(void (^)(Anleitung *response, NSError *error))block;


@end
